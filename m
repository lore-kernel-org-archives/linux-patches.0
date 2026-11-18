Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061986;
	b=sN39zyeqWAj2IV0wXp1sn02yYZFq+z1R3wjk5TM6Yf1ciUeTSD3aPFUarhXl3/nhE6Wf
	 qVvdGQilkR79Ad+KYz8M0S6SItf26nFH0gzJT7C81xS7pGyJjt/T+nN5+uu/k4L5Ed1YN
	 ffTuX2NnxeR6xDO5e0XUlMqWx4RY5W77EsADjGyNpW0ATbF97X9BMSBYUasSBT0ehnVrN
	 Voa2xaJ1IAAUbLSBrORcXwmtNghhROrVOtVPQN1MJPeOVRdIN488hx49AddSOBTEBORwm
	 GaFZgaeBmPBZ54mfULqWmaLbeYRtvR/zBcdEFLDjkI3yEBeTqwwIak4FzQy+YtGom7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0GHC4Wlyh93Zjv8opGeM9YwHuP2sU7apc7t5J/HS7w0=;
	b=bhlk1O3hrBnUMkrlnwYABkgiLGMwCE/HmfESTBQzK2nuSc4GIxUZs2vR7K9S80r2modN
	 pAfcBdkmg2GP6FaIvQjHnWxwWQ9FYcEnKHPhC1WBZ9LRU67naeXxfZJtzK0qR7Ityc6/4
	 KV4vTwGoAcYL4LloIfCwGiKRTMEbZbvl+oQtUG/0zzF5ct+ZshwTMFN+BaF6hBR5eeUyd
	 dmSi4bDpl1c3hhAB5Q9EkiWinVOv4gQKFKKg40yAb/ktxFEoNnUcANvfUgZvdrseMobQ1
	 5eFExjB7Jz83VLFTqSMWRPlxT1cs3KkgnELc38186C8MRreW8wqBZ5VhjP2IjOekbPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA1JwVMW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97CC606A320;
	Thu, 19 Nov 2026 04:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA1JwVMW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5B91F000C4;
	Thu, 19 Nov 2026 04:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061986;
	bh=0GHC4Wlyh93Zjv8opGeM9YwHuP2sU7apc7t5J/HS7w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA1JwVMWWExJB72OyBnCMUEQCwZlMePuuSqKVOqvXmHO8GvWQCcq3udP9ONj/uagK
	 xSPgSNi85L4QNlnjGt6rB6JLxnteJrouISIY1hbkPz/18e3AbDEmPypKfOP+Hh+cmQ
	 uhqwwBce0vN3WkrCO19Leabk2EWkKCMa/lSdLf40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1749/1848] ASoC: wm8994: dont lose the AIF clock ratio when staying at 32kHz SYSCLK
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150032.705501522@linuxfoundation.org>
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

[ Upstream commit 693574504051a19383640cfb99524a6b69e4624f ]

When SYSCLK drops below 50kHz, the AIFnCLK rate ratio is saved and
temporarily lowered to 128fs for accessory detection, then restored
once SYSCLK gets fast enough again. The ratio is however saved again
on each clock reconfiguration done while SYSCLK is still slow, which
overwrites the original ratio with the 128fs one.

This happens on the Exynos4412 Trats2 board, which set MCLK2 as SYSCLK
twice during the card probe and then configure FLL1 while still running
from MCLK2. Once SYSCLK is switched to FLL1, the 128fs ratio is
"restored", so AIF1 is left configured for 48kHz at 128fs while being
clocked at 256fs. If any digital path is powered up before a stream
reconfigures the AIF, the codec raises FIFO error interrupts every
10ms, flooding the kernel log:

 wm8994-codec wm8994-codec: FIFO error

Save the original ratio only when entering the low SYSCLK mode. While
at it, move the code duplicated in _wm8994_set_fll() and
wm8994_set_dai_sysclk() to a common helper.

Fixes: 6730049a4763 ("ASoC: wm8994: Lower AIFnCLK divisor when dropping to 32kHz")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Link: https://patch.msgid.link/20261021101750.3297770-3-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 94 +++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 54 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 02ba1e1970a8c..efc883a07e94b 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2210,6 +2210,44 @@ static int wm8994_get_fll_config(struct wm8994 *control, struct fll_div *fll,
 	return 0;
 }
 
+/*
+ * If SYSCLK is less than 50kHz adjust AIFnCLK dividers for detection,
+ * restoring the original ones once SYSCLK is fast enough again.
+ */
+static void wm8994_update_aif_clk_rate(struct snd_soc_component *component)
+{
+	struct wm8994_priv *wm8994 = snd_soc_component_get_drvdata(component);
+
+	if (max(wm8994->aifclk[0], wm8994->aifclk[1]) < 50000) {
+		/* Don't overwrite the saved dividers with the 128fs ones */
+		if (!wm8994->aifdiv[0]) {
+			dev_dbg(component->dev, "Configuring AIFs for 128fs\n");
+
+			wm8994->aifdiv[0] = snd_soc_component_read(component,
+								   WM8994_AIF1_RATE)
+				& WM8994_AIF1CLK_RATE_MASK;
+			wm8994->aifdiv[1] = snd_soc_component_read(component,
+								   WM8994_AIF2_RATE)
+				& WM8994_AIF1CLK_RATE_MASK;
+		}
+
+		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
+				    WM8994_AIF1CLK_RATE_MASK, 0x1);
+		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
+				    WM8994_AIF2CLK_RATE_MASK, 0x1);
+	} else if (wm8994->aifdiv[0]) {
+		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
+				    WM8994_AIF1CLK_RATE_MASK,
+				    wm8994->aifdiv[0]);
+		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
+				    WM8994_AIF2CLK_RATE_MASK,
+				    wm8994->aifdiv[1]);
+
+		wm8994->aifdiv[0] = 0;
+		wm8994->aifdiv[1] = 0;
+	}
+}
+
 static int _wm8994_set_fll(struct snd_soc_component *component, int id, int src,
 			  unsigned int freq_in, unsigned int freq_out)
 {
@@ -2444,33 +2482,7 @@ static int _wm8994_set_fll(struct snd_soc_component *component, int id, int src,
 
 	configure_clock(component);
 
-	/*
-	 * If SYSCLK will be less than 50kHz adjust AIFnCLK dividers
-	 * for detection.
-	 */
-	if (max(wm8994->aifclk[0], wm8994->aifclk[1]) < 50000) {
-		dev_dbg(component->dev, "Configuring AIFs for 128fs\n");
-
-		wm8994->aifdiv[0] = snd_soc_component_read(component, WM8994_AIF1_RATE)
-			& WM8994_AIF1CLK_RATE_MASK;
-		wm8994->aifdiv[1] = snd_soc_component_read(component, WM8994_AIF2_RATE)
-			& WM8994_AIF1CLK_RATE_MASK;
-
-		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
-				    WM8994_AIF1CLK_RATE_MASK, 0x1);
-		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
-				    WM8994_AIF2CLK_RATE_MASK, 0x1);
-	} else if (wm8994->aifdiv[0]) {
-		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
-				    WM8994_AIF1CLK_RATE_MASK,
-				    wm8994->aifdiv[0]);
-		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
-				    WM8994_AIF2CLK_RATE_MASK,
-				    wm8994->aifdiv[1]);
-
-		wm8994->aifdiv[0] = 0;
-		wm8994->aifdiv[1] = 0;
-	}
+	wm8994_update_aif_clk_rate(component);
 
 	return 0;
 }
@@ -2588,33 +2600,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 
 	configure_clock(component);
 
-	/*
-	 * If SYSCLK will be less than 50kHz adjust AIFnCLK dividers
-	 * for detection.
-	 */
-	if (max(wm8994->aifclk[0], wm8994->aifclk[1]) < 50000) {
-		dev_dbg(component->dev, "Configuring AIFs for 128fs\n");
-
-		wm8994->aifdiv[0] = snd_soc_component_read(component, WM8994_AIF1_RATE)
-			& WM8994_AIF1CLK_RATE_MASK;
-		wm8994->aifdiv[1] = snd_soc_component_read(component, WM8994_AIF2_RATE)
-			& WM8994_AIF1CLK_RATE_MASK;
-
-		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
-				    WM8994_AIF1CLK_RATE_MASK, 0x1);
-		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
-				    WM8994_AIF2CLK_RATE_MASK, 0x1);
-	} else if (wm8994->aifdiv[0]) {
-		snd_soc_component_update_bits(component, WM8994_AIF1_RATE,
-				    WM8994_AIF1CLK_RATE_MASK,
-				    wm8994->aifdiv[0]);
-		snd_soc_component_update_bits(component, WM8994_AIF2_RATE,
-				    WM8994_AIF2CLK_RATE_MASK,
-				    wm8994->aifdiv[1]);
-
-		wm8994->aifdiv[0] = 0;
-		wm8994->aifdiv[1] = 0;
-	}
+	wm8994_update_aif_clk_rate(component);
 
 	return 0;
 }
-- 
2.53.0



