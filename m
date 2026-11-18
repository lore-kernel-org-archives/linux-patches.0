Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062006;
	b=GGFij3SmzJ1HStD++RRV9miDJp54J1kL+pXn04Rhe6PiXjRy4Hom/xn1AL9t3hBsNGdu
	 aFZxjcqgScznV7G21C+Yh2nFvtNwFrxeqhlnNDIq1fuD6bGpgZoQdOpWCELvZRrOEBcql
	 Ca1U43S6YGO7DO3wjClPgF0BpMyzotvf435If+pTWSNbrs2AgSPBJiO/48w/vJ2tsSDSr
	 aUMCBZuOKGkaAPmQGvSeQB1YKqXkNB/M9/8J3Prr8Uwl/Rh1+edSiTBfpwpwU2dFhTphW
	 Ix+Lne93mjoJaKNY4RU7X0jMJ/PY2EnvU/zdPrayigiQTFcrsWWdQwd8ngLV+XSfkOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0k+iKEJ4e9vsgRngec160/dTTdQSmEA0fDTTkjdqak=;
	b=QXCdAFXHp+MA29VvfVM80CRjoEVEblf+Qq5OyCENLZR7FKrPcGwg5Uhindrm5TujV5ro
	 cdKm5jfZPYiQ9oRNshu7QHqqACfi9b/oOaeqHggKv2HZvw99G8RNPF/et7XGihZCmHI1u
	 Dd54xtX5Ys+a2EKYWZN6kszLe/8KUR2X3oLFCRZb3K7Qt1DVS5JC60VTbq7ZIEkTdng+T
	 mhGTZxO7o8mQ0DU8UjuxURLQO9kEiHNn2Ubv+oOE+NlIZDM4wEGq/shzMUv+PVza4rOFc
	 CFXiud7AX0UmKyqarh5JzA9hqE9jgscYH94fuUigQW6x0aFX6ZOA+3ZHfdzIR/D58hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZibTUErZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C1606A320;
	Thu, 19 Nov 2026 04:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZibTUErZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7E31F000C4;
	Thu, 19 Nov 2026 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062005;
	bh=K0k+iKEJ4e9vsgRngec160/dTTdQSmEA0fDTTkjdqak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZibTUErZo/vzsAPoG0k0eXMCHJ8kPfJFnP33n2U7uRn9HMhTaoXVJM0dCkfBTeySa
	 +X5wYRzr+LESQfpMcueDm5qTbSpbowf3e+3b3IO6xLBbpqsxYaTWf6quQPI0PQSyNL
	 z1E4tzhkP4nWqAPbUsBxQCXctHx+ufQyGSSOLhVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1756/1848] ASoC: wm8994: follow AIF clock source changes in MCLK gating
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150032.963609325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 8731e33a3b98ea1ccade059b3a1ce06b7dd66b17 ]

The AIF clock source can be changed by configure_aif_clock() while the
AIF clock is running, for example the Midas machine driver switches
AIF1 between MCLK2 and FLL1 while AIF1CLK is kept enabled for jack
detection. aif_mclk_set() only enables the MCLK selected at the time
the AIF clock is turned on, so an MCLK selected later this way is never
enabled, and the codec may run from a stopped clock.

Track whether the AIF clock is running and, if so, enable the newly
selected MCLK in configure_aif_clock() before switching to it, then
release the previously enabled one.

Fixes: 001b83d395ab ("ASoC: wm8994: Add support for MCLKn clock gating")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261022101531.775891-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 27 +++++++++++++++++++++++++++
 sound/soc/codecs/wm8994.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3e27166192cd5..340446a21c8aa 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -162,9 +162,12 @@ static void wm8958_micd_set_rate(struct snd_soc_component *component)
 static int configure_aif_clock(struct snd_soc_component *component, int aif)
 {
 	struct wm8994_priv *wm8994 = snd_soc_component_get_drvdata(component);
+	struct clk *mclk = NULL;
+	bool switch_mclk;
 	int rate;
 	int reg1 = 0;
 	int offset;
+	int ret;
 
 	if (aif)
 		offset = 4;
@@ -173,11 +176,13 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 
 	switch (wm8994->sysclk[aif]) {
 	case WM8994_SYSCLK_MCLK1:
+		mclk = wm8994->mclk[WM8994_MCLK1].clk;
 		rate = wm8994->mclk_rate[0];
 		break;
 
 	case WM8994_SYSCLK_MCLK2:
 		reg1 |= 0x8;
+		mclk = wm8994->mclk[WM8994_MCLK2].clk;
 		rate = wm8994->mclk_rate[1];
 		break;
 
@@ -195,6 +200,20 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 		return -EINVAL;
 	}
 
+	/*
+	 * If the AIF clock is running, enable the new MCLK before switching
+	 * to it and release the previous one afterwards.
+	 */
+	switch_mclk = wm8994->aif_clk_on[aif] && mclk != wm8994->aif_mclk[aif];
+	if (switch_mclk) {
+		ret = clk_prepare_enable(mclk);
+		if (ret < 0) {
+			dev_err(component->dev,
+				"Failed to enable MCLK for AIF%d\n", aif + 1);
+			return ret;
+		}
+	}
+
 	if (rate >= 13500000) {
 		rate /= 2;
 		reg1 |= WM8994_AIF1CLK_DIV;
@@ -209,6 +228,11 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 			    WM8994_AIF1CLK_SRC_MASK | WM8994_AIF1CLK_DIV,
 			    reg1);
 
+	if (switch_mclk) {
+		clk_disable_unprepare(wm8994->aif_mclk[aif]);
+		wm8994->aif_mclk[aif] = mclk;
+	}
+
 	return 0;
 }
 
@@ -1070,6 +1094,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 	if (!enable) {
 		clk_disable_unprepare(wm8994->aif_mclk[aif]);
 		wm8994->aif_mclk[aif] = NULL;
+		wm8994->aif_clk_on[aif] = false;
 		return 0;
 	}
 
@@ -1089,6 +1114,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		clk_idx = WM8994_MCLK2;
 		break;
 	default:
+		wm8994->aif_clk_on[aif] = true;
 		return 0;
 	}
 
@@ -1099,6 +1125,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		return ret;
 	}
 	wm8994->aif_mclk[aif] = wm8994->mclk[clk_idx].clk;
+	wm8994->aif_clk_on[aif] = true;
 
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8994.h b/sound/soc/codecs/wm8994.h
index 1dc1a5d23af5e..53d5fa6669ebd 100644
--- a/sound/soc/codecs/wm8994.h
+++ b/sound/soc/codecs/wm8994.h
@@ -82,6 +82,7 @@ struct wm8994_priv {
 	struct wm8994 *wm8994;
 	struct clk_bulk_data mclk[WM8994_NUM_MCLK];
 	struct clk *aif_mclk[2];
+	bool aif_clk_on[2];
 	int sysclk[2];
 	int sysclk_rate[2];
 	int mclk_rate[2];
-- 
2.53.0



