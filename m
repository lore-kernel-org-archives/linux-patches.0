Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC072309B0;
	Mon, 10 Mar 2025 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627199; cv=none; b=qxxz3OX09ISLQAT00iJYzcHveGPP3Pk15uLHyfZjYN7GgvfpQsmNq6fLsFdnWHIbytMhQn4ZdbNgIo4l9R1fyfSIJ8qVQdjfeIGxH2RFKNbqX4aOYbUBz9BgRhYyIdlQg9Hxm89A4YM9/s1NrmVJbSpYR+nPlmYCr0nExAAB/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627199; c=relaxed/simple;
	bh=Bttj9dlR5V76eNTwEKP7XGMuZMmLViO+ftd2oun0gGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpPggGIUHSm8S09DXvEFjH8dJ8GGN1QbIhcl338eDzNyB6HwKWaEIVVei/qtide8b7G6gK01Vk91Wpj0khcNL0f97oMUIU3qiK574Aa6aLqa3Fzj9T5Tfy7bIwtwwBN6vYwSSJBnMaGF3uCVVIat2LrCVwr2lnkNBk4qiu4vTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiVVSwm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiVVSwm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2915EC4CEE5;
	Mon, 10 Mar 2025 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627199;
	bh=Bttj9dlR5V76eNTwEKP7XGMuZMmLViO+ftd2oun0gGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiVVSwm9ye1YMx/oF/DauAlOO7juN3zfBM6QUOZcy8HFWJORS8dieLqqUNbLkE+Hq
	 PzUm0udwDdV3CRfF1Efd0SlWAA2uMkp1kDyMOGq/t/5xWfXNOIRw1cPRUcX/C7R/DJ
	 t6lsxzwqRpM85u/pUxajqOdJby4/RpkKyEiWCIjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 016/269] rust: enable `clippy::unnecessary_safety_comment` lint
Date: Mon, 10 Mar 2025 18:02:49 +0100
Message-ID: <20250310170458.355020653@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                 |    1 +
 rust/kernel/sync/arc.rs  |    2 +-
 rust/kernel/workqueue.rs |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -459,6 +459,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
+			    -Wclippy::unnecessary_safety_comment \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -338,7 +338,7 @@ impl<T: 'static> ForeignOwnable for Arc<
     }
 
     unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
-        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
+        // By the safety requirement of this function, we know that `ptr` came from
         // a previous call to `Arc::into_foreign`.
         let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
 
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -526,7 +526,7 @@ where
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
@@ -573,7 +573,7 @@ where
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };


