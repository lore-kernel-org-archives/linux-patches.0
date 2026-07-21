Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6D8386450;
	Tue, 21 Jul 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656898; cv=none; b=IF/zE9isFkWDwQzKk0DxHVabHI1X8i10mGenPBaqJu3RECwU1RS6N0Cx0nnP7k/zPDY3TUD7nmaYjHQD/LK1qca+5wClAsAipoYxnjfdmflZuZZwbo+BLm7WwB6iNvZzrHMYiJ0VckDoMbxay6MGO9eCckWd/Vtx7csejQ1hf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656898; c=relaxed/simple;
	bh=M8R6OGqsPh/DALGyhLpHDwnmAnirIz6VMa+0NsQCTyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2saLQs1K880+/O+rkT0W7rH/kW2VFaQ9KvC0lvCvvNOyoWjD3ZL03QpRXN+a6Qif3qggS1CBcJ4qixMkoOPOYoKAalcXNh+qxeYm406asHm7dFVL0HJluNHH5dGPCFK1PXyqGb+tHBw1gBdqVBvitqrgmhKG1ZMnKmJL/2SPXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Km+GR0DQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Km+GR0DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491E81F000E9;
	Tue, 21 Jul 2026 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656896;
	bh=a5VLUdLeARsRgmgmXZPIPhrTh+I6JrEE81sgrQGeUcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Km+GR0DQ4vPnbL4g2DGeQ7Wv3HFkDoJ/MsYSDWoVe3kSSO86zCMHjNQ9vAcBvco1R
	 NoQOa+R+JcbzVX85PmmIaKi8KAv6BgUVeX8Rs4ZMLEY2oxBAmAdEXHwid9whbaro9S
	 sFVyevm9mmMbx3VMTm1Q1OYM7fzOXtk9Aj/Yzqkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0517/1611] net: ethernet: mtk_wed: debugfs: correct index in wed_amsdu_show()
Date: Tue, 21 Jul 2026 17:10:33 +0200
Message-ID: <20260721152526.975146491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 14a8bc41ce9edae42d56466063a7f2c84a16c45c ]

WED_MON_AMSDU_ENG_CNT point to different entry by 'base+n*offset' mode,
correct the wed amsdu entry number in wed_amsdu_show().

Fixes: 3f3de094e8342 ("net: ethernet: mtk_wed: debugfs: add WED 3.0 debugfs entries")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://patch.msgid.link/20260612064501.203058-1-guanwentao@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index 781c691473e14f..519c364e87d197 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -310,9 +310,9 @@ wed_amsdu_show(struct seq_file *s, void *data)
 			      WED_AMSDU_ENG_MAX_QGPP_CNT),
 		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_CUR_ENTRY),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(2),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_MAX_BUF_MERGED),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(2),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_MAX_MSDU_MERGED),
 
 		DUMP_STR("WED AMDSU ENG2 INFO"),
@@ -414,7 +414,7 @@ wed_amsdu_show(struct seq_file *s, void *data)
 			      WED_AMSDU_ENG_CUR_ENTRY),
 		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(7),
 			      WED_AMSDU_ENG_MAX_BUF_MERGED),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(4),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(7),
 			      WED_AMSDU_ENG_MAX_MSDU_MERGED),
 
 		DUMP_STR("WED AMDSU ENG8 INFO"),
-- 
2.53.0



