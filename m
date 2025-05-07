Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA5428DF1F;
	Wed,  7 May 2025 19:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644704; cv=none; b=OYv7fF4DyoDw4Kw1CIgtZTTuPhJLReTeE1y424yW9Afmg2vdF8+i/ZGtrZfHfAMIyWwbNeBsNJ4ap0B2NegBdbaJRFej8cBzUMX6vQHrNritdFAEZGSwvxpW5Si4qUA7rjEd2PGrefnJyg4ZFVrajvu47MES+srfWj/5FsnoYOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644704; c=relaxed/simple;
	bh=3V8QwIneci6PyWVD8ap17SCbT8yNPOE9Cz3yoI4ye/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsY8StoRFaY0vWg6nZUvolhrPZ5Q2k5rEPkkct93Vrw3wThD9uZ4HYfO4EhQWm3DlLdgvAYv3SB4ZGnK7ROxuBj2AC0MdrX+Vo4CwQlLBhMLUquP6IR1XHej3weIHLqXFI9BeogoWD17ScwUJ55h9b8UQpHihMEgPQyWjADgOGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EmebFQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EmebFQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A3FC4CEE2;
	Wed,  7 May 2025 19:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644704;
	bh=3V8QwIneci6PyWVD8ap17SCbT8yNPOE9Cz3yoI4ye/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EmebFQiTH3x41DvoRu/2XqturmzRVOH8hexuuvl2B0q3vuQbroguFKyAj4AXTnk+
	 q1tTBof+erf+lCv+kLmpNxtlWaiunoG7IPtpBdslweAY6EWcQS09i9mskJa27xlfqD
	 bIzhPpmUgp4/X7g8eGHDsIaZZ68iu6hNeF4/H7+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/164] net: hns3: fixed debugfs tm_qset size
Date: Wed,  7 May 2025 20:40:15 +0200
Message-ID: <20250507183826.233360556@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit e317aebeefcb3b0c71f2305af3c22871ca6b3833 ]

The size of the tm_qset file of debugfs is limited to 64 KB,
which is too small in the scenario with 1280 qsets.
The size needs to be expanded to 1 MB.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250430093052.2400464-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 9bbece25552b1..3d70c97a0bedf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -60,7 +60,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tm_qset",
 		.cmd = HNAE3_DBG_CMD_TM_QSET,
 		.dentry = HNS3_DBG_DENTRY_TM,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
-- 
2.39.5



