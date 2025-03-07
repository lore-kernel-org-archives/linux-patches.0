Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B07A18BC36;
	Fri,  7 Mar 2025 22:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387850; cv=none; b=jlZ3Fitph5ffwfQXHWSN/WHpMlZ2d+IVXoBdks98iZ00a8K+H3FlZP52UgYJSSf3rUhIrCFNskQJiLieDoE6D6O3oeqsf6mMWAxCyPajnxm0WSkc7QukjAchbC6Ubfy6kvZtFRhSJeDKZV8OJiMXZPtmLWm5L9+oTECXlzFdBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387850; c=relaxed/simple;
	bh=jdYz/tXYYjSd+r9uG/d2mRQ+04VY1RMxksV7k9ZXusI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNgxId8Da3x0uuvKEyIWIq/1FqtnY7kRagl30UaNFEfpapXucFjxPYmJ/HoNocueVfczMVNAYphfeTtgp1lEtJ8x1fd2YRtsweKlXXF6blUSIj6z2TAptYAVEm7ww4NR1LyfdVMZa/dNsz0qFoGUB2l3b+W+TVtdohY/ahU+aSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBfZu+Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBfZu+Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1E7C4CEE8;
	Fri,  7 Mar 2025 22:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387849;
	bh=jdYz/tXYYjSd+r9uG/d2mRQ+04VY1RMxksV7k9ZXusI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBfZu+QlWsQtNzyQisMjDPyhthkLvzUc2nEGh4YzEv2N082j52INd+Q5FeS4rYb5T
	 +0govgqtmXsZqoethcuOnNCv7zyq4PCMRNUQhfaHoqb55mi/HtDWhIE3BB5TldfLG9
	 I+0dMtGRHkIPYXXCq4vu1dCtePeaGoR9Hf7JPFtzv4J1xi1JVyVFNhOHEVnIyoF4aO
	 eyIMLsWt25OmCdeCP/r0mT4lb8Vexk4R7JO5Ymb2+E2uQiCvIjtgCbapyz1dSABSBd
	 GxDAPARssJ+xOoq8fAS54Gf9FbmsY3+7QQjtGBZUMqnY3EsjZaRVC0dRROuqR95lGF
	 8CvsdHa1m/hNQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 05/60] rust: enable `clippy::unnecessary_safety_comment` lint
Date: Fri,  7 Mar 2025 23:49:12 +0100
Message-ID: <20250307225008.779961-6-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit c28bfe76e4ba707775a205b0274710de7aa1e31c upstream.

In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
where safe code has a `// SAFETY` comment attached.

The lint currently finds 3 places where we had such mistakes, thus it
seems already quite useful.

Thus clean those and enable it.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_comment [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-6-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile                 | 1 +
 rust/kernel/sync/arc.rs  | 2 +-
 rust/kernel/workqueue.rs | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index a491ba904601..295d52b677f8 100644
--- a/Makefile
+++ b/Makefile
@@ -459,6 +459,7 @@ export rust_common_flags := --edition=2021 \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
+			    -Wclippy::unnecessary_safety_comment \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 28743a7c74a8..9325cc5a16a4 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -338,7 +338,7 @@ fn into_foreign(self) -> *const core::ffi::c_void {
     }
 
     unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
-        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
+        // By the safety requirement of this function, we know that `ptr` came from
         // a previous call to `Arc::into_foreign`.
         let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
 
diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 3b3f1dbe8192..10d2bc62e2cf 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -526,7 +526,7 @@ unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
@@ -573,7 +573,7 @@ unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<Box<T>>
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
-- 
2.48.1

