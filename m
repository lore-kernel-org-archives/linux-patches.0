Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C07920DD67;
	Fri,  7 Mar 2025 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387896; cv=none; b=YqK1jvHbWz3CVWO/pSd+WCqrSlCRJ0jCA3Otq7q5Gpj79yAcowH/rhqajmKAsjdTYX5pddYr7QiIfWkJ66ko53axUn5VBpjvn8UPyDOFlYscFiidlu48oxe04ZTbCwy2uoSkZOXVWANSMQE8bDiS4ko9JM525rOu1rQWrB9pGZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387896; c=relaxed/simple;
	bh=gmsTvVNHRbZ/1Z4ZOF4xG45Ni0nwh19MbfLAxukgsSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9Lz6QCd4fbRkocH5nOWEKF3yJxGP6IDnk0/5arDDFipuvYUk8HVvZ85lxsUQuTQWEyRdXOHZ0wUIQkZXrSbLmN24BbXfnEW+hL0t9JndsWRNe5MA9w2DpyHcYciUt+oe/PtKDN13xPzucPjC1awNv5xyZstFN068qMu6d1Omus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meUcynsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meUcynsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB12FC4CEE3;
	Fri,  7 Mar 2025 22:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387896;
	bh=gmsTvVNHRbZ/1Z4ZOF4xG45Ni0nwh19MbfLAxukgsSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meUcynsLVbCdXCGT1mD2Q/2bp6HuuxZGi6iuARTV/OSdf0K3lwSuc741k4Cl54iSj
	 bAxUPUEoSgWXieDvY/I0pHF5h9ReMXMEtVe5IvBpjQGXzMUS8dd+xwIYcnZsexsd75
	 hoSR9XUInRGgT8ad4ijr6nPlMPPhykedD27euf1Zq48N9GkAYt9FjuNOpFHs8SMcFk
	 J9EODlUxEQwxb33rJG+65CcCRvg6X9GtxYhtrJdQjbYsHUSa2O2uAHbx3r0ATqyPDZ
	 VmqgHJVUiNoQrtNKxcfPOI9iaCnleTiw+diw3D0WQYAQwtwfL+bpIY1E/lK9j+Pjfv
	 hYcvooiCPmzNQ==
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
Subject: [PATCH 6.12.y 22/60] rust: alloc: rename `KernelAllocator` to `Kmalloc`
Date: Fri,  7 Mar 2025 23:49:29 +0100
Message-ID: <20250307225008.779961-23-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 941e65531446c1eb5d573c5d30172117ebe96112 upstream.

Subsequent patches implement `Vmalloc` and `KVmalloc` allocators, hence
align `KernelAllocator` to this naming scheme.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-4-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/allocator.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 765f72d5bc21..3b1c735ba409 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -6,7 +6,7 @@
 use core::alloc::{GlobalAlloc, Layout};
 use core::ptr;
 
-struct KernelAllocator;
+struct Kmalloc;
 
 /// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
 fn aligned_size(new_layout: Layout) -> usize {
@@ -37,7 +37,7 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: F
 }
 
 // SAFETY: TODO.
-unsafe impl GlobalAlloc for KernelAllocator {
+unsafe impl GlobalAlloc for Kmalloc {
     unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
         // SAFETY: `ptr::null_mut()` is null and `layout` has a non-zero size by the function safety
         // requirement.
@@ -74,7 +74,7 @@ unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
 }
 
 #[global_allocator]
-static ALLOCATOR: KernelAllocator = KernelAllocator;
+static ALLOCATOR: Kmalloc = Kmalloc;
 
 // See <https://github.com/rust-lang/rust/pull/86844>.
 #[no_mangle]
-- 
2.48.1

