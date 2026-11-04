Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827096;
	b=rSNSyXMSevE9bXL2P3rL+GyMUO5caGsRy8JHJJ5RwO/oS/SRWIyjL/Ay3sKA7w1GpcVq
	 772lDiLalxttHvSrSywTwkNojz9SlBFb8nrCByO8ebhYWg+7Bs1MMwXKUzeT5mx49Yt0h
	 j46swRKXAu8TXd7f+hCDtNQbUoqv0pbhcKcTJ9nIis0CkrMeVfj/BkU0rtnucnEhLlPYX
	 uL0Wf114FcpYV/lFKTuGbr8OYJ0ls7q+qcnzN2NrAs6KrQYUIHcAgFKE0ZmSGdWBJkf42
	 +m86sg2/Ly6/+URV6bTDynpWykAWnABvDiTCLGNtAz3xNdIG4jxw8wrgMLqWAC63WSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wHkduFuLYq9CtydURqa0KMGs2vX0KpJ/avErLxV2DvI=;
	b=QDeZ36WiFGpKai0QcyOoftomb76aUeTEnxoyImkD5LUTIp9fyjbJK1DLGqR8wsd8Kj8A
	 zdEOT8Zcc38O0KCvsCziEsK4JCdC9sDeU2P7q5N+XamjJYGxDvP1jwXPBKmo3jxBe5fSP
	 YCPck4i50LsCzE/QCfJlAJSfWabyCx1vZxl8DODvYKOiGexEJtwdKtipeIbGkX65IGFnh
	 uk9ouqEL1hrKmeKAtG91oENAEDJJ684sibeG7WURKEPE9iw1s18TxgK5Z+3xFcoJDp+jL
	 LN7jB+hfClP4uFWcn8nWcKCTQGseQHrLlnFNm1bj48KR7okdCv6ZExxbXTtwai+eqbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTCMDfEl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE7F6084192;
	Wed,  4 Nov 2026 21:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTCMDfEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFF1F000C1;
	Wed,  4 Nov 2026 21:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827095;
	bh=wHkduFuLYq9CtydURqa0KMGs2vX0KpJ/avErLxV2DvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTCMDfElEzTwHXWe4W4QzmRbiCdMccwkWaaGZawek2Q0a1REp0+S8VGgVWT2lR9na
	 TMgwyX3svs+eCTIVy4RoVg/y26b3J05sIO77eW4qwZlY2GhWl9McW/uESfqJRUJtJH
	 WzHe70Cz8nt6gutG1foT6MbMDb35uOZ2hJrWZpvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	wang lian <lianux.mm@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 193/547] rust: bindings: fix VM_MAYSHARE value
Date: Wed,  4 Nov 2026 16:06:17 -0500
Message-ID: <20261104211043.620750217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 7b5ba47d845f35b04937748a191a1772ffc1f288 upstream.

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
overrides to the rust bindings helper as the change performed in the commit
caused rust bindgen to not be able to automatically determine values of
VMA flags.

However a typo was introduced leaving VM_MAYSHARE to be incorrectly
interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260113192949.689834-1-lorenzo.stoakes@oracle.com
[ Reworded to improve title and to fix typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/bindings_helper.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -138,7 +138,7 @@ const vm_flags_t RUST_CONST_HELPER_VM_SH
 const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
 const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
 const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
-const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYSHARE;
 const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
 const vm_flags_t RUST_CONST_HELPER_VM_IO = VM_IO;
 const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY = VM_DONTCOPY;


