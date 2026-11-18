Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021564;
	b=Q6RyATLK+L+UtBk4CM1rFWHJYpImZeuwYIX1lnfdzw82yRMsDNefelknYmG4/x2r9sL3
	 NgBnGYp8LjbE1D6IYbjSb2Ascj8NtL7ye+gMebZ0j6aNgCW0WTf9IXBRwbW24vLlVh1Jv
	 QDlDEj48EpmuGAk51cU7J3Dn8lj9GcxtGjkjlp0LwbdMBQ6Ui9cXMVtcVP1a1QlwyA9et
	 vgV0rO3WxHM8bi+424pW6C2BOOqgMH7FNF5aFNfnL/rXPQiKHC6INdDSgY7Ncag5V1Xgc
	 NH6pgiQbktRtDVzsOsTbME3FhqOele35cMqIjBIs2gCuY3pWrdGTkJbU2aD8ubs9ilw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQr1cVrBsciFC0qJzO6JGxybXj8C6nhadYVGW3x6Pvk=;
	b=qelUXAC1vBjBREN+M8L6S0XfSy/iJjKIimIJmET4bPjIeeZQzzbIyAcPsBwcGJXNGLSL
	 ZlM6SxoBWnJIwxlO7l908zqhIJwYnFNM+GREL2a8PVstuzzncbas1fUlNuJBSRz5tDuwL
	 nGWNxUo3efzRCDLsDPAX2u/F9s0PW1gLpbVOiRDGsvno6XabImU+1TrfyjDKKxC9BBvp5
	 cvuQYtEePS+JUiXJeyF/gYZaao+cB6pBcDdFsCWkPQZTFLI/kUPpKp17TLbynd/86wO2E
	 EIdHJX38/qmFezhyFSUbP3mMa5noZ6phwQqL0VplLBBsB+kozp2NSiX+qJh7KwB3+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSA8FAtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4332B606A325;
	Wed, 18 Nov 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSA8FAtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9432D1F000C5;
	Wed, 18 Nov 2026 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021564;
	bh=gQr1cVrBsciFC0qJzO6JGxybXj8C6nhadYVGW3x6Pvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSA8FAtkqJa/OJGpF1glmYI5w/3Z9faAFobVsmU1usPYw7o2buEZ2meSbdBnAJ1x7
	 2uItpP3YaPjjh2lKc4dG2ZxE+Omob8Cd2HvjG5P1rM5csKwwmQgvFpm1ht9MMHA6po
	 2wm+jm7JpzZYynua1gw9p9vJLzXqYZRT4pDpyKGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2351/2651] ASoC: wm8994: follow AIF clock source changes in MCLK gating
Date: Wed, 18 Nov 2026 15:59:51 +0100
Message-ID: <20261118150409.693997590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index dd6a9a3c73610..5d27cefd9d543 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -163,9 +163,12 @@ static void wm8958_micd_set_rate(struct snd_soc_component *component)
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
@@ -174,11 +177,13 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 
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
 
@@ -196,6 +201,20 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
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
@@ -210,6 +229,11 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 			    WM8994_AIF1CLK_SRC_MASK | WM8994_AIF1CLK_DIV,
 			    reg1);
 
+	if (switch_mclk) {
+		clk_disable_unprepare(wm8994->aif_mclk[aif]);
+		wm8994->aif_mclk[aif] = mclk;
+	}
+
 	return 0;
 }
 
@@ -1067,6 +1091,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 	if (!enable) {
 		clk_disable_unprepare(wm8994->aif_mclk[aif]);
 		wm8994->aif_mclk[aif] = NULL;
+		wm8994->aif_clk_on[aif] = false;
 		return 0;
 	}
 
@@ -1086,6 +1111,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		clk_idx = WM8994_MCLK2;
 		break;
 	default:
+		wm8994->aif_clk_on[aif] = true;
 		return 0;
 	}
 
@@ -1096,6 +1122,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		return ret;
 	}
 	wm8994->aif_mclk[aif] = wm8994->mclk[clk_idx].clk;
+	wm8994->aif_clk_on[aif] = true;
 
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8994.h b/sound/soc/codecs/wm8994.h
index 5b22cfab317e1..e7df0a1a2314c 100644
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



