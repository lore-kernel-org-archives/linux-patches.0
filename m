Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040444;
	b=E7NxC4xpSEz8nORdzYQXBIH4UqUV8WRtTknkGfvMiaZU+l5rsrvsxScDKyorst4hWHyM
	 XHaCec/eMEm8Lc0rA7EqVif8qRWr3JVb2CtAwCXC11UkkSTHeS0yVRAc5CnGl2pG/45Qh
	 j1+O7Uq/REmNmudbES0eATXQ9BfcVU2Yvh7jnyir9M4HcyEC1SjcVkbfhP5k24HDYk70l
	 +yBXM7bTGUFCC7TE5FeHLA2JQUmNwbmp4xq4w/YgftyiHOxVCfaXFaEbsinhQjt5/Xw8V
	 KLVW+JoGcVYjLJDxIB0phZ7pJIPT+CBHAdcd+P06qAgiT039a2714WAxdzaxqy+b+Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzPe08XEjkHdLIdGQhCJFgFe+3WXW3pXjSHEoXe5Fa4=;
	b=okX65eHwoyO7QG5AhJAqVduyzElIDIrlVEBP9rtGRcS0Z+S3s7M1aC65uoZcvYIAYQY7
	 aRge2BYSmWG4HB+bV9bSwUs8nd4yuPuXkxi/RZabLvHIPIkZ2mJcJphS6LmtiQo6/k8VX
	 LF5vZdgu2HrKj7m072NN1kQ+cFIwAsGHDKFrklTahsAdNZq4bdow5F9/wq1evnEUyn9Cu
	 Bg9wEsyC7h8gsIKA7P0vZZuLsiicIyUQPw9OhvA4PEoCC1tlLU3LG88ycu5CcYDXMPt32
	 5PBLIvXFlx52fMTzYehaZDzPcSaD6c1NxYhnleukpB45rWcvLJm0QbuqQTTAwneCZ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCman4WV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BAD606A31C;
	Wed, 18 Nov 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCman4WV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907871F000C4;
	Wed, 18 Nov 2026 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040444;
	bh=xzPe08XEjkHdLIdGQhCJFgFe+3WXW3pXjSHEoXe5Fa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCman4WV0iX4Dr29AK7iF9Ysu67D4pgBZy6THEpz9Lm10Bv0wv1l6FNAReL/0QyQo
	 zLUj9ezgWmZ6yD1teyFxSXqMLsyzLEEtj0mjghdVpMNvN4IVhRaNc68xipifwphgr4
	 PDS1+X3M8AYalVJcOCJVHXIQPUSQ4tb7aS2z+GV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2460/3318] RDMA/cxgb4: Do not allow userspace to write the status page
Date: Wed, 18 Nov 2026 15:51:22 +0100
Message-ID: <20261118150435.229614798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



