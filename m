Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032122;
	b=Yv6U9XuYttAmXxCbI6lLode/MXb4z/Psx48UDstXo24WLqTu0G35SRut9lz4H6OTtQRv
	 ZNrYFHyMAgb/6cwjUWOXGzuqOnoWB6P1DlgmfehEZFQdZcSPIxwawOE+k4TBktCbVE+Us
	 RAiA9z1OxpCq/T9iT8smlD3DUy7pSQ7BmSK+33ZKNkATY5zLrdad3214knl3upsp0HYnd
	 Rv5Fy4uclMOj9TmGvYgyWyxtRAsIPcQRYGJXQk5XiDeQlt2RNJNYNw40fzAgGKfmWc8T2
	 Z71veu8xVLiPaErRa+G1az7ZM7heDqBr1n04mvMbLbPZ7iqCcV2dcCa8z+VHqi2RlbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zCh9NsRAvBA0Z+JllMMKwUF3JsKdHrLPX3adSgo4BPo=;
	b=OzaZEscSORm5TNv8MegFqS4mwpDlWO/1Ues1JR/eI1I6b3rsUvGltUQkJAxWIRL4e+qu
	 ap+B9JvAenzDvHHKVtfGdUJW0J2yd0cig/gpOEt/vaOjlMCLJxi78hrLqREQaMTR40+e7
	 TKnizICNcW7Y0bibJNiXFrS5pGoFy+8xgzRPFff0T1+ndjUAK86zAplmVvRqF8B9U/CVm
	 mHCkQVJB3G5DwO1X4eAfRNs+vqGohdc5fSsd7L7oxw5NbJpCzMQ4xfI7vZWz8qHPARpk+
	 +izbCrloYB2QxZK9Qj3tN7vLEO0tO2Z3N65vFyKQ2LRirCm2hLGzcNQSc/zSKcEyPOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZXQPA6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F7606A31C;
	Wed, 18 Nov 2026 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZXQPA6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4816D1F000C4;
	Wed, 18 Nov 2026 20:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032121;
	bh=zCh9NsRAvBA0Z+JllMMKwUF3JsKdHrLPX3adSgo4BPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZXQPA6+G1VN8yT8WV7/nyxXT7mitaYPtIO187GQ2G95hraQekm5dcY/xdwb7NPtx
	 ZaEjzBzS2c7rYT5k7DI8q9k8vOngFphNCKMOqONOEjoq4KHUCh2WXX0WdMSYXXUPVL
	 s3BUDdqfXbanNL/JY4qdBDvyWPNSdHMtHZ7Enl5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1300/1756] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 15:57:07 +0100
Message-ID: <20261118150101.267463833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit fc081cdfc6b370f6b6853cdeb4313f92561770d1 ]

If call to snd_soc_ac97_init_gpio() fails, proper removal procedure
should mirror snd_soc_free_ac97_component() behaviour and call
device_del() before put_device().

Fixes: 9bf5c3d11f1f ("ASoC: ac97: add gpio chip")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-6-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ac97.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ac97.c b/sound/soc/soc-ac97.c
index 079e4ff5a14e9..f86782b44b1b9 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -234,10 +234,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
 	ret = snd_soc_ac97_init_gpio(ac97, component);
 	if (ret)
-		goto err_put_device;
+		goto err_del_device;
 
 	return ac97;
 
+err_del_device:
+	device_del(&ac97->dev);
 err_put_device:
 	put_device(&ac97->dev);
 	return ERR_PTR(ret);
-- 
2.53.0



