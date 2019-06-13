use libcaesar::caesar;

fn main() {
    use std::env;
    let mut args = env::args().skip(1); // skip program name
    let some_shuffle_by = args.next().and_then(|t| t.parse::<usize>().ok());
    let some_text = args.next();
    match (some_text, some_shuffle_by) {
        (Some(text), Some(shuffle_by)) => println!("{}", caesar(&*text, shuffle_by)),
        _ => println!("usage: caesar <num> <text>"),
    }
}
