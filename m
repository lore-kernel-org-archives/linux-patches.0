Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020550;
	b=g//QoTorf8A94Jhwg2bsA4gEeshGCIdZ87PH7lQ7N/NAyFq+9EBHjOaywXxI9M9hLaPE
	 AXhYB6XMQh+ZPAHUPomGIJbuaghC0x/yp6W0hF68za7ydfD6z9Z/CBLtqWTE6WprE46sY
	 n5YYlsqGw2JRJorfuRvVPPtsN6qUi2udmM99WrZrfHjdACQFDxuEY0InnAe/Vqhs4Ah64
	 cIRh60pymsHzagAnVCG3C0e3X3p6ziqeixSBjGB42KxGFmvSqRfbt3eCx9ldzm4cI/0oz
	 4uwqR4al4vAAQxVEoJjREuZWHhXqUQCgMTeBTCJ52gi8rpIoDLuX6oAm+JTkUFJGrPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kj+e5yihy3PNQRksY8B8BtFpMBR4ZzhRqMZeyIc/RTQ=;
	b=17ZqebOMtQ3AGgIgXWB7aMI9vqDBnHSXDYMZ3PRCvM/f4KEuObDQfJ2+4gD7wRa5Inh4
	 8T2D+EaLF6SNb415Ra70/vge2Yv8tLNxd3zvJyvV6SH5isTXeXr/B2NIxQQOnrb4S1kNt
	 SrBDJiJYBcGzJmG1ByZrP3rYerTTLRzE/lawcVZi9abwlenoyyPEDEovHNlmu2ulzSSQL
	 s6mlwC2aEVACfX/eiEEbrwiX9AVH3D2pcNKhiTR4bhg1ZPieDgozL6H4KxePFP2rpowM0
	 U48/FtqKaeMKbziqOpUpybpVPmLV03cbErPwSumJkHmxzZ6hOC3N4CxErg5nSxEI9iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbhT0LHM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDD3606A31C;
	Wed, 18 Nov 2026 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbhT0LHM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471051F000C4;
	Wed, 18 Nov 2026 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020549;
	bh=kj+e5yihy3PNQRksY8B8BtFpMBR4ZzhRqMZeyIc/RTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbhT0LHMPuZD1gJznmrPlfk0Ok/SjMWlrtTzBpBNcFlQG5kLLtIiSriHrVTZt9T2N
	 K+jqVop+BuiMD2Qkv3+y05Ms2d+08yAan5OrxHWiEjWhPgXKnS4QcolM78/gUwOpPT
	 DZ/7/6jg0I0fVu/b2AB+GlLZ+pJrr/ngJsx4lqYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1991/2651] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150358.031526270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5f81e3606655b..5c573c8dc249b 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -241,10 +241,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
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



