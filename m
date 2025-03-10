Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55713230BC3;
	Mon, 10 Mar 2025 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627159; cv=none; b=WKqSYrFq8uzLnqxJbL8xD4PLYALojY/TjT6AVusRFOa5COBiJ9GrrkKp6HOKggAmHRpDQUovFeLa/QiUc/92+G1NUN+q6z+qRX4dAbIwYRZNtSST2jf8ARdC8KhnmlqUPFdLHVEQUd42J6cIs6hqqG4hiLcIoOQOGHHhDLq7DPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627159; c=relaxed/simple;
	bh=QkSuhVO7Elwt/BhLLv9ciO//GQKH4V+UCyKtUIpLUnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFl/lmWrvOKlfe+QD5cWIt9KWPKS/DkqWy8aS9hhVM6mgmaJOm/wq3k7CztsQ04n+R6CMwFi9Lw8QoFvZbqKhpvuxnUyJynjJyWQhRr6+iemcsIyLbLs+voHeT0bXblnhLeaN+ohLq8qmE6p/09HGwIACInyqI64Loo9JNS+ToM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WU/XAZoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WU/XAZoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23AEC4CEE5;
	Mon, 10 Mar 2025 17:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627159;
	bh=QkSuhVO7Elwt/BhLLv9ciO//GQKH4V+UCyKtUIpLUnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WU/XAZoY8Oxw3+CVbu8BANe8y/Pp+++e3E1Nd+vTewnKEmVoKdwqzxu/XQAiGMOfT
	 W7paBx61EeEwM/4hs2FRpB7bv1OkDSggz4Bggf1EXREPpeNsIe1uQeuVGZKefC/7oT
	 OuQNdCz8hEUorHaXfBwMLGpRn21klU7R3cz+vKDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 033/269] rust: alloc: rename `KernelAllocator` to `Kmalloc`
Date: Mon, 10 Mar 2025 18:03:06 +0100
Message-ID: <20250310170459.036825776@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/allocator.rs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -6,7 +6,7 @@ use super::{flags::*, Flags};
 use core::alloc::{GlobalAlloc, Layout};
 use core::ptr;
 
-struct KernelAllocator;
+struct Kmalloc;
 
 /// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
 fn aligned_size(new_layout: Layout) -> usize {
@@ -37,7 +37,7 @@ pub(crate) unsafe fn krealloc_aligned(pt
 }
 
 // SAFETY: TODO.
-unsafe impl GlobalAlloc for KernelAllocator {
+unsafe impl GlobalAlloc for Kmalloc {
     unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
         // SAFETY: `ptr::null_mut()` is null and `layout` has a non-zero size by the function safety
         // requirement.
@@ -74,7 +74,7 @@ unsafe impl GlobalAlloc for KernelAlloca
 }
 
 #[global_allocator]
-static ALLOCATOR: KernelAllocator = KernelAllocator;
+static ALLOCATOR: Kmalloc = Kmalloc;
 
 // See <https://github.com/rust-lang/rust/pull/86844>.
 #[no_mangle]


