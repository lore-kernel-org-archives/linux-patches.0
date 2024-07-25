Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31CD8468;
	Thu, 25 Jul 2024 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919020; cv=none; b=iRiwCcVy8BpPkmvQ5Z6H9VkNCf2I3Of5Rcq0PNZvRUKzzUy+JBNEav4ZgGqZ6JyVShAZ0unGHTOWMyeyTpIWQ1dYxxP59/CKJLC/xjcKNat5nMrhVHbPQRrwsgCDEFF7hAifP66zYVpkD/G6YeHVUVsnBXRu6hKhfgE4xMqjkWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919020; c=relaxed/simple;
	bh=WQEcn3j51i4fqavPf0S3N2tHt1zYzezeK8L6+YcPcs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJvo+vepdEI/iTVv+8MVo6Ny9RB+7MdOCzww3uYUEYWqHXY/ZKOPYI5fNFiWhrUPIVoiPKk3T4qJQFnIpFTTIngHcCaKO1i6k4bLFsKSod8Zhz6fj7wVOywnUxfs1/xjFhRkrxOMq0n626FM7NOOtM815KTVi6ngo8t3aYA5Fv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skOPjR+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skOPjR+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B02C116B1;
	Thu, 25 Jul 2024 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919019;
	bh=WQEcn3j51i4fqavPf0S3N2tHt1zYzezeK8L6+YcPcs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skOPjR+2QvIdJgVor9P+fR0muhO/zh1HuvPf0GDBtynavaimJDgAwBo3THBq571gb
	 JWwZKsHrHc6+3np2EEv16KrBHTfVjOqds6o4kEDJFaNDwDrCxNEOoeA3fPGuC0WZkI
	 hJUsh72SLmu5/wzyRs3qPnvxVAl+bFJnvnwDa16g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/59] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Thu, 25 Jul 2024 16:37:17 +0200
Message-ID: <20240725142734.286749148@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



