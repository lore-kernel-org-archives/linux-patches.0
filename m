Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024884;
	b=IWW9mOlBTr7FOCZi7WQy4K0stZ0HI81/dK7eymZ55GaEE/Fi1+xNadLyAkSnx4KNR6Ym
	 o02VzUdUysWlHyE0xBUhKLS1AuR3rZBW0lF35MOxe8REh6Je69alCSM2WUiGuc3XWf2iH
	 NxSKXferL8vm/DS5t1Of6rH2BSgH85P15h5CXlKzImGWT2T9+zolEaIWYC8ERAqT5wwRb
	 aRkTvOyhZIet4InLuh6ZIbJj6yX+CTlViIGsI+sBteLIF/BANQ6LCm+pW+h8P/LeQXazh
	 rfzeVL+/MiILfOmwxbBEcnJojkVajutwDr00joEKS7DxwZ5sFOKYHbaeT1kTQ1RrfnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eloTKkAmezMqXJWJNGAEKAOSonvSjK/FT8ic/l2tG+g=;
	b=VG7HLVknFD+0fFESwv42p3c++sx5g3Ji7Nl/x2z9ed8aa5diraKXrD7/2+9iFriOslbc
	 HCAAwzi5QFDe+8kUAKWRpm8xx+RkrUPanvDSZkdx/WU2kRztbAJ5VYzogWzXtD3loZFj3
	 l9N+Pw+cheA1Nc2lmCMxD3Y4g55wAvAOe/OlSdtmtpIr60USfmU4bAv+HO6oADB7Mv3in
	 lsXRGLBnglEctj+UQQSkMY7QYuy69AUSgwXow4BMn9C54mj+WE1G0QlVgFzYgddwYPGjF
	 LoC3PCS8SOmRsYmKJjxa67gTVV9TfcPQXwwWqWCNCMe5yF1VkqfJDczkFSlNOKw5lbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BbVxLef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8745F606A31C;
	Wed, 18 Nov 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BbVxLef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B9C1F000C4;
	Wed, 18 Nov 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024884;
	bh=eloTKkAmezMqXJWJNGAEKAOSonvSjK/FT8ic/l2tG+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BbVxLefeihoAuf164Zlf4vGIEdcED40qKlV4o6FFFYozns0ZzFF5XbzlD3IsW/F9
	 zJaD+sAHOMHnO9wwUWmM+q5UrnTiHpEcw+lHjm6IFULgaWvsVzZPuQQI9xfItynEAB
	 z3ALmnlU0iUTV6CJclS+jKECQU5yOfh+5HdJUEhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0884/2151] RDMA/cxgb4: Do not allow userspace to write the status page
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150154.505733436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1c5335a6902639596a795705349da7f76027e103 ]

The device status page is shared by all userspace contexts and contains
db_off, which the driver updates to control doorbell flow. The rdma-core
provider maps it with PROT_READ, but c4iw_mmap() passes the requested page
protection through when handling CXGB4_MMAP_CONTIG.

A process can therefore request PROT_WRITE directly or later upgrade a
read-only mapping with mprotect() because VM_MAYWRITE remains set. This
lets userspace alter device-wide flow-control state seen by the kernel and
other contexts.

Reject initially writable mappings and clear VM_MAYWRITE before mapping the
page. This preserves the existing read-only userspace ABI.

Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926112611.3214382-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index e059f92d90fd4..4b2c7ec348176 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -171,6 +171,11 @@ static int c4iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 					 len, t4_pgprot_wc(vma->vm_page_prot));
 		break;
 	case CXGB4_MMAP_CONTIG:
+		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
+			ret = -EPERM;
+			break;
+		}
+		vm_flags_clear(vma, VM_MAYWRITE);
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 addr >> PAGE_SHIFT,
 					 len, vma->vm_page_prot);
-- 
2.53.0



