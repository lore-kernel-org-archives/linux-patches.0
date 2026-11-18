Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030560;
	b=XPs0/af3mDrmv5w+qWbnSKHMHl4nCRaTKXxHEA7GGN/J1cDoBz6NA8SYK99rL/c89sr4
	 lDMrnUxSHvz93LULCVhj6aunaBj8/r+Y3nZMKyGK45HaRNOUdCF67/tGxhtoaSZmb+Ljc
	 8OnZ4q09uzbMz/l5NL18s83BXAEeaa2m0XnY14dB1xqmUT36ij4xU5sLvDxi/2vWqs7bd
	 gnz2oKWYgi+DEzKrxSzsrN8cx1jJkFHk1JyAUlLnjlUrizbliPAivr2gQm+4SrIsuam6w
	 FDMD7CNtjvMcoPpLf49SoXXL47l7N7AtgaI/fewkiDHuK82dqRXREXOTCg+8RKA9Bcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98nc/QQij9RpL051W4J6g2df6NIaqtZLYidVYmQQawg=;
	b=XrtqbpZsVyBd/m3k3E882R2r5yX/4M5ck70Hm9oLVb5P4cvFPNQg1Y9vZBx0v1icvU34
	 WiMmeQqIFfrIHTTIr8x8/CXdJD6rtcVeS/tjm28g7T7wpSQ6LeO8WLiKBsv4HK6kASfRq
	 ZJc1v2K5DUiZTD0a3Ajl0AiBT7k1euRW4OXoXVT2KxFXmsxgzlxKd86KaD0uunOZgfrgy
	 0gfOUV50c3zBQhLNv3HDhuHQIEC9n6dhQnjeGxoAB+LkdIw0avhHAkszjwvHirU3KDBjx
	 /DdhfKt1NxG9Rw1DHZR/zGNJuiwZRWvWW4WsaS/0lL+fBbkSF3kW4lcX8a7h2maT9Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPVQbFx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6B606D370;
	Wed, 18 Nov 2026 19:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPVQbFx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE051F000C4;
	Wed, 18 Nov 2026 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030560;
	bh=98nc/QQij9RpL051W4J6g2df6NIaqtZLYidVYmQQawg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPVQbFx4PNOVZgG4A1ZXZCAsZ4OSnbtr3xiKNc3aQLpcW0Gw+A09qBCy2LE1YgWrX
	 HGYPhZhW/rP4QzjbnhyZqlZ7NHIx+dTpLPQePcVVqOg4vxx5s6U8QrsFzsDbmz0942
	 UWq4aO/7Ractt1FnYW6VBH0hTw/92B8wO2Yxulrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0741/1756] ASoC: rt712: avoid duplicate reset in io_init
Date: Wed, 18 Nov 2026 15:47:48 +0100
Message-ID: <20261118150039.108486834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 923ff8155ef6e83b73b852300d50f2053b969552 ]

The codec should be reset only once during io_init, regardless of
whether the system performs a warm or cold reboot.

Fixes: 4c9854ad3cdc ("ASoC: rt712-sdca: reset codec at io_init to fix silent headphone")
Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20261001090219.797880-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index f48ebdf6b6226..69db35e47a328 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1834,7 +1834,8 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
-	rt712_sdca_reset(rt712);
+	if (!rt712->first_hw_init)
+		rt712_sdca_reset(rt712);
 
 	rt712_sdca_index_read(rt712, RT712_VENDOR_REG, RT712_JD_PRODUCT_NUM, &val);
 	rt712->hw_id = (val & 0xf000) >> 12;
@@ -1858,7 +1859,7 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	 * if set_jack callback occurred early than io_init,
 	 * we set up the jack detection function now
 	 */
-	if (rt712->hs_jack)
+	if (rt712->hs_jack && (!rt712->first_hw_init))
 		rt712_sdca_jack_init(rt712);
 
 	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_SW_CONFIG1, 0x0001);
-- 
2.53.0



