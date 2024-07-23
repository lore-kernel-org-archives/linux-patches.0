Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D436F158A07;
	Tue, 23 Jul 2024 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759620; cv=none; b=U7ecUqm5F08KLA8XzRip4pzvVwmhEncyRYVNTEkOIFwEgf5oa2GC9IGTPd6aBe00E1GKy2QnGNmrXSI3Nnh97sqV44eb0MpYpi6IokHt2yIsifxahlAFgbbJZObL1jeF0BUCfOGBevaGAFxxLwh414aU9X9Fp2Jqo+kHeG761Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759620; c=relaxed/simple;
	bh=KboczTn8qZmADTj5Ii98To4/uu5bLLZFkbbrYPk+/gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hty5ph1UGK8WisjlR13XXR6d7txyRlLmaaJspYXM8oI43fv54eBympPsfKls1j99tXE1OUvKsnNyl1spFma5aCuobrivgBDoJzl19Ly7nbf6iOa5VMMMFqBiJkUewuc+6/dz04orjrSpcL5pYceDbDGZ8zjXZBs9O1pnskoq8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k85F8+8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k85F8+8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA20C4AF0A;
	Tue, 23 Jul 2024 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759620;
	bh=KboczTn8qZmADTj5Ii98To4/uu5bLLZFkbbrYPk+/gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k85F8+8UKxHYbVBXJ9OI6RLcxHakZR3gzpiqTNIHHFwAlyUMV3h6JkNbW+OUNVDMN
	 l18ip1HcE8Pjxxs+JzWtnL2KXOOahqxSrIZ7ehnctlXnpT5DLqf9dl20ax7/b36fdr
	 Eud2EPmeAxYEb4FyvoLV2Ivl6M0mC1O2/VyAU6C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/129] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Tue, 23 Jul 2024 20:23:40 +0200
Message-ID: <20240723180407.564932784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index a3663ab065ac2..0a731b21e5a58 100644
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



