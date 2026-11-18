Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018188;
	b=lARLArOA+dBTTQXxSewx7wfb6MbPZMOABwFWROgCBPIg+b8emiXViIYeoFcivsfmmFZ4
	 ka9VxxKxs+bv+/wesZGXUJzmyZT4uXFEY/cZGYMp/+U2qplcv8MYg/CJG6F8Zv/5GgbUB
	 f3WtqSlbUxuvFficeci+BGpABBvgbHbg7Jk6lXwO8h2gzxkmKT6sBHwZzZ9/Wzs7oNCCR
	 BzqgwukVaYoBKbm+0E691DqV0Ewx5i7Pr70onef38RplJMuDzqZ8G0WdLcuInzheSgamb
	 YQZ+h3KtE2AN6Z8C/U03rup18X1S4Jq1ocVhD6rrmkFZcEymCa5XaoMdXrPkk8EImyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ch0H56gbbXbDiJnOgcfWkvpk/8nk1nJfgigKM0CXzWQ=;
	b=Y66smlrdQmD8ydWSzK7wsidA+ocMGCz2rQV+9yQJl7i4UywVscJRPByI9V1BZ/F/Be1h
	 zlpe/S2dASbeh4ZDzaJ2ai9Xh5KkYziBlmEtf9watH7B8I55+KV68oqb2ysrdUbNRuPNt
	 842EwPT5ZJxqXjzYxq76vlYRzdsLCJo05W+2uwcGiSIN1ZhQPzmk6Eby5b7kApAIeYLhY
	 maGChNjgk7YI6+iM7OjO6lKhcWzlaNuGAsYBDgpUOYan9xgHbc2VyZ9CSkAVZnz9rPoiH
	 8Sae3lzqEXgIq09KsIzWTe3YqvDcj20i6cpMzLHT4EYpLPMkLrGyXYHS1LfN/DjTY+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkQ4erEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AE3606A339;
	Wed, 18 Nov 2026 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkQ4erEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598B51F000C7;
	Wed, 18 Nov 2026 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018187;
	bh=ch0H56gbbXbDiJnOgcfWkvpk/8nk1nJfgigKM0CXzWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkQ4erEsLwNfVdQg9p9rAkDEx5aKfmgX0D7FIngpLjzweBw9lkFqHj83UwOvNY/sm
	 e4hFRb37zKXeLpE2+tSjpqCgdgBJvAjXOpIleMoxV4liWY6AF2jlBI8Ub9sS011iDR
	 +/o+3H1yG4C0O67gIJU4v0tb+woGxbqA0wfSKGNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1151/2651] nvdimm/pmem: Release gendisk on probe failure
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150329.444309525@linuxfoundation.org>
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
index 30a51c365ce8b..648fc7d660639 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
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



