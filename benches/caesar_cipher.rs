#[macro_use] extern crate criterion;
use criterion::Criterion;
use criterion::black_box;
use libcaesar::caesar;

fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("caesar (hello, world | 32)", |b| b.iter(|| caesar("hello, world", black_box(32))));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);