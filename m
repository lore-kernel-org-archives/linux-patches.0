Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624897;
	b=Cfnh0siF8M+Nj8RpRDvZKnfEoOupvdgpNMqD1Kks261tLB2bPJ40oBBWwNfpNsev6JfX
	 ho4eBjLcXMLp+wcUAA2XfeDghzGadjBmsF0mkl01PvBySkQD6UTBjPaT0BErxZtdgp3M/
	 bmTHehD/31qWT7yawgi6EmN4ZnWbWN1cOwjWbk/uVj/jZFlengTxze3u9Yl3UhR9TBgUw
	 2svpvDVhLkLazb4D2gK8iMCvfTgVuj7tO7ftsGsTT3hwxMzkLp8G/rZs07Oyl/Tnv8Ugd
	 mP1HwdujWTPbuuyYnJGbAWs160Ew8YBLLpxN/fWPdaUAxNibGL/uri07TK+SDvxk7Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIh4F6ZeBXTs1GB0T9zaRe0YulI+HlGWn0/HK6yHqt8=;
	b=JkyicGM/lZMg/DUHbO5tVOHtO1TSdWRlAtlvjR1wBztSzQGnengxDDMkDIv/qiXdqRY9
	 XzLXtN+pv+kSp2E0eI3aC3HQ3XcMKrEI0y9Qg4Y2AS02lN1GczbQHIxXZUBgeJbEhLHef
	 w+3+yUW1GuAYaMaaxSQb7pHDQpnvW0QebIbE6K/+2+7SQQ/0wF0FDnWOGn3Ydx4DxW8qp
	 p9H/5QOoaH2XYPs4cvlnea3MOouusYnJYBsBA3ger3mlJ4ciXl6DYXy+AdvL5+vmyN8dl
	 Tz1WSNaa2VvIbb3FDwHN4GSfwi+MA9n9IJ82GdpUdb4/yVb1v/86+VnitFfHu3h3+2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfal6hLQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6C606A31E;
	Wed, 25 Nov 2026 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfal6hLQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7D41F000C0;
	Wed, 25 Nov 2026 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624897;
	bh=WIh4F6ZeBXTs1GB0T9zaRe0YulI+HlGWn0/HK6yHqt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dfal6hLQopV79P2LF4ocl/IZMAfAXzzjuSOubHJwJzbFv9ZlI5EEsdVyl3hv7Krk/
	 F6MvhiqjeZpYGlfc4rUFKRhX7IxoW6vi/neJBzcKTM1PU8xmgYLSsjinI37+kCYeHB
	 iwt+U0obijOkYNpyhkfp14FYCcGN5rDX7isRvhEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/816] drm/bridge: sii902x: validate I2S data lane values
Date: Wed, 25 Nov 2026 15:31:29 +0100
Message-ID: <20261125143857.090454326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 7f91b0db161ed..eaa35134c4f2e 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -875,9 +875,15 @@ static int sii902x_audio_codec_init(struct sii902x *sii902x,
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



