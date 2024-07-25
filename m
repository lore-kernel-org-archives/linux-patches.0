Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E930319A29C;
	Thu, 25 Jul 2024 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918556; cv=none; b=rO1styzqH9JPnB3uQHrubZNPMJOPYEwjwWN+wBA0o3vza2NGCXYkXYiHqYmr4kLeAJ6owjfSniI+t96b9K9yKqU1dAmBe92+CG7wsSSIPj6GvZgF6Lz2RnYNjWp8RqyTwScAn3y8h7PjGlJbkkTDZLNtajPkWPLv0mJXx9Js4mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918556; c=relaxed/simple;
	bh=V6adh8Lb0ZiL17NBgPzCflwBHKoe8+WQyM/xTsandtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYpaKICaGEVynfa9Gpx0fy94KhorTL6Jr83xZtPCH3aoJEOUR822OmBC05SSCI5PFLhr+KykmmzM7n4fLLfLX7jDukKB6YvZtZ/qoPeLoIgH5jjrIRg4w1U9RnmYG72jQeqcnbWKlk1l9w7uy1AANieA+vaBuna9Na+89vr6Nqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDU3pQSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDU3pQSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3A5C116B1;
	Thu, 25 Jul 2024 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918555;
	bh=V6adh8Lb0ZiL17NBgPzCflwBHKoe8+WQyM/xTsandtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDU3pQSjtL7No2BGV//Hkpqa9/ace0lnZ6MEw1x6XBr0x/Ia9NNC8VGpkQEBa9sn3
	 pNbfLP41UTGXM0uvfOf1tY0+TYGJfNoMv7GwpQwIdUry9G+F/LbKlEegW2Uiht3u+L
	 Inx9dpoPB6yZqcT3X7axlnzVi1zAT44fifFnaEF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/43] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Thu, 25 Jul 2024 16:36:44 +0200
Message-ID: <20240725142731.274426857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 524d3f126362b6033e92cbe107ae2158d7fbff94 ]

Set driver name to "HDMI". This simplifies the code and gets rid of
the following error messages:

  ASoC: driver name too long 'HDMI 58040000.encoder' -> 'HDMI_58040000_e'

Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20240610125847.773394-1-primoz.fiser@norik.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/omap-hdmi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/ti/omap-hdmi.c b/sound/soc/ti/omap-hdmi.c
index def2a0ce88863..e4f661c5349ef 100644
--- a/sound/soc/ti/omap-hdmi.c
+++ b/sound/soc/ti/omap-hdmi.c
@@ -353,11 +353,7 @@ static int omap_hdmi_audio_probe(struct platform_device *pdev)
 	if (!card)
 		return -ENOMEM;
 
-	card->name = devm_kasprintf(dev, GFP_KERNEL,
-				    "HDMI %s", dev_name(ad->dssdev));
-	if (!card->name)
-		return -ENOMEM;
-
+	card->name = "HDMI";
 	card->owner = THIS_MODULE;
 	card->dai_link =
 		devm_kzalloc(dev, sizeof(*(card->dai_link)), GFP_KERNEL);
-- 
2.43.0



