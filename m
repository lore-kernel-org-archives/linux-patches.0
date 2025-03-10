Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862B52309A6;
	Mon, 10 Mar 2025 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627182; cv=none; b=HGc2pKrv6YuLqCIThRMtOxi67hUlgwAPRiJEWBMU8srfGlUFKIkxzqVAlthypiChZ7u+hfaRPjyMdZtFoEObUhHsOnZnJTe8YcXPorIWlKa2T4mpseL+3nDwJvKMTmKt2McB1HjgYXt1ftszqlajOFSsaOZdIn5Rc5k81By+mBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627182; c=relaxed/simple;
	bh=+hjD7Yajeufz/eknvT3Ur1RJWiDAr4XUwRkxs97J8Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evZ3wmfncQpmXVit6sfdRv5fGCJ4Hqa7bOX14ZRmoYJXMLBbNZ1IE2PFja2iucBoE6CzrQ31Cy4U2VHyUm1W88IAa5TzqOa/NSnLRQD7q8ST6cPUmxR9dV52suXHnYTQu0CIlu8x3+8RYpgvWx3HVNiFlLA26NaaUlrkZNIvuQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBSdQh2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBSdQh2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB9C4CEE5;
	Mon, 10 Mar 2025 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627182;
	bh=+hjD7Yajeufz/eknvT3Ur1RJWiDAr4XUwRkxs97J8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBSdQh2Y+j/mhiV84nx8VP3W43yAFBXozZrjJ7mISsnFgMm6RIYVP8dCXjCcChFBn
	 rT3HumaF9IAyQru08n+voWVylHBil38D3Dw2gvMc/YXsbeFKiXacOWa5LQd5HuZAN/
	 uHJlqu5qFljiS+sXarx+YBoJZEUIhOMbjZ1/ll7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 040/269] rust: alloc: add __GFP_NOWARN to `Flags`
Date: Mon, 10 Mar 2025 18:03:13 +0100
Message-ID: <20250310170459.318168100@linuxfoundation.org>
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

commit 01b2196e5aac8af9343282d0044fa0d6b07d484c upstream.

Some test cases in subsequent patches provoke allocation failures. Add
`__GFP_NOWARN` to enable test cases to silence unpleasant warnings.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-11-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/bindings_helper.h |    1 +
 rust/kernel/alloc.rs            |    5 +++++
 2 files changed, 6 insertions(+)

--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -31,4 +31,5 @@ const gfp_t RUST_CONST_HELPER_GFP_KERNEL
 const gfp_t RUST_CONST_HELPER_GFP_NOWAIT = GFP_NOWAIT;
 const gfp_t RUST_CONST_HELPER___GFP_ZERO = __GFP_ZERO;
 const gfp_t RUST_CONST_HELPER___GFP_HIGHMEM = ___GFP_HIGHMEM;
+const gfp_t RUST_CONST_HELPER___GFP_NOWARN = ___GFP_NOWARN;
 const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL;
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -91,6 +91,11 @@ pub mod flags {
     /// use any filesystem callback.  It is very likely to fail to allocate memory, even for very
     /// small allocations.
     pub const GFP_NOWAIT: Flags = Flags(bindings::GFP_NOWAIT);
+
+    /// Suppresses allocation failure reports.
+    ///
+    /// This is normally or'd with other flags.
+    pub const __GFP_NOWARN: Flags = Flags(bindings::__GFP_NOWARN);
 }
 
 /// The kernel's [`Allocator`] trait.


