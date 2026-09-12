Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F686282F1B;
	Sat, 12 Sep 2026 07:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199015; cv=none; b=ndOXsoEQNyYgw1cWI7d/5JKgssluDGC2hVJC/qfUcmVPsRWSkvMpHQiR9/RFQm8zusVfApbUlRDB4A62SHI2BsiPyFIiUT2R/gWDnFhuv2p/pVizfWRkA5qFUOiD/sKx+bjn/DuuQhPxqO3XcyRABNv7sYzpQxzw4ufr06cRYuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199015; c=relaxed/simple;
	bh=+2XH9iec/lQ43AppODn9WfBlpwbRNX0UqcYk7TSZ9RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXL4/+IRsL8+IVmo0oK7P2un/UTP/85iV4oOkpR46D0tTocaG9hfMmyHOOPR7qMAILimQVw/UPj5EAf/r66VLB22j1bQDY1CRL6nkSHsfe5JUkikI3Q3HKUgiGL17WFzAgqH+fsnu8pqV7dsLffYoEu/ltnsMkDAj1JrjCjcewE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9CbU6CR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9CbU6CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFFD1F000FF;
	Sat, 12 Sep 2026 07:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199013;
	bh=g/lqEpgyHm/BkKO3hNAaz5D0p5Cwn8oSvOTDZgQiSd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9CbU6CRHNff8tner7SjBKNe++767UwMJzz847tWjZPA/7v4JfuCyWO24kglTQRso
	 B6fx6hI9wm7Ywe8zK0cr4EHljOtxS6l0EwY68EsYVVk/OO+EeJqPTqfjD/45942kUx
	 va/Ea3VnEon1XlMD9752cqgHUI00rAiUDEsGRpVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0496/1815] mei: lb: fix incorrect type in assignment
Date: Sat, 12 Sep 2026 08:37:26 +0200
Message-ID: <20260912065700.536578145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 0c419df9c190b80136cc774325f84238e430e905 ]

Fix the mix between __le32 and integer by casting
the MEI_LB2_CMD constant as __le32 while using it.

Fixes sparse waring:
drivers/misc/mei/mei_lb.c:284:32: sparse: sparse: restricted __le32 degrades to integer
drivers/misc/mei/mei_lb.c:330:40: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] command_id @@     got int @@
drivers/misc/mei/mei_lb.c:330:40: sparse:     expected restricted __le32 [usertype] command_id
drivers/misc/mei/mei_lb.c:330:40: sparse:     got int

Fixes: 773a43b8627f ("mei: lb: add late binding version 2")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605091533.79Zcv3CX-lkp@intel.com/
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260709-fix_type_le-v3-1-478761151e05@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/mei_lb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/mei_lb.c b/drivers/misc/mei/mei_lb.c
index f6a258c2b838b..9fa69acf28d5b 100644
--- a/drivers/misc/mei/mei_lb.c
+++ b/drivers/misc/mei/mei_lb.c
@@ -281,7 +281,7 @@ static int mei_lb_check_response_v2(const struct device *dev, ssize_t bytes,
 			bytes, sizeof(rsp->rheader));
 		return -ENOMSG;
 	}
-	if (rsp->rheader.header.command_id != MEI_LB2_CMD) {
+	if (rsp->rheader.header.command_id != cpu_to_le32(MEI_LB2_CMD)) {
 		dev_err(dev, "Mismatch command: 0x%x instead of 0x%x\n",
 			rsp->rheader.header.command_id, MEI_LB2_CMD);
 		return -EPROTO;
@@ -327,7 +327,7 @@ static int mei_lb_push_payload_v2(struct device *dev, struct mei_cl_device *clde
 		if (sent_data + chunk_size == payload_size)
 			last_chunk = MEI_LB2_FLAG_LST_CHUNK;
 
-		req->header.command_id = MEI_LB2_CMD;
+		req->header.command_id = cpu_to_le32(MEI_LB2_CMD);
 		req->type = cpu_to_le32(type);
 		req->flags = cpu_to_le32(flags | first_chunk | last_chunk);
 		req->reserved = 0;
-- 
2.53.0



