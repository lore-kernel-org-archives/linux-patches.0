Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AC46EC6F;
	Tue, 21 Jul 2026 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659851; cv=none; b=PUfxM2he5ze2ttaqhMknxEcCVpbqD4s+GPkR51zpxwgMOPi9eNuVBNmpB07jbs1GYavRJ86RYbQCAqL4jLsVAZnXAqN7OXgjyPdHn0GrI3WFXqmEsPklhRiijgBKHnYnuLAxZ5rzQdGFA3OGCbsOE3z0VGePcYoM8Ex/gsoNeYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659851; c=relaxed/simple;
	bh=1kTefrovMHyYoy1oSxwloalpm7qhhqJYzXMfdf8pFBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mokSySlzF6gBfVuFuLMLLWERvnV95K07YII17fHGefaF11h8KOMFw3/G7yd3eEosa3QYANMVgivFx60PlFhYx9uddILZ4Xk7uvv8c14zek4+/BmC3y3iR+2zESSZUm0rzXH3wbqsYg86XRNT5eqEC43DBYATbyb1mJf2fPFNXIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/pmYAt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/pmYAt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B95B1F000E9;
	Tue, 21 Jul 2026 18:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659849;
	bh=RT67b2N1cne35ngJoN565eo70Ri8N05zVWWMsuPubRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/pmYAt10Buha2aoGo6Py4QJWl7TdMmU0xk8oUTHV4NoJe0VbarQyRAG2HpbgTwvd
	 T/MJ1UEJVzMRNLPVmb8stO8kHitVz1tvEeR/4nBNNnKZsqNIafN527xrHT5a9/4YNw
	 YH67OtFAgEp2uoNxDRc7LscCFl4XLLl2hNYyNOZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0757/2077] net: ethernet: mtk_wed: debugfs: correct index in wed_amsdu_show()
Date: Tue, 21 Jul 2026 17:07:10 +0200
Message-ID: <20260721152610.645175039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



