Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050453;
	b=pJAHhiwwZZ9YjfsVt6UZI0oChSedmL84IQWUhPT+TwF38tyC9X467qX6IoonDI4dWRI7
	 ZSUtsD/FPeOezHBNnzVy5AOX1ammwQL7AhvUHKO6S8Rqvcsg5fft+s3kXYdm9ZZmNKiU+
	 gJhzxTeEIIRtAdSH5AFNgZRT+ct/uKHH5CBQFNzKDmPEgf43kUvVTd79XAqBt1jZDhsvJ
	 LyvxqXa2Ev5xuGExcwrkFEDQXRu/DwlNpq5Q79xgeK5C1Nr1XblOmC9Ev8s3Pa3MXZv6m
	 nd8GiaoHPmuKvjnQZcjZ7StS0EzYz4dgcP18qEdEQPtd+xzK482O/94UtJw4gHQFUMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8PYUoZ9UXIn+dR5etR97zpMe1TOY2RXpbTZW1phfrY=;
	b=TgY9nhd0/7PTEdai6VDSh77SFBngqmpEP+kbd6FSuulM0lwMUwp0mkby3TxxegI2pfVY
	 jaDHz8YSX5IgaQ/3GyXIKwGJFUk1iIASNkt4iC0CMDVAvleRWnlPv8FNXAh+xm0YAoaWR
	 +tCjOmLzJv43kGgiEQqin0BX0VJaBJdpqw4bX3ugEMsnErqBBboEOeMU2kaYUlpCw7lro
	 Hf2LH2NtF3DVHzz57kLWWZP+8/EMeRZkghLlX4pDZh/6pKF6nuDrXCCDPAJT8n7heUXxa
	 PKYIPK/DLREDLUeX04Wc2bHKLduJ2qPGlzbPvLYMkRJMOBgllaX2XxUmLAYi6zQK1sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNFNsxSi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F37606A31C;
	Thu, 19 Nov 2026 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNFNsxSi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30411F000C4;
	Thu, 19 Nov 2026 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050453;
	bh=F8PYUoZ9UXIn+dR5etR97zpMe1TOY2RXpbTZW1phfrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNFNsxSi7CLaDwbc7b+74I/7m1hLfGI0myxZuuphzU7fDw178sxw+i9WvsR3gdlsh
	 wIa1+8wN3HgfABZgU2tHqio3XAsFvcWp2gE8PSfyn/tBVeoHJa5ayIRGrhiq/dR1Zb
	 JxPxS/aB9Ycv44/fjb7k4IY+YU+sYAEWnmRnCtPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2673/2857] ASoC: wm8994: fix MCLK gating for AIF clocks sourced from MCLK2
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150337.820911118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3012b25e26d55..9399293155ac4 100644
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



