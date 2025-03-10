Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC9722D799;
	Mon, 10 Mar 2025 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627226; cv=none; b=b5G/uIKuxIEnHOPEqgerZq51DUy8x70IZqCFUZSPDieqIELJh+8EFDxB2bCr6ABqSh3lgOvpPNBhc/n8wZezi+lrH6gfscBeDevXZUID0w12qb/71TfSBH7GQMXjcMAMxh/E3n0RB4SN3Yumj3fq2ynmhbXBFAJ8DZBGSu2+i/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627226; c=relaxed/simple;
	bh=3FE5+vFXL3tgkXYn4yTMQW4BChK+6tBq+z0p3rZmVd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHT0qcCZOKVrPbMQ7rGdqAdiGatFc/iLk/Uf1yTBx/9ke8HY7vkGNaQd0MY3PE7xGsJyL03M3ljY97qk3hiGnitlMf8XIZWPTECjuGgOkQAXAyQOSz4NqgHG2SahRI9S8na7gJ6VwfYgiA1wF3SdewlQOVlvaUUnef6w8ItGwS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJvMO8eJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJvMO8eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B99C4CEE5;
	Mon, 10 Mar 2025 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627225;
	bh=3FE5+vFXL3tgkXYn4yTMQW4BChK+6tBq+z0p3rZmVd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJvMO8eJ/gviLIsf6PjkC7IiB8TrxmfQURRFwXR46UPzEY2XSlRoksrodY7hvPlra
	 pXJqQL2r17BgBEUWMGhEEobuWkdfJA6uxfC8HmoUrtrVYD4rzXhWxjLvWF4lLiqodu
	 EE+olvnnUFWxQ70RwMgHSVIobMH6a9k/TKrqZTIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 057/269] rust: alloc: update module comment of alloc.rs
Date: Mon, 10 Mar 2025 18:03:30 +0100
Message-ID: <20250310170459.998839771@linuxfoundation.org>
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

commit 8ae740c3917ff92108df17236b3cf1b9a74bd359 upstream.

Before we remove Rust's alloc crate, rewrite the module comment in
alloc.rs to avoid a rustdoc warning.

Besides that, the module comment in alloc.rs isn't correct anymore,
we're no longer extending Rust's alloc crate.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-28-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-//! Extensions to the [`alloc`] crate.
+//! Implementation of the kernel's memory allocation infrastructure.
 
 #[cfg(not(any(test, testlib)))]
 pub mod allocator;


