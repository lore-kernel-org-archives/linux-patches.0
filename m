Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5C31990DD;
	Thu, 25 Jul 2024 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919154; cv=none; b=jSjCYQkyaZkU2tn6phh02UU8CBKN/h6ZACaYEE0JrXycpa8hAKqZa3jJgNvMSzMjSYgyWEH9nKvaGSpb1vMixoQgjMliwplEISDcdq+KIbuoEQvjd6mJ0EjLrb+89S0O5aB98NF7TExmcCFWgBemtiV0effQaRVs3/PyNhZO3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919154; c=relaxed/simple;
	bh=dQIVKIS/JI4EzCh1zY5CPyH5DSrv1tBqYCQbRLkdZlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjeKozwVp+YlICaBWE2fZHJAhXy5IRD9viY04/2WJZwG3RNmo7x6XwV4PN2YkJ3WJWMZ33OezYnQZeBG3ZMt+TJ0q3tWP6KlDdyCBhQtrmkjgFSMx8FsP1sCSs5zoIqPKJK7UYvB50zRVDF3+0h4vLSgtke+QgU0XbW4GZU9fD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPAyITji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPAyITji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B64C116B1;
	Thu, 25 Jul 2024 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919154;
	bh=dQIVKIS/JI4EzCh1zY5CPyH5DSrv1tBqYCQbRLkdZlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPAyITjiS7fTDltmTaUV8Fwx+ZPx42v66bpN/CwSG76T8/52Nqcf7y1Y5RZNyDMun
	 9kk6RP+d0nDjXi/PM5OPt4/EibWfnf0dvIzR6xLwdXSheX9Dd+pC6HdG8S7CtNu0FC
	 40CwCxrPIOhxMG6mz/ug2RD2TNjN/MHOOkH+hGdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/87] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Thu, 25 Jul 2024 16:37:14 +0200
Message-ID: <20240725142739.984469195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3328c02f93c74..1dfe439d13417 100644
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



