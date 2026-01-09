Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730B30FF1D;
	Fri,  9 Jan 2026 11:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959621; cv=none; b=fZZMPEhoiIv5VrUoiuXhk8BQNMOV/zPEozZj/skvKS+K2CqZKczpzor1aFgGzdWtT/8f9Rz81hgSDbYgTGlUQV/tDLPr9ptSu1szpTmzqAJt/h0IHxN7btyFm9XMcBM/PzDHR9jOPeG9lZwuZhcMjGNVoDpYzpg78s6e0LFTzAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959621; c=relaxed/simple;
	bh=NeZpJbnFIi/Md9y42nHW0ykvRR83KCAMflTwk/nraZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gufZd0ZtEBibLRJGMZhed3Fh9/fBDkSMmgvhs5u4VPrWJnkiA5tVc8O11CCso+QhIV5tD3ulMzN1z89dE8F/ZpcIrhlrzyCYKc4Dt+3kSEqiKpVlUBKNd4huU0PqRwYjJEK6zOLYAi8Xqlpo3nYhDOYEQx/d+HOrpmGfaFGnauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMgGM8EC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMgGM8EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9875C16AAE;
	Fri,  9 Jan 2026 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959621;
	bh=NeZpJbnFIi/Md9y42nHW0ykvRR83KCAMflTwk/nraZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMgGM8EC9uKFayqLL4UlerPVPjXnOEE1A1KWu4Iuq1om3iMZ0htK4OWF8RYS5oCa4
	 7q7f3uwvHgfrJbB/MRSux7O4GHH/hH58Izc1I1NsfMUY0AB5BzsRjxXnho+dLL/SJC
	 9lDDJVqi92NSf3AEkbBMVxQmsviisOUxTLbWKAN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/737] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Fri,  9 Jan 2026 12:34:16 +0100
Message-ID: <20260109112138.406422686@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c03b55f235e283cae49c88b9602fd11096b92eba ]

NUL characters are not allowed in ASCII configfs output. Hence this
patch.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251027184639.3501254-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index eddcfd09c05b8..6ec98dfd1f31c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2736,7 +2736,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



