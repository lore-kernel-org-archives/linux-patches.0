Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622174;
	b=IEroRyXQKgxgaVgQRgPAb4Tv9GNusIXOMu0aqKcnbfDbJWdocDWjmve6NDCOJHYZx3mk
	 tJt8b7JktnlahqYr7XwZeWOrt7JAVxJXzog0mGZtnPfcxGSSil9o4hflO19Pd5cfl7GOB
	 QGP5aldmGF87iRDv1cdNb7inPRYB7kAAPpEuzZrPN7csSlaQn5dTGfnguWaTv7N5zVeky
	 zqysZJiK+SICDD9+de9q0EtSzYg+D7JDGqAmaWBwWoDOuaXIMoSPgdm8cWroADbfYiVNY
	 lSCWV//PUidGMoM03Fbnk8rl/FK5WzNnJ2x+uD0sCZANZZhT5JIvERyUmFnYN4k6NBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZDETL57rG/wGScxR9myzZTcdysg6GB7Lx4FX7BieyT8=;
	b=ztF+NazlCaioT0K+G5+48fS+T5wVsMjAWaJyaO6Y31FumpMKh7FuJjjUJi6+BpBnF0fo
	 PZGrQF79K+81BaHR5KNff5GY2e0xSPzsps+qRHLkdBlOvtNt9ZA8TTuUFclJUmpHTf0t5
	 tVTHCanG7GCXqeynbzKLzamJtN6xVz8ajxasWlR5KD6538pbnmZsaok7WvysZfy+Y0+r6
	 rCp3bg6sCcHSUYZdHpR3KPKxsqEp7EepIVRXfj5DAOSfK8L6ddsWfhdwbPT+xdilEICbf
	 A5u3HEhZXiooSpb/qsXdSkhSKbMjoeOo3iF70m7iVXwwtye/fu3g0VGClzuQU3f6DMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4mNv2ox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61388606A335;
	Wed, 25 Nov 2026 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4mNv2ox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF901F000D2;
	Wed, 25 Nov 2026 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622173;
	bh=ZDETL57rG/wGScxR9myzZTcdysg6GB7Lx4FX7BieyT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4mNv2oxnyehFE8YxQbXneg1dtTut7NYm91f+m9W36es27TN5QsUHvYmpjxYdQY6b
	 6SeOSTRqvQXHrTL4SoBtyHOBSf3TOvHJge5zZPHgQCvsvmcQni0op7f9cXV5O35I6B
	 pCMmPdY47/g1ETnsgO0cxms6fgZFRODuchaNyl5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/990] drm/bridge: sii902x: validate I2S data lane values
Date: Wed, 25 Nov 2026 15:30:12 +0100
Message-ID: <20261125143832.516918500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 1f0aba28ad1e1..9c1566263ed95 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -891,9 +891,15 @@ static int sii902x_audio_codec_init(struct sii902x *sii902x,
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



