Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A548438004
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805113; cv=pass; b=TPILKcLHn9TusLS7rMU4JTYTuobduTtOJLM/qNjdK/88rBeHkzgmz/0O9ZmYELKh4zkUafy30DtpQTBqaWTIOY13QuwkCHmuPReErDJslnWp0qomOpQ3yNrVolk+ut5HIh/cfgFC8rqcX8FjqBdMFdaz56YaWH5UNDtIgO5kjcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805113; c=relaxed/simple;
	bh=ZcKT4QnEKNnpbxAigl4lgcfpEFZSBaRXdAiBRk0GlQU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g0xwxPJzwYclo+PpUJXpU97r0SC06oxEzITNETkomA3YSnoGXKxKIExkRsynTjGFhSRH3NykkYlxskJDLwyQcPfGumDG9SPB2RojBxvR9TxqCCGhofORi3ZGfqNpigeTTBa44Xs8Mlpf/uMnZaDucJz8QyIMkB4EwxQkcW871qY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654631F000E9
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 11:11:45 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 23 Jul 2026 12:11:42 +0100
Resent-Message-ID: <amH27pOUdUtvuZAU@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 16FB535916
	for <broonie@sirena.co.uk>; Thu, 23 Jul 2026 09:36:53 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA4EA43F5E
	for <broonie@sirena.co.uk>; Thu, 23 Jul 2026 09:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E39621F00A3A; Thu, 23 Jul 2026 09:36:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784799411;
	b=Lv+CcHIb6whmC1a47YT5v3pJJTAbBak8g/oY3BLHpzkCgKB2lF4SXVTXcZS1/SeKzpwO
	 HZgrGTQvg4NupI17ovICJXbTPUuL4LYy5OGt5m7pxDp8JNFR4YcOeen3i+uOtKwX+k6ua
	 pFkqFlKNeNQnb4AHaP5riltLG/CP6eTPxT3DPAmNbkNofvwfYAAXH3wm7eSCk83PBhqyA
	 bLtELt0Vgxl1M0PmYvx8WGCCOjCAVNJ2uLeFBM6/3wMXO5TMkK2+ihM14HdFSBeBd2Lab
	 yFU3E/bo0b5g1mriLO7FFiY2w9uABLPOCKmsjMs8N3aYdVQRYYh+ewa1qE+ifoYN3Gg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784799411;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GIiFWun6gBaKhDLwmmV3AiMgNdSHPxZ9f7wSYpLva7M=;
	b=XCe5esWQIuueY/ksgS6sz7cHtO3YRu8pv/YN/SJhLVIi90qa/9c8ZJs0p0QWZR3WI1e7
	 fV3PONVd6tholirzCV+wzM2YvMqUCHkR+N2PZSPUq2hEW+H3xWzERDgxz/KCLJEakpuNl
	 B6+ygGs0I5/DtfGaXitQ0CAriwpSV9MDZ3zWVaYPu18MpTZ5qcy8Zj8hdq4EPwOSOfRH9
	 dTqZfVs3XLVqXbin/z+Jwjl/+3akNZoxLdGD9q48iGJp+Z3agx/EKNNxaUuwW6cX2Rwbg
	 iDyUGKHfarKdFxWBdI66ZlyQS2Ugyr+DVVITuVXd/e3RvPoe31XEQNwvUC4f4HFWrJA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2D7D1F000E9
	for <broonie@kernel.org>; Thu, 23 Jul 2026 09:36:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org F2D7D1F000E9
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0457c036867a11f1aa26b74ffac11d73-20260723
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a666bb7f-1b75-4f34-988f-1d38aa103593,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:406675e379f91fe3e4b492016caa41b9,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0457c036867a11f1aa26b74ffac11d73-20260723
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 864088137; Thu, 23 Jul 2026 17:36:44 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>
Cc: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH] ASoC: Intel: avs: da7219: Remove redundant DAI link name allocation
Date: Thu, 23 Jul 2026 17:36:39 +0800
Message-Id: <20260723093639.2364360-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

avs_create_dai_link() assigns dl->name twice; the first devm_kasprintf()
is immediately overwritten by the TDM-aware name. Drop the redundant
first assignment.

Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 sound/soc/intel/avs/boards/da7219.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/avs/boards/da7219.c b/sound/soc/intel/avs/boards/da7219.c
index 2b17abcbd2bc..6cc8a6618fa1 100644
--- a/sound/soc/intel/avs/boards/da7219.c
+++ b/sound/soc/intel/avs/boards/da7219.c
@@ -175,7 +175,6 @@ static int avs_create_dai_link(struct device *dev, int ssp_port, int tdm_slot,
 	if (!dl || !platform)
 		return -ENOMEM;
 
-	dl->name = devm_kasprintf(dev, GFP_KERNEL, "SSP%d-Codec", ssp_port);
 	dl->name = devm_kasprintf(dev, GFP_KERNEL,
 				  AVS_STRING_FMT("SSP", "-Codec", ssp_port, tdm_slot));
 	dl->cpus = devm_kzalloc(dev, sizeof(*dl->cpus), GFP_KERNEL);
-- 
2.25.1

