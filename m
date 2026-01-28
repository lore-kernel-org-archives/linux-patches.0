Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897962F3618;
	Wed, 28 Jan 2026 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614783; cv=none; b=BdiRiFjawRXaCPXcegaKgLN2AGFw8ZTrWdtPCxnSz+bXcV8m2X2EzpMN9NmBn5Vl8b2P1Y5RdGiUQsDwQiuCxdB7G6MoQMxD0hz4yVd56LONiytkBQi21FOtD9J7HeI7DUdTMd3Aq3+Y9JPM+ntmKgNHY4caGYnMTLVPAmueh5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614783; c=relaxed/simple;
	bh=BomN3kcH9VqHb3Ckkt2kPxBMEYT62U/Ti7rhBsntgy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzXKGpLq/H7a0PM+N95o0obaJ4nzej5slarnDAggzJZYILOsLx500lEq8IWoVz2J6eG9puPMZs0P51ioFIg18zfVPvEd1TbymlGxbhRhh4MCb8VI958hcJh6SxDHjzkss65HN8JsJS0I9Z7+7Mmmr+TV21/Q+ioKsOkwvp8KX34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qut1Z/iH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qut1Z/iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01366C4CEF1;
	Wed, 28 Jan 2026 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614783;
	bh=BomN3kcH9VqHb3Ckkt2kPxBMEYT62U/Ti7rhBsntgy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qut1Z/iH8PU57/AWHZd9HW2fzc7DjG5BGRKebn/wSP4gJ2WL49AkFOWuyJ8COUrYe
	 4nmVv5uGl0wFyMDmpCmOAWQh8Be/k2CcK31donpcqoNqLbBJFD8RTabyL4FmVcnw6T
	 3dJcyevadRRK7ZhaQ7wpDAOod03dQJbppdc5RLgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/254] ASoC: codecs: wsa881x: Drop unused version readout
Date: Wed, 28 Jan 2026 16:23:35 +0100
Message-ID: <20260128145353.394425910@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 3d2a69eb503d15171a7ba51cf0b562728ac396b7 ]

Driver does not use the device version after reading it from the
registers, so simplify by dropping unneeded code.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240710-asoc-wsa88xx-version-v1-1-f1c54966ccde@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 29d71b8a5a40 ("ASoC: codecs: wsa881x: fix unnecessary initialisation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa881x.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -680,7 +680,6 @@ struct wsa881x_priv {
 	 * For backwards compatibility.
 	 */
 	unsigned int sd_n_val;
-	int version;
 	int active_ports;
 	bool port_prepared[WSA881X_MAX_SWR_PORTS];
 	bool port_enable[WSA881X_MAX_SWR_PORTS];
@@ -691,7 +690,6 @@ static void wsa881x_init(struct wsa881x_
 	struct regmap *rm = wsa881x->regmap;
 	unsigned int val = 0;
 
-	regmap_read(rm, WSA881X_CHIP_ID1, &wsa881x->version);
 	regmap_register_patch(wsa881x->regmap, wsa881x_rev_2_0,
 			      ARRAY_SIZE(wsa881x_rev_2_0));
 


