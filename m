Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400612D77B;
	Tue, 14 May 2024 11:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686671; cv=none; b=P8Ks+LLvYvusjx72FTcQ65/QAr+yn+DVTU6k4uVd/N1oDWaHHvPna8RrPIoBDBBJEDtagESL3O6FlYmTUE1YQs/LojxiJN2l77w/SkZyvre3gfeR4WX43ibAPvk/XLCU5gCL0EtOuLp3rzm/7Gj9wJD30gUrFS6fnLwuujllqqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686671; c=relaxed/simple;
	bh=F7GDXgiBiSSyDL6oIvfiZ3wfoVtcrmo6rmYsU/ZMjhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU4qYy8MmkrKkNGYJq4oMCo45L0j1NyEYQuKpGQdwznGvBN4WL+oYKT9b/PrQg77klvHJfOvkNMbiNACev4kXEu9kC+Hm5P3okiKxKmhJ7mg2x/tLQo3TH3+7I14DjqqzFQ3nq44yjWMdQ6SiN2gKNNtLWPk+1FUB/9RKaxDBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH29T6aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH29T6aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80294C2BD10;
	Tue, 14 May 2024 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686670;
	bh=F7GDXgiBiSSyDL6oIvfiZ3wfoVtcrmo6rmYsU/ZMjhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH29T6aUARPbC6ri4YIpkaqSo9EGgcAn7fN4me88jKOx3XISJqf4V0g2lMVRMQDhE
	 HH2TR4R8TxnWxsyDxFhGb0mxhfU2SkH1IA2bw8cdmjyfDvFtaz6SDUf66iNxToKo/W
	 yFzsDeoULvaxUzObac8s8HLkRCZPkyRfEhN/dXTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Asahi Lina <lina@asahilina.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 187/236] rust: error: Rename to_kernel_errno() -> to_errno()
Date: Tue, 14 May 2024 12:19:09 +0200
Message-ID: <20240514101027.463010855@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asahi Lina <lina@asahilina.net>

commit 46384d0990bf99ed8b597e8794ea581e2a647710 upstream.

This is kernel code, so specifying "kernel" is redundant. Let's simplify
things and just call it to_errno().

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Asahi Lina <lina@asahilina.net>
Link: https://lore.kernel.org/r/20230224-rust-error-v3-1-03779bddc02b@asahilina.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs  |    2 +-
 rust/macros/module.rs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -25,7 +25,7 @@ pub struct Error(core::ffi::c_int);
 
 impl Error {
     /// Returns the kernel error code.
-    pub fn to_kernel_errno(self) -> core::ffi::c_int {
+    pub fn to_errno(self) -> core::ffi::c_int {
         self.0
     }
 }
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -258,7 +258,7 @@ pub(crate) fn module(ts: TokenStream) ->
                         return 0;
                     }}
                     Err(e) => {{
-                        return e.to_kernel_errno();
+                        return e.to_errno();
                     }}
                 }}
             }}


