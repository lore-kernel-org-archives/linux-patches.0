Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26419AA75;
	Thu,  6 Jun 2024 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683318; cv=none; b=Dy9CIUOkEYgw9lvBYFct0YUUmbN2RGNK4JGNL9RPD+6G79XsnAvBSKqC+o9m7F/DcS797GVJRcUevb2SOKu7hadeizN9O3ZeKByes90t14gxuKKUdrq0uijAR4kY2S2oMH6t8HrMwwn5X1MEwc+cimOxKxcqJ+U3MFo/65TRuGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683318; c=relaxed/simple;
	bh=NO2BMn8h1RWyaINLraLXyPHj0a5xJg8hi4qwgA4xvX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwyQ1keQrCkgGKGRepBRNhfeuiIrZ5XVlUWvyEsCml42/6dk/FEoeVixxYJ/oiD3j4aUCodxPYC2LxV9t36KmoWn0utvi/yxcbYSa1WWVAXW5KMj5GWURk8+WW6mWG3YBikyM8tW545JuWIa8V+QIVryl0kLRrnoKR0Cb434iWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y02f4TIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y02f4TIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D61CC2BD10;
	Thu,  6 Jun 2024 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683318;
	bh=NO2BMn8h1RWyaINLraLXyPHj0a5xJg8hi4qwgA4xvX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y02f4TImc+bcBuV2XeteU+QoF0cv9Mk66wG7LdtUGwRzY0i4IDo9DVWxLhT2wsPWM
	 SPsr1Dz9gCd3VPjwd6WXouW2lHCcIRl8MfC0RK4cu4mYwVbRbpI22DnB+0iDnf7cWz
	 JenQIYqDLJkztGZB2yfYx58g2OHi0oe7vQ0TxXDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/473] ASoC: Intel: avs: ssm4567: Do not ignore route checks
Date: Thu,  6 Jun 2024 16:02:07 +0200
Message-ID: <20240606131706.490514599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e6719d48ba6329536c459dcee5a571e535687094 ]

A copy-paste from intel/boards/skl_nau88l25_ssm4567.c made the avs's
equivalent disable route checks as well. Such behavior is not desired.

Fixes: 69ea14efe99b ("ASoC: Intel: avs: Add ssm4567 machine board")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240308090502.2136760-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/ssm4567.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/avs/boards/ssm4567.c b/sound/soc/intel/avs/boards/ssm4567.c
index 51a8867326b47..c1c936b73475d 100644
--- a/sound/soc/intel/avs/boards/ssm4567.c
+++ b/sound/soc/intel/avs/boards/ssm4567.c
@@ -217,7 +217,6 @@ static int avs_ssm4567_probe(struct platform_device *pdev)
 	card->dapm_routes = routes;
 	card->num_dapm_routes = num_routes;
 	card->fully_routed = true;
-	card->disable_route_checks = true;
 
 	ret = snd_soc_fixup_dai_links_platform_name(card, pname);
 	if (ret)
-- 
2.43.0



