Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705307;
	b=s/p1DeUozssIJYytslVFvVXbVle9DC+8MmuirEW7eDCdBBIIai7Q9ajBOCifuxSzEcet
	 O7ms3JGdWVH+6wRb6ULUAR4CdhMzysVeNsyOSQXgAmaQNLzRSkk9Vlmj9cM8ks2K+fmZv
	 Ehx/rUlBAxf70TW8PN+7/zZbvY7+rDkk0ewzavT8EEec3MhzQaqymciSUR4KAC+xkldlT
	 c4wEoRNelk42YUq5MQ1AGfWtJI4AKfJTECx3arOI/scaA/eF2N6X8LcDq0zxHOgaZ02q0
	 FvIcfH+N52vEQpHwYvDeZoU2dnZuNhQhka2MQfS8/GKw7/n6CzKcvFEhVK4JCBGovwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r7Qv2tNGDLrQAZ5RmZqEuVd/+32jRjCXlAUGUGN9gcU=;
	b=fVdb88wvzZHl7+9aKp14NtCVtPKXE8fyZ6fPQJrSGAp4mEu5vpZ0y/mtCUfc7VUojw+l
	 ykyfVI7cf9h6/ExdpxoH8e90rikFMT+v0RfuSdr7IT5GYYlspBcHw7n+0nGoFvI6NvBTY
	 l0a+RUW0E1CKetONKp13/CcaOfK+RFoQLOzq7Tm4LQvjj/q8YsrRch8KYPfw4eqtwKPcn
	 YzK2wk4fpqpnYpz7eZBj+SWPPtZdFbflu3U4rJhdVUARJhp3nKoxag/skKSqZGBKhGKz/
	 KvzSbPIZO9sZcKtlRvrGjq62ErWPgFPZdVLxDMESnERVdz/UtPfj6oIOGRmZwFuyYpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO0wHGO4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A2A606A329;
	Thu, 26 Nov 2026 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO0wHGO4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842061F000CF;
	Thu, 26 Nov 2026 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705307;
	bh=r7Qv2tNGDLrQAZ5RmZqEuVd/+32jRjCXlAUGUGN9gcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yO0wHGO4+cFoyyDLwi85jR63l8Cs+E5tYVnzGW2cVJhf5aVEau46UjlhPtFhRgLZ1
	 A+wOFoc4XtpY6oPgqIFKiK/Mu2oa88vjzI46pyfS6EQ0sj3LpHSWeP7k5HV9TwHBW9
	 54g8i9uH1FiH3k7QJKnTigWiHu4nO0ufFjtIvUnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/319] drm/bridge: sii902x: validate I2S data lane values
Date: Thu, 26 Nov 2026 15:38:41 +0100
Message-ID: <20261126144010.198279559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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



