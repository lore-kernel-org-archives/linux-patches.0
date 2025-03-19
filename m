Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBB71CAA60;
	Wed, 19 Mar 2025 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395203; cv=none; b=H1J5+GIkY1PzP/YpOQYC2h5dbB6tL5/PFOeQb5FKmdK5TtYEabT8TG8rFm3ntNrH6xPJj1R3xZyvURRt+tyn7v002yrYgzdz3OS3zYyXV8zGf+k/V4qT699aT/0CZTI44ta5ApKjVFG+WY4IsYrzcNDlXE71TX0/4X0JpnfzGkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395203; c=relaxed/simple;
	bh=O2nATOfN8lsEhzP3x0fWe0+NKPC9bvd87vYUsfw/kDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZRaQyUOSkjQZyU/WJUwIabLcMZZiQQb5zHkWdL+RKlAahz4yYePTjzNSt5HAbZeOlg4SdLoocGg+wmUbf+V5U++hOuadKk8mIV8NlLNAHPYdf53BtYcrkWFc4lGlp5qOniQofDMZJZIbhydPpkQfgMsJXdYwXMVx8CjkWTfy9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmNMvCB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmNMvCB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEE9C4CEE4;
	Wed, 19 Mar 2025 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395202;
	bh=O2nATOfN8lsEhzP3x0fWe0+NKPC9bvd87vYUsfw/kDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmNMvCB7xywuvQBIwyN6GYlQoZEQQxAfDAigAWdYzWNd3UYR12vDjazPwMAo/VbMd
	 MTEcLEfDgp1OOLjPzRSatdleRdyJb1c0IoboWhLi5qI7NJZwxqI5rKqk/ZxfRaghjc
	 qHUVjXkdkNMT5NLsEYddxHGYH2W7bDpco+aQXu5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/166] ASoC: simple-card-utils.c: add missing dlc->of_node
Date: Wed, 19 Mar 2025 07:30:37 -0700
Message-ID: <20250319143021.800193841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit dabbd325b25edb5cdd99c94391817202dd54b651 ]

commit 90de551c1bf ("ASoC: simple-card-utils.c: enable multi Component
support") added muiti Component support, but was missing to add
dlc->of_node. Because of it, Sound device list will indicates strange
name if it was DPCM connection and driver supports dai->driver->dai_args,
like below

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.(null).rsnd-dai.0 (*) []
	...                                     ^^^^^^

It will be fixed by this patch

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.sound@ec500000.rsnd-dai.0 (*) []
	...                                     ^^^^^^^^^^^^^^

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/87ikpp2rtb.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 2588ec735dbdf..598b0000df244 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1086,6 +1086,7 @@ int asoc_graph_parse_dai(struct device *dev, struct device_node *ep,
 	args.np = ep;
 	dai = snd_soc_get_dai_via_args(&args);
 	if (dai) {
+		dlc->of_node  = node;
 		dlc->dai_name = snd_soc_dai_name_get(dai);
 		dlc->dai_args = snd_soc_copy_dai_args(dev, &args);
 		if (!dlc->dai_args)
-- 
2.39.5



