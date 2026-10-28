Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212569;
	b=fOnbIjxAtqXak1AeODUofInZhgDqYvc7I6OJOEeuPvGqEUbHpB1aI81jXf+Yeq6L1cdY
	 D1zsqXcILuH3AJ7+Uccl/ARs4TQNrutLYSl6+3mjkqffyoSk6bwk7caCU8X/HrAyT0z4w
	 jzKHvTry48rb84NbgXA/4DJIVMc4KkdL4sfvqP5reVyaHFNn1yagvRJlFrMANbwobnGUX
	 Tk1cTjEpn5RWxKPZOtdMRWP3tMvdBCI/HdDGOk1aVhGClnh5h3PBm009jMaAkK3UQeWAA
	 dX/PqvO4pmP+aY+9wEBGhFu9BS+M5WizAtIaE+aJx3C19fsBqYzDJIy4k185y5QaGHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dwf6sb2D5rUUNgRoUmc4HXdBFA/3zmMiG6BPe/AbaHc=;
	b=HFnmCR4kKsY2XHybO8b2UXJxFElNuBQOVH3ZpIRbYpBdPcW17Xgx+k700kQqbqFotu38
	 2nVzooyJ+wCn9tPRHejEYgr7yR4F7mKJbQQj0+qao1ulvm4HZMjOC2rQ4f0yoVeDXHTUn
	 PEPAOk2AkS4wTt7+6Wth5Dylz36Ca+ozpfOez+chmftFteqiFSMUiDk8N19M+rS//sOYI
	 k7/82KuFxy0JE0q1VQmyWgXY/xn5vcBdp1l1x9JPVJQdHzhX1HFf0Tn1IP0inKNyrTbKh
	 iP8BB18jvxQuGcNjF5m/U/xLuHu0mof7kXAJXbmcdjMBGq/3KUMOzE6FBRRH6WEAqyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbJfAKTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3B606A31A;
	Wed, 28 Oct 2026 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbJfAKTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F122C1F01825;
	Wed, 28 Oct 2026 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212569;
	bh=Dwf6sb2D5rUUNgRoUmc4HXdBFA/3zmMiG6BPe/AbaHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbJfAKTSVWSa2RXCdUujavUoDmayNL1l4Dtw6/YgzyJo1Xt6ZZmIxZ2hfdai2E53C
	 HdGyHHjfSMYyNdxqpTBCZTaufpk5EuYnkdmRpsQmPGRpE6BxeEzBzW34Mv4cbFORkN
	 CAIcP92SOWeMf69LT058KOnG5dcwEx6odw4hoXB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0198/1887] nvme-fabrics: use reserved tag for reg read/write command
Date: Wed, 28 Oct 2026 17:38:14 +0100
Message-ID: <20261028170503.740908618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunguang Xu <chunguang.xu@shopee.com>

[ Upstream commit 7dc3bfcb4c9cc58970fff6aaa48172cb224d85aa ]

In some scenarios, if too many commands are issued by nvme command in
the same time by user tasks, this may exhaust all tags of admin_q. If
a reset (nvme reset or IO timeout) occurs before these commands finish,
reconnect routine may fail to update nvme regs due to insufficient tags,
which will cause kernel hang forever. In order to workaround this issue,
maybe we can let reg_read32()/reg_read64()/reg_write32() use reserved
tags. This maybe safe for nvmf:

1. For the disable ctrl path,  we will not issue connect command
2. For the enable ctrl / fw activate path, since connect and reg_xx()
   are called serially.

So the reserved tags may still be enough while reg_xx() use reserved tags.

Signed-off-by: Chunguang Xu <chunguang.xu@shopee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Backport to 6.1.y: used the older BLK_MQ_REQ_RESERVED request flag. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index eed78e6f2cdf6..c4d58e5f3ea7b 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -153,7 +153,7 @@ int nvmf_reg_read32(struct nvme_ctrl *ctrl, u32 off, u32 *val)
 	cmd.prop_get.offset = cpu_to_le32(off);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, &res, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 
 	if (ret >= 0)
 		*val = le64_to_cpu(res.u64);
@@ -199,7 +199,7 @@ int nvmf_reg_read64(struct nvme_ctrl *ctrl, u32 off, u64 *val)
 	cmd.prop_get.offset = cpu_to_le32(off);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, &res, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 
 	if (ret >= 0)
 		*val = le64_to_cpu(res.u64);
@@ -244,7 +244,7 @@ int nvmf_reg_write32(struct nvme_ctrl *ctrl, u32 off, u32 val)
 	cmd.prop_set.value = cpu_to_le64(val);
 
 	ret = __nvme_submit_sync_cmd(ctrl->fabrics_q, &cmd, NULL, NULL, 0,
-			NVME_QID_ANY, 0, 0);
+			NVME_QID_ANY, 0, BLK_MQ_REQ_RESERVED);
 	if (unlikely(ret))
 		dev_err(ctrl->device,
 			"Property Set error: %d, offset %#x\n",
-- 
2.53.0



