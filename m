Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022436;
	b=DwzRVmM1Juk3pfqmlKG8+PgXlsjJvKSOl8RCdSPWBXsR+JFjEKUZIgDsXoLGhBwb9pzV
	 ayYzueokLrsrl/f3oeMLV5/gNqlCvM73rYmpnREB1bw+dvftZn5+0/Goha5QrpSeBWsMA
	 95dy0Cm6Yg5byC+LGGQUa6UUzxf0OVY4xMzOwnGBv7ZvK+25Pg4K96CFRrWFvLtDxMKux
	 ORSzq180Z46FQu6UjDDDU/P1Lu9FFFZRtamzNLWbfC8E/9d5r92Ae7hiUP7ena+ekC1Xv
	 4MODpfFCP9VIESF509x/3XYFOJPl4U8M7ouAeEA0fKbuJhWJS1v1D7bAdonzGH9CCBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sunzh/+mB1xuCqI463xnIyvOz2vgDDK0AH1piXJb/t0=;
	b=sI0Qy5Dg2RtS/+YHEihcYaO9up/4NQMhEU7Tpibz8WXj2l8U/TMMHE9TrT/+VvXT3CW+
	 hPHe5NJf5ji7qvOU59W4l2aSXj+oAGlKcD7RM9jf81MDzOREO01MNpBms/V72iPwLZDSC
	 CmhFhtl+tvTAh4YN4h2+LjKmNSxmRWQWlWjPYppTg5Z6Ns88n1T++HkMtX6q3jSPHsk7R
	 FcaNDnneegHvTVbyk/VtIFVhY0pRXpc2OSkeo1i2NR9S9qkY9RbMQ5ZNRTlnhN7MCETst
	 3a1WuPWb/cFif+FISbxBoehwxSz2c5hhIcAVZwKWo2I0ewuJ1C6EsdTud/breBOcINA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWxtmPya;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88666606A32A;
	Wed, 18 Nov 2026 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWxtmPya
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF06B1F000C5;
	Wed, 18 Nov 2026 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022436;
	bh=sunzh/+mB1xuCqI463xnIyvOz2vgDDK0AH1piXJb/t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWxtmPyaoo2ERMySn9/gveic4xosTOnMFnTw2FXsAm5RpNSV2iGTMokAd95XeXOHV
	 GD9fcy9csA1TWQ814ZX0PSicbZOsgEyBGWxI/HIUzgDxDCA72Z1j7rZYvbNsxfOuIi
	 vtL6wzL7c7M26uN7vuufXCDax0OffI3Rb2JHyfU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0013/2151] ASoC: SOF: Intel: hda-sdw-bpt: Stop active DMA before closing BPT streams
Date: Wed, 18 Nov 2026 15:29:08 +0100
Message-ID: <20261118150122.124669889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 348bc756d912dd8f47fd36c167075717951a515e ]

When sdw_enable_stream() fails in intel_ace2x_bpt_send_async() after
hda_sdw_bpt_send_async() has already started the TX and RX DMA streams,
intel_ace2x_bpt_close_stream() invokes hda_sdw_bpt_close() directly
without calling hda_sdw_bpt_wait().  As a result,
hda_sdw_bpt_dma_deprepare() tears down the DMA buffers and BDL while
the DMA hardware is still running.

Disable any running TX or RX BPT DMA stream at the start of
hda_sdw_bpt_close() before unmapping channels and depreparing DMA
resources.

Fixes: 4c1ce9f37d8a ("soundwire: intel_ace2x: add BPT send_async/wait callbacks")
Closes: https://sashiko.dev/#/bug/linux-ff0012de-abdd-4796-875e-b1fbbf47235f
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261030104840.3361217-6-lee@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-sdw-bpt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/sof/intel/hda-sdw-bpt.c b/sound/soc/sof/intel/hda-sdw-bpt.c
index 4e5c99413c750..5eaa2e0563c16 100644
--- a/sound/soc/sof/intel/hda-sdw-bpt.c
+++ b/sound/soc/sof/intel/hda-sdw-bpt.c
@@ -431,6 +431,12 @@ int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *b
 	int ret;
 	int ret1;
 
+	if (bpt_rx_stream && hdac_stream(bpt_rx_stream)->running)
+		hda_sdw_bpt_dma_disable(dev, bpt_rx_stream);
+
+	if (bpt_tx_stream && hdac_stream(bpt_tx_stream)->running)
+		hda_sdw_bpt_dma_disable(dev, bpt_tx_stream);
+
 	/*
 	 * In the case of SoundWire we need to reset the PCMSyCM registers.
 	 * Need to continue depreparing the DMA buffers even if this fails.
-- 
2.53.0



