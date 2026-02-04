Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386353D994;
	Wed,  4 Feb 2026 15:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218214; cv=none; b=lJaA/1quomV5XHdrlliEfPYlwq6TdKfW/dcqg+olwKimCvVgxu2CU3wZQJea0qqgGZqJHlqYZFWWFmwKMu8k8N6o5pgKD1/C42V1o3mPQyvjmkG9MBK+wcRn/3pH+hi6HOYggpjLG03oo4P4IYzjZn/TPhJj1/QevVQ76JkCdlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218214; c=relaxed/simple;
	bh=3liBBa5nMhyHLSWra4V5CszlgV/N8ik/HOmw6a7oprc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcrQLafWq1lIv7GfrWWK8EzqY8cMO7mSXKcZxmIGaGewczcB4ksWCuPDOKlTaQMzFUcRyHSxU2trA83IjElyaD3DqO2BhMT4pxFB6hngIeUvtXIXEhA5w+Ez2U8n2V0cZy/PvLZm5eM8v47RzXnoWFa+JydgZqbFQ1i2DFETn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBYppnzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBYppnzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8794FC4CEF7;
	Wed,  4 Feb 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218214;
	bh=3liBBa5nMhyHLSWra4V5CszlgV/N8ik/HOmw6a7oprc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBYppnzl3rOBNJrkFX+94/istAntIOaCQHUCmjRMW155tf+ASVX6rjFqlb5LupXwp
	 mr4+FtVW5KxFsNOPJafYLz6h2T8vD9xNboOujUD+l1hTQ+YEymZ+S21xmmOrg0Jk0P
	 LH4lODSVIPB6i/wZ9eDzpdnr8STuQbfsxcEWnmuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/280] ASoC: codecs: wsa881x: Drop unused version readout
Date: Wed,  4 Feb 2026 15:40:20 +0100
Message-ID: <20260204143918.489350696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,7 +683,6 @@ struct wsa881x_priv {
 	 * For backwards compatibility.
 	 */
 	unsigned int sd_n_val;
-	int version;
 	int active_ports;
 	bool port_prepared[WSA881X_MAX_SWR_PORTS];
 	bool port_enable[WSA881X_MAX_SWR_PORTS];
@@ -694,7 +693,6 @@ static void wsa881x_init(struct wsa881x_
 	struct regmap *rm = wsa881x->regmap;
 	unsigned int val = 0;
 
-	regmap_read(rm, WSA881X_CHIP_ID1, &wsa881x->version);
 	regmap_register_patch(wsa881x->regmap, wsa881x_rev_2_0,
 			      ARRAY_SIZE(wsa881x_rev_2_0));
 


