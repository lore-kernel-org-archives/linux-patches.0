Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048975;
	b=mMXlH5UQVE08FmyCN55dpJrZXXijTw7u+igbEUIy0Dp1w29oful9zhZOLZhZFEy3/F9T
	 IkLbEG0LbrsGYwgfWhB8Ejhpv7XCiG4Gg9TKN6UYtuE2LPzTAYSvHiBc5JD1Yd+1ZxaKJ
	 VfhFyNt35ikPIaSJ9kdVB0ShGP7qVvRSvvCRuV8hx9suK+k0rA7xiESUlSBeusiZwkWk8
	 UvwgoBbmSSS5w6WsFEL2oonLJ9oq3bKG3iEBjugijE+4wCayeZvSzJeA7kEKbkuODyT63
	 rJQCvrvNxO4ybjbR4IZwDx3Hl8nZk7wDMsrkhHhkwvepygaL2XM+xO7GIgjSTTriHjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAVbLfK3ZEZOF14hg58476HjJxHSe4OCJYZ5FqAFIp4=;
	b=0wbhbHWDLxRlNBokm9UpOZW2BqpfDNRGEAL7a8tbEbCeh5mgrxjaL/7nDEPxziXeUN/5
	 wijOr1V995Yizz5Zb1vVMk3I9E0Keb8gaF4guv2wpR2mnSeiCcaqCOoguU+a4TwG0/HKD
	 qMJxIkaTRIJA5uZbXFpEri4eNY8tgggaPQJHVeArGV5lWdXAlRno6Mi/JgvLh19OhHvgO
	 E/13w+LiDoOr0mgrFqWGqi1+eS0yztzzqU4wU7bwCEhoCGwHHtNpb7LwbHGzkVwi33aK3
	 QhDLQrpmRLGu8p+ouh1hhabf9bAz7dpnvgWqKuVAShTzKVyRk0YLeW4+DZxVUAC3LNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdVQxOmZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA6606A32C;
	Thu, 19 Nov 2026 00:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdVQxOmZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DE11F000C4;
	Thu, 19 Nov 2026 00:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048975;
	bh=SAVbLfK3ZEZOF14hg58476HjJxHSe4OCJYZ5FqAFIp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdVQxOmZpLJWHVavawgMnXAuG35AdD+C8Mn/ULMqW89QsP6u6nloi8RWZPO4UCPBp
	 BD616SuSaFdMTCuyts/kNKzNJTBUSFnhyTRwfyrJTFQ1k+IbLpBbaYOhVsjzpcCOHC
	 z5GQBEZkVT0m3tu0g3lfhWXX1xWy16Pcne2iQ9uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2169/2857] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150319.496139165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 96e6e9a5f235d..cf9dc754f5d81 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -573,8 +573,10 @@ static int pmem_attach_disk(struct device *dev,
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



