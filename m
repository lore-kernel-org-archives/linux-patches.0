Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619176;
	b=ieMWw3z7AqpUGv5ep9AAGf6uYtBrQtKquNvKt+u4cP89Il3fkiBXKlFYO7KXwOquqDp/
	 WhLDd89ctioU6u/hoS4OoCszixKPnrJLxkBp5+HC28KpWnnGfNOw9/vIgdAJJkktoDLkx
	 USl7dI9pl1yYl2j1RR/YZJ10EkMYkS6khrlXOqnKBEfJt+60/7FgdhDDg5zjOTU/mRf9A
	 6nYjCLSoz5PpWZNBXXQPGzmCRbIufe7E0uJ7s2Lr3kTsuYO3M1tJ5lEOjV35zYadRvMHB
	 z1Q/1DMwhjthPa2P2FsMeX2cjavnepnKwyIwHQDhZO4L8CAFwVKp+agmS4IDwk7bzdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBKouBl20rdMcPasZ5hHrLBC6siOhHXwwekeGwKfQ+c=;
	b=kHaNbpQA6ieKvqg6VNLh1OFZIBrGmp4bQiHteiGvtZRDKSjxU0CtME3ZydZTqmfjadVp
	 hwPY7tP0ElfDovWITItwDqZz+rpvke9ePbOECLQ6zr3rMzqLVl9ILausTsiePFJcYkqIv
	 ABIyLQ9gsadsJX2aKot8M7LA9KCGpFTBz/wVsiI/iIf10SP8ukNXG4esgtuIA0P8ia40Z
	 NO8IuxOcmalP0t46jY53pOaKfI6EWFmncJE1w2NfWPjdPg0eVutukKDhQcCIzjDtdWnel
	 RFjJcwhrroopKBpM3W9duWJFItv/V5SN/4XPIBemAFO3dfwWY5zMUygATmQRjYnWBwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPv8Axcs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A03606A329;
	Wed, 25 Nov 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPv8Axcs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826941F000C0;
	Wed, 25 Nov 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619176;
	bh=dBKouBl20rdMcPasZ5hHrLBC6siOhHXwwekeGwKfQ+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPv8AxcsW6YUY22SHqyCmYVBUh1JNfbgLiMRBd4F/OL0duHy2k3x28NafOLYG0B6E
	 e/o/nfyU1rKvs/YCk1NtOSvzrU+8Da5oYxydMz0C3l4Y4fCZahJzz3DQPE3izahqE5
	 8xE+y0Py8LiZAhMEPGNSgaAMjTeLgbqRlp/NVFi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0515/1005] drm/bridge: sii902x: validate I2S data lane values
Date: Wed, 25 Nov 2026 15:30:53 +0100
Message-ID: <20261125143833.810459939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 444b7116e7ef1fdb5f7db3bc1f74b20098d062d4 ]

The sil,i2s-data-lanes property reader bounds the number of entries, but
does not bound each entry's value. Those values index the four-entry
i2s_lane_id table when the audio FIFO sequence is built.

Reject unsupported lane values before indexing that table. Report the
property name and invalid value with dev_err_probe() so the diagnostic
identifies the faulty configuration.

The issue was found by our static-analysis tool.

Fixes: ff5781634c41 ("drm/bridge: sii902x: Implement HDMI audio support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260920034833.18874-1-hppiscas@163.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index 9aac44ed5b677..48058029fdfcd 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -890,9 +890,15 @@ static int sii902x_audio_codec_init(struct sii902x *sii902x,
 	}
 	codec_data.max_i2s_channels = 2 * num_lanes;
 
-	for (i = 0; i < num_lanes; i++)
+	for (i = 0; i < num_lanes; i++) {
+		if (lanes[i] >= ARRAY_SIZE(i2s_lane_id))
+			return dev_err_probe(dev, -EINVAL,
+					     "invalid sil,i2s-data-lanes value %u\n",
+					     lanes[i]);
+
 		sii902x->audio.i2s_fifo_sequence[i] |= audio_fifo_id[i] |
 			i2s_lane_id[lanes[i]] |	SII902X_TPI_I2S_FIFO_ENABLE;
+	}
 
 	sii902x->audio.mclk = devm_clk_get_optional(dev, "mclk");
 	if (IS_ERR(sii902x->audio.mclk)) {
-- 
2.53.0



