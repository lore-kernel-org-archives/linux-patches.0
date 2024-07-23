Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9E91581F4;
	Tue, 23 Jul 2024 18:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760092; cv=none; b=nU68mixMk9peB69kuM2JpNYW4xWHehSKBllx20Ss4d1SmSZPNhRl9Nx15QO1kxdScKK2YeSmwnJbR6MS80y2V0z8/s0cQfWKn9T7TvzNRdTi70SfjhzXRqtp5ZuCtr+P+1cBZ3X1JfrxEs63tr26q68SgA+1/Ny73QZksxBt24U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760092; c=relaxed/simple;
	bh=lsi2m4nyDQY5CuEyW/gps6XPJDAAQqj+jGGKOpTH35c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgB9x+5vOPegseEYpR06WS/D+18lj/u+6jbndikPDhpW7UUyY3Vi/2ETen8Pv6hblyPbmmzKYRAb8xFyT9t1N4TbzmO6zOutza6APJK/6MyaQDYBcj/BTlvMQqwDc3BGZGArg5n6Wf2qPREZ0XXU1zU9mvVubYmJnTJuI+JiVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIEYOrgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIEYOrgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C15C4AF09;
	Tue, 23 Jul 2024 18:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760092;
	bh=lsi2m4nyDQY5CuEyW/gps6XPJDAAQqj+jGGKOpTH35c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIEYOrgB4pyjfNOZn6mdIJ1n3TLOrnD3SJhq8iSi7xl844if184mkv1oAR+MLlQeq
	 qd9RhxenYcpzHhuqPeawRhh7HdK5dyoKbSt2fMYS8+Ex/e0E9G83VDZDSIi78lK97u
	 TlQULlzNKq0M8Fu1nrtknBSTOynTF8bhVMBpjquE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 098/163] ASoC: ti: omap-hdmi: Fix too long driver name
Date: Tue, 23 Jul 2024 20:23:47 +0200
Message-ID: <20240723180147.262972021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4513b527ab970..ad8925b6481ca 100644
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



