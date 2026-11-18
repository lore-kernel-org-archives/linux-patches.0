Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017993;
	b=SXtdPw2sYnyw2mdes4Ns/iRsWlZYeHmBK1qbUDOX05gi3zJHlHx2CHBOUGY7/IHSZUwX
	 r/GUOj4JuSi3qzDHm1T/Zbv1DsiLRCa/mqgtyuMG6FN9XvCvuSO+jX8Yc3jsfGy087csS
	 SgPb1AIBu7DGO/E0McHWtpMPV9g/Nz2gT7V/ZuffnBvA1rk0D8PmURbjVhESBuZPUCUtk
	 UYNKlT2+qjsNibRDGZwL7/FTzCAVY3eRooy1CeNGnMTAjl5lkofBwQ+gFbMNDzczLvPqt
	 xYugh4tHKoIIvGIvMBGcjJtn6kXQBs9EG7/znsIHSiRMpVeVnUQOSrVJJBiqLSc5I3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPYLNUHXAwebsnlfZC2G0ISUiHOxYaRf5xA6/LZkuHk=;
	b=wP/6dQTYZMgNVvN0M0X7sfWAu2HRFQ6LWI0+dtE+oWMkZXtXIPlJ5icgeZgoBYxUYD1u
	 1ILcimLHiQoNnWNkSElYkZOdBUgBusG82OIHbfLuYAz80rbwpkES2d5G/0bOHR98cDs7R
	 51WY/mZnYj65mh41Ed0c1KLOAw9IMEyL7sPYlHqt23TfKQ6bGlTPUw5AXli3LlG/aKVJF
	 Sor8XS1NkfYiCwcWG5tCMLd9GqOqGXD57vpyD2vp6110QpA+YJbX2szaFEL3OZMeao8/h
	 XaZkgzsSRD6aKEiaFoZ2Clx+GprhMlR89OFngXXDb4mqRwNP7yUFsamSsKf4/tr2jlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2iEDoRN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A81606A31C;
	Wed, 18 Nov 2026 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2iEDoRN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E6E1F000C4;
	Wed, 18 Nov 2026 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017992;
	bh=sPYLNUHXAwebsnlfZC2G0ISUiHOxYaRf5xA6/LZkuHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2iEDoRNA4Lyo0s6e6RgSQkOtneCLATiAlsqUBpo/GRXzTG48gEtnX8l9DBON6crz
	 DNAbVOZRawhf+2uCw/C6ApG/fliJ1MrHR24Sw0zWXhvd6kATauxCuz6Po/lfx9ktgO
	 ldyi38RT9eP6dhdu1QXk9XC8yOWgZwSuEZNQs/9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1045/2651] RDMA/cxgb4: Do not allow userspace to write the status page
Date: Wed, 18 Nov 2026 15:38:05 +0100
Message-ID: <20261118150325.587491667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ebe3170a641ca..904a5323a6930 100644
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



