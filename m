Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89FDA934
	for <patches@lists.linux.dev>; Sun,  9 Mar 2025 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741524588; cv=none; b=N7Aa1RyB5zAMGsKOMEx6H3EBLVHbG+MTSlYRE8lrXfVJ+TZY0a/NWTfTo86sZS0vYAMa+hRLn53ZJPO1N2ZmcSzpD7EkbMfuiKF0mPMM7X8wtH7PBR3xKqN4MuJx1PMc6wfucxavy6Snp/uO7DUtaUiJAfuTZC/111wBrDSBJ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741524588; c=relaxed/simple;
	bh=iy6t4oyM9xmi9DgI4b5OIyueTJghTJtBIylEhXhmP/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+IN58lGKPecjviysNLLZbYWeWE1JDWZc7dE8lEzKbZZKRyVhj4s0u4ZsvmZlnnV18D/K350jIyNs/o7KD86aTGP3Uwq+EBe6RnCh6zpdaUy/fH5y7hO2/X4uKkbB+YmgHVKFBAZo/tO0uTEdK+hCzrOgPE/xn5weQfyYSln++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=XWuRdPlA; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="XWuRdPlA"
Received: from mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:797:0:640:5446:0])
	by forward502b.mail.yandex.net (Yandex) with ESMTPS id DF38460CF1;
	Sun,  9 Mar 2025 15:42:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id wfnPP5mLoeA0-rVz0gawF;
	Sun, 09 Mar 2025 15:41:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1741524120; bh=Fmlf9rTNzjTKYC7fGgDKsvoi6EYWuiAAdTrT2ktfLro=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=XWuRdPlA922w4t/EnsrNC1ZAl1uTnQSpx4LvyHAoS4/t1v5lv2qpAETPBEfHju5Lw
	 xKBd/LZ9Sjql+dNcdei3wX2thJZPMNo7VX1UYlUt/zOvMlkYfmqooMzlzLLDa1i8cu
	 cT8TBQ4LMt9ES/qgRxe2ChFNV0XZaPD9KV/DtfHE=
Authentication-Results: mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Message-ID: <33f6c73c-4a2d-42b3-b033-921d2e1eaeac@0upti.me>
Date: Sun, 9 Mar 2025 15:41:57 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y 00/60] `alloc`, `#[expect]` and "Custom FFI"
To: Miguel Ojeda <ojeda@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>,
 patches@lists.linux.dev
References: <20250307225008.779961-1-ojeda@kernel.org>
Content-Language: en-US
From: Ilya K <me@0upti.me>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, I think this is missing one final change, specifically 27c7518e, 
or rather, the only line of it that applies:

 pub unsafe extern "C" fn drm_panic_qr_generate(
-    url: *const i8,
+    url: *const kernel::ffi::c_char,

Without it, the build fails on Rust 1.85 / aarch64.

On 2025-03-08 01:49, Miguel Ojeda wrote:
> Hi Greg, Sasha,
> 
> Please consider this series for 6.12.y. It should apply cleanly on top
> of v6.12.18.
> 
> These are the patches to backport the `alloc` series for Rust, which
> will be useful for Rust Android Binder and others. It also means that,
> with this applied, we will not rely on the standard library `alloc` (and
> the unstable `cfg` option we used) anymore in any stable kernel that
> supports several Rust versions, so e.g. upstream Rust could consider
> removing that `cfg` if they needed.
> 
> The entire series of cherry-picks apply almost cleanly (only 2 trivial
> conflicts) -- to achieve that, I included the `#[expect]` support, which
> will make future backports that use that feature easier anyway. That
> series also enabled some Clippy warnings. We could reduce the series,
> but the end result is warning-free and Clippy is opt-in anyway.
> Out-of-tree code could, of course, see some warnings if they use it.
> 
> I also included a bunch of Clippy warnings cleanups for the DRM QR Code
> to have this series clean up to Rust 1.85.0 (the latest stable), but
> I could send them separately if needed.
> 
> Finally, I included the "Custom FFI" series backport, which in turn
> solves the arm64 + Rust 1.85.0 + `CONFIG_RUST_FW_LOADER_ABSTRACTIONS=y`
> issue. It will also make future patches easier to backport, since we
> will have the same `ffi::` types.
> 
> I tested that the entire series builds between every commit for x86_64
> `LLVM=1` with the latest stable and minimum supported Rust compiler
> versions. I also ran my usual stable kernel tests on the end result;
> that is, boot-tested in QEMU for several architectures etc. In v6.12.18
> for loongarch there is an unrelated error that was not there in v6.12.17
> when I did a previous test run -- reported separately.
> 
> Things could still break, so extra tests on the next -rc from users in
> Cc here would be welcome -- thanks!
> 
> Cheers,
> Miguel
> 
> Asahi Lina (1):
>   rust: alloc: Fix `ArrayLayout` allocations
> 
> Benno Lossin (1):
>   rust: alloc: introduce `ArrayLayout`
> 
> Danilo Krummrich (28):
>   rust: alloc: add `Allocator` trait
>   rust: alloc: separate `aligned_size` from `krealloc_aligned`
>   rust: alloc: rename `KernelAllocator` to `Kmalloc`
>   rust: alloc: implement `ReallocFunc`
>   rust: alloc: make `allocator` module public
>   rust: alloc: implement `Allocator` for `Kmalloc`
>   rust: alloc: add module `allocator_test`
>   rust: alloc: implement `Vmalloc` allocator
>   rust: alloc: implement `KVmalloc` allocator
>   rust: alloc: add __GFP_NOWARN to `Flags`
>   rust: alloc: implement kernel `Box`
>   rust: treewide: switch to our kernel `Box` type
>   rust: alloc: remove extension of std's `Box`
>   rust: alloc: add `Box` to prelude
>   rust: alloc: implement kernel `Vec` type
>   rust: alloc: implement `IntoIterator` for `Vec`
>   rust: alloc: implement `collect` for `IntoIter`
>   rust: treewide: switch to the kernel `Vec` type
>   rust: alloc: remove `VecExt` extension
>   rust: alloc: add `Vec` to prelude
>   rust: error: use `core::alloc::LayoutError`
>   rust: error: check for config `test` in `Error::name`
>   rust: alloc: implement `contains` for `Flags`
>   rust: alloc: implement `Cmalloc` in module allocator_test
>   rust: str: test: replace `alloc::format`
>   rust: alloc: update module comment of alloc.rs
>   kbuild: rust: remove the `alloc` crate and `GlobalAlloc`
>   MAINTAINERS: add entry for the Rust `alloc` module
> 
> Ethan D. Twardy (1):
>   rust: kbuild: expand rusttest target for macros
> 
> Filipe Xavier (2):
>   rust: error: make conversion functions public
>   rust: error: optimize error type to use nonzero
> 
> Gary Guo (3):
>   rust: fix size_t in bindgen prototypes of C builtins
>   rust: map `__kernel_size_t` and friends also to usize/isize
>   rust: use custom FFI integer types
> 
> Miguel Ojeda (17):
>   rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
>   rust: sort global Rust flags
>   rust: types: avoid repetition in `{As,From}Bytes` impls
>   rust: enable `clippy::undocumented_unsafe_blocks` lint
>   rust: enable `clippy::unnecessary_safety_comment` lint
>   rust: enable `clippy::unnecessary_safety_doc` lint
>   rust: enable `clippy::ignored_unit_patterns` lint
>   rust: enable `rustdoc::unescaped_backticks` lint
>   rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
>   rust: sync: remove unneeded
>     `#[allow(clippy::non_send_fields_in_send_ty)]`
>   rust: introduce `.clippy.toml`
>   rust: replace `clippy::dbg_macro` with `disallowed_macros`
>   rust: provide proper code documentation titles
>   rust: enable Clippy's `check-private-items`
>   Documentation: rust: add coding guidelines on lints
>   rust: start using the `#[expect(...)]` attribute
>   Documentation: rust: discuss `#[expect(...)]` in the guidelines
> 
> Thomas Böhler (7):
>   drm/panic: avoid reimplementing Iterator::find
>   drm/panic: remove unnecessary borrow in alignment_pattern
>   drm/panic: prefer eliding lifetimes
>   drm/panic: remove redundant field when assigning value
>   drm/panic: correctly indent continuation of line in list item
>   drm/panic: allow verbose boolean for clarity
>   drm/panic: allow verbose version check
> 
>  .clippy.toml                             |   9 +
>  .gitignore                               |   1 +
>  Documentation/rust/coding-guidelines.rst | 148 ++++
>  MAINTAINERS                              |   8 +
>  Makefile                                 |  15 +-
>  drivers/block/rnull.rs                   |   4 +-
>  drivers/gpu/drm/drm_panic_qr.rs          |  23 +-
>  mm/kasan/kasan_test_rust.rs              |   3 +-
>  rust/Makefile                            |  92 +--
>  rust/bindgen_parameters                  |   5 +
>  rust/bindings/bindings_helper.h          |   1 +
>  rust/bindings/lib.rs                     |   6 +
>  rust/exports.c                           |   1 -
>  rust/ffi.rs                              |  13 +
>  rust/helpers/helpers.c                   |   1 +
>  rust/helpers/slab.c                      |   6 +
>  rust/helpers/vmalloc.c                   |   9 +
>  rust/kernel/alloc.rs                     | 150 +++-
>  rust/kernel/alloc/allocator.rs           | 208 ++++--
>  rust/kernel/alloc/allocator_test.rs      |  95 +++
>  rust/kernel/alloc/box_ext.rs             |  89 ---
>  rust/kernel/alloc/kbox.rs                | 456 +++++++++++
>  rust/kernel/alloc/kvec.rs                | 913 +++++++++++++++++++++++
>  rust/kernel/alloc/layout.rs              |  91 +++
>  rust/kernel/alloc/vec_ext.rs             | 185 -----
>  rust/kernel/block/mq/operations.rs       |  18 +-
>  rust/kernel/block/mq/raw_writer.rs       |   2 +-
>  rust/kernel/block/mq/tag_set.rs          |   2 +-
>  rust/kernel/error.rs                     |  79 +-
>  rust/kernel/init.rs                      | 127 ++--
>  rust/kernel/init/__internal.rs           |  13 +-
>  rust/kernel/init/macros.rs               |  18 +-
>  rust/kernel/ioctl.rs                     |   2 +-
>  rust/kernel/lib.rs                       |   5 +-
>  rust/kernel/list.rs                      |   1 +
>  rust/kernel/list/arc_field.rs            |   2 +-
>  rust/kernel/net/phy.rs                   |  16 +-
>  rust/kernel/prelude.rs                   |   5 +-
>  rust/kernel/print.rs                     |   5 +-
>  rust/kernel/rbtree.rs                    |  49 +-
>  rust/kernel/std_vendor.rs                |  12 +-
>  rust/kernel/str.rs                       |  46 +-
>  rust/kernel/sync/arc.rs                  |  25 +-
>  rust/kernel/sync/arc/std_vendor.rs       |   2 +
>  rust/kernel/sync/condvar.rs              |   7 +-
>  rust/kernel/sync/lock.rs                 |   8 +-
>  rust/kernel/sync/lock/mutex.rs           |   4 +-
>  rust/kernel/sync/lock/spinlock.rs        |   4 +-
>  rust/kernel/sync/locked_by.rs            |   2 +-
>  rust/kernel/task.rs                      |   8 +-
>  rust/kernel/time.rs                      |   4 +-
>  rust/kernel/types.rs                     | 140 ++--
>  rust/kernel/uaccess.rs                   |  23 +-
>  rust/kernel/workqueue.rs                 |  29 +-
>  rust/macros/lib.rs                       |  14 +-
>  rust/macros/module.rs                    |   8 +-
>  rust/uapi/lib.rs                         |   6 +
>  samples/rust/rust_minimal.rs             |   4 +-
>  samples/rust/rust_print.rs               |   1 +
>  scripts/Makefile.build                   |   4 +-
>  scripts/generate_rust_analyzer.py        |  11 +-
>  61 files changed, 2482 insertions(+), 756 deletions(-)
>  create mode 100644 .clippy.toml
>  create mode 100644 rust/ffi.rs
>  create mode 100644 rust/helpers/vmalloc.c
>  create mode 100644 rust/kernel/alloc/allocator_test.rs
>  delete mode 100644 rust/kernel/alloc/box_ext.rs
>  create mode 100644 rust/kernel/alloc/kbox.rs
>  create mode 100644 rust/kernel/alloc/kvec.rs
>  create mode 100644 rust/kernel/alloc/layout.rs
>  delete mode 100644 rust/kernel/alloc/vec_ext.rs
> 
> --
> 2.48.1

