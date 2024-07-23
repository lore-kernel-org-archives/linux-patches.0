Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F7A156F29;
	Tue, 23 Jul 2024 18:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759356; cv=none; b=MAP9TiKRHYOaIgeR9Sx1p+2bVbabd3aFQRAGDZaaSt1tCdiIHLbqpo6CJ5WPCTIxPRsiMGTFrTk+RMs452sK1iCiNSWt4Vd849zShtD/Mj8Kdzwl2BMmZo54Uta5EkGkr7sT75f/K462m2nIbj01lkx5JUWti3bjAD38Vm4TEUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759356; c=relaxed/simple;
	bh=ehOg+Q8uroEIvSIajdwycwAZ2tlxgp17sZe4q1Y/3dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2IIazCBKaHlg5lFzNuCwK05s20azIw40a3B6t5W3YYTm3H6furr8jD08GiB/5WHgCxWVLgxC0ev+gi5rZf82AyEWHACo82RcV19XVzXsDnl82QPiQo/KnHxiLbrCvAmp24KFBAaxwOBhYIg05ekPDHi7pZ1nuS6tJ8dP6/3mis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oe8rqsU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oe8rqsU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C63C4AF09;
	Tue, 23 Jul 2024 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759356;
	bh=ehOg+Q8uroEIvSIajdwycwAZ2tlxgp17sZe4q1Y/3dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oe8rqsU4rzrFMYRdZ5gqRXfZFqIbwAZuWGypmCyrByBzDq66ABpLF/rreJVzz3pfy
	 7PrMK4fwlP11VdqqFhDOdsgYzg//Xqcw8cb9KFzdoS3zno6ie3GBZSxVCUDKBWOicn
	 fTc6IYjXDmO1R7bur0BRvVZrjnKIf8knfzlm3cd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/105] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Tue, 23 Jul 2024 20:23:38 +0200
Message-ID: <20240723180405.599003204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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
index 0dc0475670ffe..554e7896e8053 100644
--- a/sound/soc/ti/omap-hdmi.c
+++ b/sound/soc/ti/omap-hdmi.c
@@ -354,11 +354,7 @@ static int omap_hdmi_audio_probe(struct platform_device *pdev)
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



