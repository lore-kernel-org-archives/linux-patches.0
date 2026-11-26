Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704448;
	b=hFVUd938uht5B9tYqkE7TLkBv5oPICpCfWMeYff+MKF6+NRI4xy34noQgzLWVUsDRZqE
	 jd9gUk4P1vbFWuu3iHt+3xLLF48SZXV7wzIKlXOxxjPVeMTPbto4/y4bcPUH/r/78E5av
	 onHokahvz3wmd/4tI3JWVQb4SwE/ur9jIloiZCE5brVGm/gt5f+lKX/akM03ODl6EyZh9
	 Ueo0RAJgSNhU1jdszJXW8FolWz+BkIobD2mfS9+MIgornFrkBKMjgxjJukmVaJgJ29Hpu
	 34Og7StShOSgxNDOaExJEN2682tjyEN7/Dq9xEpr84LAI0hwuKJ0DGZqHJbCCmPwh0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mb2GLWUMgHujQZSEDYwYZ56sSdrAO8tO29ZRSgM5auE=;
	b=oBJOH6cCJeuWPPcEEYZf5E8SBmrtBSQ3Uvq7xruTWc+w7XAKb69oRl8cuko8q/DAYVeO
	 VEHrXZZNoxwCQNlAHnxHFRjNL6Fel2muLUFe5orS0tuzJgva83r5pVE316SzuiGSjnzoH
	 rD5wVaNVu17gRQHnIJTxnIKIzUkNMMzqMUR3VVBlmE+/rI4izteg84CxNJLapwjkZZUwJ
	 oTtp+YOKBS4aRLKUWBS9N7R1TY77F2cE1wA76M7cOu72RLSNV108KzDLKVOBfT1st0D0g
	 hFm/MyyvP3IHhIjkp2z6yKIfTcNH6ISzxwJgfvKhz//1v97qy78wHhzChYb+q+xvwYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgbG57QO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43A8606A323;
	Thu, 26 Nov 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgbG57QO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BF41F000C4;
	Thu, 26 Nov 2026 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704448;
	bh=Mb2GLWUMgHujQZSEDYwYZ56sSdrAO8tO29ZRSgM5auE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgbG57QOGDfHrSksvekXDo1h33aIkJLLxUgEGWf5a88El4LFwbl38YsdiIRq/m9S2
	 8n75xFoEZ+rvY1zhSKpuFV7gzYIVfsLO3P+NYaC/9TOX7/rmYIb66/IgPbw8CbNchZ
	 rp0w2PaqKsaYAhGNO8j2Regwmx23v6pwW6/LudMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/265] drm/bridge: sii902x: validate I2S data lane values
Date: Thu, 26 Nov 2026 15:37:38 +0100
Message-ID: <20261126143613.982341350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 89558e5815303..91c627ff6d6e2 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -781,9 +781,15 @@ static int sii902x_audio_codec_init(struct sii902x *sii902x,
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



