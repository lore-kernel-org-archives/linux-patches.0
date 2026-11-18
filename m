Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030568;
	b=FHqrC5K9apy2BjbEvjD92XGGSJ7mqJcCnWpii6v0cEVVDzV0LF61d74VpfeCaS9U66hf
	 o1HAWw0pyj9FdFrnkfXXCo5fqZ1bzJ0xXuuBgcBjlAM9YefbJLFUZgSj4Tc/733cZulh5
	 bMEWxabveKk+zcA6C4jhxwXJO+9bfMFEq9x5/i8KHrZ43Ta3RlQlSs0XNx5Zj0jwuBsOf
	 SNPiJwbCdLgIEbru8EXt44OZpXaVjjcvzwmuKyaSaZAgn03WMkKXlMam+OB8ZyevCgVua
	 IL2E7AoQmfgmfR71HSXDM729dC0PqKoYwAB4IcUCYGCN1V/lQ8H0Yrv0Dy+82ca+DQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2G8pLG6M54N6Hyhp4FVpPK3yS65jl35HeZOqiipyy8=;
	b=JaS2xrOv0LDOQP+DAUcEv86vowdFIzUbBzLobRcY9LUrK+hNZGrvFtahWrGD55xAiK4f
	 uO+uPyzfAmhvZfjeRo3ZKVZlMPUo3lgwB/xdXTEb5VCQBcaJffzWcw9k/jXzOecBg8J1p
	 qf8jXISD3n8ajFnQt8ODWdiRAf9/U2Bwiw995FA8aTLpLcPSZBUSWH0RVcAmpsQkHXQKN
	 Kzo6qJV5J5VvI8sJYec8pfH/RvL5y+8IL1N2VouSj7QquG20M4D7Lgi99wKnEK8G3Tvd7
	 6MST3pjgAb7574kaYs2S/AfRS/a9hgUUTabNOLMhoACTJIBRej9APcI7C8dIRDyeG6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cusiBtS/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9316606E7CC;
	Wed, 18 Nov 2026 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cusiBtS/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CA51F000CA;
	Wed, 18 Nov 2026 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030568;
	bh=h2G8pLG6M54N6Hyhp4FVpPK3yS65jl35HeZOqiipyy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cusiBtS/OqhRkBxktTFrpxQPCG+RwWbenN5pXCp/k5yRKRySnW+2FqTuKU2q04Dop
	 WC0RXbNdN20H6VARfxF28I/NKGeK///KcYDTp0Mj/FOVez1k5Npu4eP68SI5lN1PWM
	 zGqIKmky69BVrZqIMjQS4lDA3KBFGuMXQBIqx7sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0752/1756] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:47:59 +0100
Message-ID: <20261118150039.554555788@linuxfoundation.org>
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

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 855a46681e0ba601952c346e5b62d867e51ecb23 ]

pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
it to devres only once device_add_disk() has succeeded.  Until that
point the probe path owns the disk itself, which is why every failure
after the allocation jumps to the out: label and puts it there.

The devm_init_badblocks() failure returns directly instead, so the disk
allocated a few lines earlier is never released.  Nothing releases it
afterwards either: the devres action that would have done so has not
been registered yet, so unbinding the namespace or destroying it does
not reach the disk, and it stays allocated along with its queue and its
bdev inode until the machine is rebooted.

devm_init_badblocks() only fails when a single page allocation fails, so
reaching this at all needs memory exhaustion during namespace probe, and
because device_add_disk() has not run there is nothing user visible left
behind: no device node, no sysfs entry, only the leaked memory.

Release the gendisk through the existing cleanup path on this failure.

Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260911082543.473670-1-hemanth.selam@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 53f6587674d34..4ee50aa39607d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -561,8 +561,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	if (devm_init_badblocks(dev, &pmem->bb)) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.53.0



