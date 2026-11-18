Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025104;
	b=Qtmvq9bFLXyFB25mXqKso/GAndoV7ddwGNKp3AsqrMwB/yJN/ExIKWXw6XXuGPIPegBz
	 1OoKIkzoD8uCsWfhETcrsvPymvNuljuvoPnxvDxaYJJ+t+1qkHis4p+/vv9wuVMRG33Bu
	 bK4n8hh+sbcOHbIWMSd0X+fB6CpGIDT/wyCZJBpZKeGYWJ4p0ADwgGxgy6/jOU4zjLXPV
	 FSEmeDdOHqZSIsj8QHIyyKbfDNLSN7+KPZZmQJpvySWePN4VHDiG4DrAmW+f3puOYLD9R
	 W7AkQ3/sl0TNA7Pa5527W2gcK7bprywhEA8dE7KnEWIIYEVk1NrbB/Y2NQQYR03rtxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCODP2AtqGb6BGJ0Rk7hd57QvjBUGd8PbZWyFs4asHw=;
	b=ba/FPAyqmuGAV0LMlYAavI57Dr+7CtJoxPLMRohziGcIxjwLEC1ocrkFxq+Ju92SqKBW
	 IuZxfHZfw+0SnU5j7/urFIweQjmfRjjTYY/hdTZBQ8jcyidVivHCTt3FN65+KBeV23M30
	 WEBc2UmYdhwU9aFCkd3bgsB4Og4gdnRqaVF1YiGO2ajSp4c+gBkx3qlDbzfaebUoMGq2J
	 dkJPYHN7TFTcoKnbeQSM105DZ0E/ZI/CGAgVxHwHbnRFjPh2DM1R9icJ5iAJFvGuJCd/b
	 3dFWxyAeHSS0yrKqo6m6P9LhEsYPhZ6+C8a6x4j07OiOBrRNU2lIEfNwJU9KfKlmeSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNQm5+vt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE572606A31C;
	Wed, 18 Nov 2026 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNQm5+vt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEC01F000C5;
	Wed, 18 Nov 2026 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025104;
	bh=sCODP2AtqGb6BGJ0Rk7hd57QvjBUGd8PbZWyFs4asHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNQm5+vtVONASfv5y5hqC1j+lUTQV6aBIaKetBv4PqskaYFLH8I9mgjOzwY5dCbTA
	 m8w1BPhxZoaUX4E7XdHxCcKP8AqliUULZpeUqbgSbtd9y4WGIHrj3/Tf7gG892tDQm
	 CZHSj5+5wWt7i3EniZV7Ex96nEsDY3O5dUncMSrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0960/2151] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:44:55 +0100
Message-ID: <20261118150157.493977833@linuxfoundation.org>
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
index 614701a539ab8..c8d2eb70b3fbb 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -557,8 +557,10 @@ static int pmem_attach_disk(struct device *dev,
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



