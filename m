Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050088;
	b=4Yo1fSXpf3xP3nayJRUUe8JzTX4dbENQhWHlXZBRlzlH7ymEHWpja2EYPRLUDVlqZd3k
	 vla4hPMLtd+5IDUqs+/eizcdzoYnk402brqkWehzNdaXPNMLCC0nqX++JAZ9eZfD2AG2J
	 r8ElOf/K85e0AzZz/EEN7B89ho4PNdb02v4wRYcLNy/eJ3mj2e72FSkG06EbqQ4BPQC3I
	 KM2csyawZ6Q4pAwFRv2WgtaVDZngtJU8n2w5tefH0RDV1QT9WgQHESi1eTY6y5pgHTWc0
	 PMvQL1NffgqjliOh7FrKmVeaH/l8dNklL3QhmzxRVU4vp1UTAYe8ErZJgfyrp+3xF8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WLZlWLatItVbFtJYheKIr7GVwLeSXAkDMvuYmPfsZ6E=;
	b=rkvA0JGKhVUDMMGPU4UE/iYubz1kQvS4UZWq+QaUAM1GcXepd97a1zJqd0h70xFjbyPI
	 FL260619wjMzs+uvujljTIil9B1UYgT48qu2hvPvsXsPiKOV8CYObgHsU8+T7hvN1R3xt
	 RK+bXM8DAl9zejlb7zxDOLNW9Ag9YUDjEJIPA7jYeJnnLW6JcGoiXrG0hM/K/PUnQMlN9
	 JSGNF8Cvic5k/xsLdesu9mbR7ENFOep0nF+SYQDK+nMJTKqjuD+hErqj5emthrUWFAT4c
	 fdMo/GZ4/53zpttREAdwgxBDKcYJkgpnUreic06XwKgRVjagyEopG3o0Jlamp+jyWlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRU76Sy2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E0A606A334;
	Thu, 19 Nov 2026 01:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRU76Sy2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027F61F000C4;
	Thu, 19 Nov 2026 01:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050088;
	bh=WLZlWLatItVbFtJYheKIr7GVwLeSXAkDMvuYmPfsZ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRU76Sy2x1ITa67K2O0lnXe+PQ37OTGm1Vj4TEKaM4YRJSceziWOj7nnrDX2ZR38o
	 t33nW9KHf9SuXphi60l2tpiySOXceQ3OS3mHqJgjfb4z2yZnMnJ3dfzeQl8i9sIMT5
	 Mhj4pvtrEjlF3/TiKkUA8/ijaQps9F1O1I0kf24g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2543/2857] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150333.080840917@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32c5be61e2ec8..856a140dc5315 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -235,10 +235,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
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



