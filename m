Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040581;
	b=nhmod0j8I3cfO44H/mQAvelj+bq8Z+05HxDrVyPL3CMuYwZYvOZSNUcHBfMhq0WCLyxU
	 t4B0kFrpOi+z1hborLZfeBj95S4KP76WWSiUv2GB0WIg8V3Jlz+mvowfRHH1hvd/XpORc
	 1H4YxqH0pPxhprytOwXZIoCWp3v/HA/79BUiXYrlh0P0bsV56+J32TNIN5GLFetQEYU52
	 yvVFaJzxfjecEa0MQtenTLyMhgq++qzLvmOTHDIL5YqftuqGKcEqZaAYwvPhS/P0RjKjj
	 uz/iwOIRU0Ep7paM8pAK2MfUdMYszLqsoAc5nMxLNspF1PmDKodHk1LAJPAGfl9mPjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaCzVdGNbg3Bwg2TA01GyzmC/PG1mhxqqUeXGgFM1Y4=;
	b=YxzZ3X9IIy+tbmqZLXPvo4LYZ2bPTBHSOrGPyQum8R9we3mh2OLFcmYzteRizw2cmRIF
	 4i9xsBsHjfgZEzcP7DVposY1tjYZcQZSCM1gYnk/5rSav7MZqmtv00QnIAXdLgURBcKCt
	 HMLeTUerqOv+6ggD37eZy9HYRedeJvCexMVBMXTyMD+4MT9mw/9hhx0Hhq+Ur5xmHe3tT
	 sU8JC1GSNeD5GtGVZzsPwlSrLQEoyLKspr3JIHoWcWdUVfbp3DKL0UPLq4iCTCn9j1Lh+
	 xoRkWZgL6EcURflkb1fvM+mY6Go5pYsti6ldbJIvfXnuGURv4zJb7gPRn85XeWcc3wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bi4aLVoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4819606A325;
	Wed, 18 Nov 2026 22:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bi4aLVoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F221F000C4;
	Wed, 18 Nov 2026 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040581;
	bh=zaCzVdGNbg3Bwg2TA01GyzmC/PG1mhxqqUeXGgFM1Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bi4aLVojtq8y4Awd4eIcZ8MmM/Um7ktM+J7D6jAfnGmjahPUExJS6Rcaq/qVIdaww
	 /twqs9Bza2QmoBHR49D6YHoLxPUA8yOSad2v1NLW0ROXNStNPkLVW78ueaWiMgZkRD
	 Fiao8J1gLk8z+omtAFwf8kOsWy0HH3aZlzxfcXwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2509/3318] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150436.638871126@linuxfoundation.org>
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
index e82c8e7ec3720..19c2db40fd8fa 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -558,8 +558,10 @@ static int pmem_attach_disk(struct device *dev,
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



