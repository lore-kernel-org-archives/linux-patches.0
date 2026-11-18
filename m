Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056830;
	b=XRC7Hc+hUWlAjNYzbOx7KBkdJS1r+bcBdEBhS7cpTxkKM4D4d7inZYYcL2ZUsdGGDeFs
	 7Uo78QdL6T+Ygd7H+5E3ppXDnt18mQeyQN8DjHAzdSdHrZUjMmwoxOOnfqLRvcs+dVzB1
	 VNQtNxXmolr0Z6xJjYUxjzUDnVMrdAKv3x1bPQObyIjxlu4Y9KoB++m6DTTyNb+2t39w/
	 HTNWpKDUo6+00DOlzm0eGAyJSgGJii9QDv+ySigT5Sp+eeGOklCvY148UVRCVFh9mya7S
	 aHOuTh0J25VWnGQEv/nZ+OF9iIJVGFCjjw0udp5cNogE+zHl5vnF9qKxzINfg3Elp3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V6isCTU4D25hsjGB13w2zPnP4dJjegCVcylt7NWF4H4=;
	b=Vi0A1AS6oRHI77S1F/mIGkF1QfBi0ZyJRnz6yM5QbCXGR1jFkKFS4q+UMTUsKCARDiSj
	 tURCointI89pCtqzRq8v/AZ0icb8/QheQAPc+B0wMjpW8ObEhuEfeOuqxHQdsso0uh5s8
	 KekiMdf+oquPbJClwZuDIHaSlhfPPAJbpHusCt1fiwHufrztj4y9gnhODAxamAFtBl3w7
	 EUXG8zc6zNR/6tu4gUOwpKSsEv9XrWGdpQVNMZPHqyiPDI7HIrjB62bOEmd889hj0Q7ul
	 1KWrn1ih9wYHzhVdqurHHZN+whaRaEFnV0NMNbnBdP0Lr3p3b/cKFfLz5Ceb7ap97dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtlKKJdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A025606A325;
	Thu, 19 Nov 2026 02:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtlKKJdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E371F000C5;
	Thu, 19 Nov 2026 02:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056830;
	bh=V6isCTU4D25hsjGB13w2zPnP4dJjegCVcylt7NWF4H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtlKKJdy6MptT3URnQQzI6U/xh7RzbauNjwEKF6Qt3j48LfFlgIgIekZHRJqmwE8F
	 LMws02ZkV71VSWUOTJfIfF0Vj8IISv/gcdXSewzNbmUXbtLyF8ORJ/LUUdYvhwSHtN
	 zB8Em7inRNmyF5xrAQkAcHx3kGI/hoUeBHDBlwtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2086/2214] ASoC: wm8994: fix MCLK gating for AIF clocks sourced from MCLK2
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150134.081644984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 872215109fc880de7a03fa30437346f9212649e8 ]

aif_mclk_set() masks the AIFnCLK_SRC field of the AIFn clocking
register, but compares the result with unshifted field values. The
MCLK2 source (0x08) therefore never matches, so MCLK2 is never enabled
for an AIF clocked from it, and the AIF relies on other users of that
clock to keep it running.

On the Exynos4412 Trats2 board, AIF1 and SYSCLK run from MCLK2, the
32768Hz PMIC clock, while the codec is idle. That clock is shared with
the WLAN and Bluetooth chips, which enable it only once their drivers
are loaded. Until then the codec runs from a stopped clock: FLL1 fails
to lock when configured from that state, and the codec floods the
kernel log with FIFO error interrupts once a digital path is powered
up:

 wm8994-codec wm8994-codec: Timed out waiting for FLL lock
 wm8994-codec wm8994-codec: FIFO error

Booting with clk_ignore_unused, which keeps that clock running from
the bootloader, makes both issues disappear.

Fixing just the comparison is not enough. The AIF clock source can
be changed while the AIF clock is running, for example the Midas
machine driver switches AIF1 between MCLK2 and FLL1 while AIF1CLK is
kept enabled for jack detection. Looking up the clock again on disable
can then release a different MCLK than the one enabled, leaking the
enable count of one clock and underflowing the other.

Shift the field value before decoding it, and remember which MCLK has
been enabled for each AIF, so that the same clock is released on
disable. While at it, report the MCLK number 1-based in the error
message.

Fixes: 001b83d395ab ("ASoC: wm8994: Add support for MCLKn clock gating")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Link: https://patch.msgid.link/20261021101750.3297770-2-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 28 ++++++++++++++++++----------
 sound/soc/codecs/wm8994.h |  1 +
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3d966f46bcac1..0c121fc4b750d 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1062,13 +1062,24 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 	unsigned int offset, val, clk_idx;
 	int ret;
 
+	/*
+	 * The AIF clock source may be changed while the AIF clock is
+	 * running, so release the MCLK which has been enabled for it
+	 * instead of the one currently selected.
+	 */
+	if (!enable) {
+		clk_disable_unprepare(wm8994->aif_mclk[aif]);
+		wm8994->aif_mclk[aif] = NULL;
+		return 0;
+	}
+
 	if (aif)
 		offset = 4;
 	else
 		offset = 0;
 
 	val = snd_soc_component_read(component, WM8994_AIF1_CLOCKING_1 + offset);
-	val &= WM8994_AIF1CLK_SRC_MASK;
+	val = (val & WM8994_AIF1CLK_SRC_MASK) >> WM8994_AIF1CLK_SRC_SHIFT;
 
 	switch (val) {
 	case 0:
@@ -1081,16 +1092,13 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		return 0;
 	}
 
-	if (enable) {
-		ret = clk_prepare_enable(wm8994->mclk[clk_idx].clk);
-		if (ret < 0) {
-			dev_err(component->dev,	"Failed to enable MCLK%d\n",
-				clk_idx);
-			return ret;
-		}
-	} else {
-		clk_disable_unprepare(wm8994->mclk[clk_idx].clk);
+	ret = clk_prepare_enable(wm8994->mclk[clk_idx].clk);
+	if (ret < 0) {
+		dev_err(component->dev,	"Failed to enable MCLK%d\n",
+			clk_idx + 1);
+		return ret;
 	}
+	wm8994->aif_mclk[aif] = wm8994->mclk[clk_idx].clk;
 
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8994.h b/sound/soc/codecs/wm8994.h
index bc584b17bf283..28a54007302f9 100644
--- a/sound/soc/codecs/wm8994.h
+++ b/sound/soc/codecs/wm8994.h
@@ -81,6 +81,7 @@ struct wm8994_priv {
 	struct wm_hubs_data hubs;
 	struct wm8994 *wm8994;
 	struct clk_bulk_data mclk[WM8994_NUM_MCLK];
+	struct clk *aif_mclk[2];
 	int sysclk[2];
 	int sysclk_rate[2];
 	int mclk_rate[2];
-- 
2.53.0



