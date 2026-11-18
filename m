Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030535;
	b=TP7kFpTWImUaTmJPwdAk5kSTjOP5VB9VvoTti8kzqg2O2EWgKFmLN19d6cSzTcdPSgn7
	 A2Kn18KMljKRdHXdaYi58xQSKXRt5wmyzlQukuy9sSBlgGvYzptj0d4vpQsSf3q9mCQng
	 io94k/F8JhIrfhPk48HG0Cn2YODjzjck6fpZWNyUBrwnTSixgyOIDVK5mTgxEj9p5LnKX
	 vBN94mWeEXyyyrIVLR/6n9DKXIkkc2+yFmy8/ZO/6hGxSBLBg5QuKS3fkX5s6QBfoP5+m
	 2LfDWusO35UeZz41d20nw3aTTlRwQbexIfNXu3YrwxFpVmyQ0LzePd4ELyvnqHfhLDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZ92DzGIHGDT+Ys09aaCy9L7Xvid/y4+Mpt9+7thc1o=;
	b=5sGP4BiL3Isc5n7xZDOFuBYlGbfqqNYxWvpb/HFCrWgXgsmgL2AxINJmioqUhU2NEz6g
	 h7Aw5RS4K7lCwFL6gGPm0xr1kpsnav3USZy2jt8d3LE+JZ6OWxd4ADnW5EA+6oxr6hwxl
	 HGHYFW9iXr9wxVLS0s03Glj3+osez7rCTB2F4js7JaXlz++yHXt9RoTw3LqUU91iQFlJu
	 Z3HJ/k+J3BnHQ27CEZoBh3hpcZjjxe4wB75SqIGzVfd4lEMKsE1eJXPZ87g8eEMwrvK6S
	 G/V2hUvO3bLt0w7GB/EFQ1bpuGPDYsYPQons4VbtavmvhId3VH+bxXCijYvEKk8EfQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usOKNQcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB8B606BB70;
	Wed, 18 Nov 2026 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usOKNQcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D23D1F000CD;
	Wed, 18 Nov 2026 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030535;
	bh=EZ92DzGIHGDT+Ys09aaCy9L7Xvid/y4+Mpt9+7thc1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usOKNQcngzJdYfZqqGFdgVlUwkQRZw+UQVxu/a6sZvHfHsXvUMVvmsRoj1PzpmF0n
	 TU9lmJOZOjTDLkzKj/KD8jQ7qVJhV57dro6IyYvJ4ChPfd0TuPMIrXglRt5NHu/6C9
	 Rvsf1QtW3KfNDLS/h2Jvefs6prjwTt3uN84kBSPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0698/1756] RDMA/cxgb4: Do not allow userspace to write the status page
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118150036.981263691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



