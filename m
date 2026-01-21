Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCFA33A9F4;
	Wed, 21 Jan 2026 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020008; cv=none; b=Q0Dw8Lq/igvhaNl5XY6I6ryJVv0CoHLAT1A7zecHeOAEgVfR+umhQ22Ic/LU4X9ag9vsdlRrb3goDZPTSHjro16azvmOaIxjUIZ0khJP65XMzhHRDsmxZyN86lmbvnhXiK0AjZoflbat8x8OjnLaGJgUJizGkziERdC1eM6h0D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020008; c=relaxed/simple;
	bh=x7JiNmZdDA8IOvkhFAw9ytsubegl7Yf9bASzVwDY82s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+i/kSzYoyHJOOccCIp/eSrCY4XIMVRzGDbd5/2gdD4aDdyEGrpvle/SnwPiL4B8s/7oSy/Ttn6AZNPka8Ls+K9Rn/BFMLTwk7PskcYf9wzTl57oOcD7F2QRiN31FVeM/ug2S7VA7lEHPScsWHPdHsVfVHz5RhPtqcqvEqsfudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b74WfVYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b74WfVYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF577C4CEF1;
	Wed, 21 Jan 2026 18:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020008;
	bh=x7JiNmZdDA8IOvkhFAw9ytsubegl7Yf9bASzVwDY82s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b74WfVYXMz3gumlHy69ZaELUfIWQyD4tTncDHSFFSBZxpNdOJAKenAbnwyErWvKGp
	 ZZYGrLd+RRMSAqDabyLPdjSZJitVt1/rapdnYlHYNk0iDlOlclDM3YM3R2BN3CGgzo
	 GJRYlbTwX9LAI5Z0saQZyoi/0hcJynm1U9kydO58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 007/198] ASoC: codecs: wsa884x: fix codec initialisation
Date: Wed, 21 Jan 2026 19:13:55 +0100
Message-ID: <20260121181418.808891976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 120f3e6ff76209ee2f62a64e5e7e9d70274df42b upstream.

The soundwire update_status() callback may be called multiple times with
the same ATTACHED status but initialisation should only be done when
transitioning from UNATTACHED to ATTACHED.

Fix the inverted hw_init flag which was set to false instead of true
after initialisation which defeats its purpose and may result in
repeated unnecessary initialisation.

Similarly, the initial state of the flag was also inverted so that the
codec would only be initialised and brought out of regmap cache only
mode if its status first transitions to UNATTACHED.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Cc: stable@vger.kernel.org	# 6.5
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260102111413.9605-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa884x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1534,7 +1534,7 @@ static void wsa884x_init(struct wsa884x_
 
 	wsa884x_set_gain_parameters(wsa884x);
 
-	wsa884x->hw_init = false;
+	wsa884x->hw_init = true;
 }
 
 static int wsa884x_update_status(struct sdw_slave *slave,
@@ -2109,7 +2109,6 @@ static int wsa884x_probe(struct sdw_slav
 
 	/* Start in cache-only until device is enumerated */
 	regcache_cache_only(wsa884x->regmap, true);
-	wsa884x->hw_init = true;
 
 	if (IS_REACHABLE(CONFIG_HWMON)) {
 		struct device *hwmon;


