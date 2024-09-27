Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636011779BD;
	Fri, 27 Sep 2024 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439922; cv=none; b=ZyMHgGywYUvsUjmo5/yfL79KAEs2AJXCpmAz0GTIgjPtiIBaZLDPuV9hXtSPqO6QmfNeb9/Ofm1ompLRW4xebYvJ0to6UbY8esdl+7ct+7RFS54Q27iSKJVubTEb+5HcSnhMx5qXnvIsZk8RankOA4ss6QmxO424HjSnZijdPSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439922; c=relaxed/simple;
	bh=stCbkOrXv/KZ7yVyJYLx4LEF8gs82bXCpo1QYg2aQbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt+tv5XxhG0ft0gC0bzppqtxi+AYMQ12EKSSlQs6/mYHabiqjVkd0B7RtxwJpgVzYiDUkpwIVcUGzZ1i+gE2HWDU7mFwRyhL6kmjEgwhFthrEkqnEDY72HfardOy//wtQ42Eq2qEurvEwga7zSG/8Ojg+8Zza3Jq+y/HCh6vulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBVcL1KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBVcL1KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CFBC4CEC4;
	Fri, 27 Sep 2024 12:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439922;
	bh=stCbkOrXv/KZ7yVyJYLx4LEF8gs82bXCpo1QYg2aQbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBVcL1KPDZ5SuoHN5Hjpq/XUvAC7IZ03XFLcpbadFcz89LWkBPKAY9JOXrVt0LHUZ
	 aYIt0OdzZWseQMbYSJPOMiaIxI9LPKAy3O7gyuJEIz+odQ0NcCQhEdH+bhKtinsvxI
	 8e0Y45dKbYhq/a7tS08G5OPzVOiTUN2b/gG+nuPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/54] ASoC: intel: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:15 +0200
Message-ID: <20240927121720.657141756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit ae61a3391088d29aa8605c9f2db84295ab993a49 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-2-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/keembay/kmb_platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/keembay/kmb_platform.c b/sound/soc/intel/keembay/kmb_platform.c
index 6b06b7b5ede86..ffe558ef49220 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -815,6 +815,7 @@ static const struct of_device_id kmb_plat_of_match[] = {
 	{ .compatible = "intel,keembay-tdm", .data = &intel_kmb_tdm_dai},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_plat_of_match);
 
 static int kmb_plat_dai_probe(struct platform_device *pdev)
 {
-- 
2.43.0



