Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061780;
	b=Vw12oAnCHv6MuzaXcqK5Vtka/xjmBqmk1ehGBUaJNEXcKqt4hnC0n5A0j+PQtbfcS7c4
	 PMVC1MsGXjT9hRw+6cEfpzR3AWhvGhPlmziDn/yMB+FUa+tKM4mYihx4e+Rcj7TyA+lNV
	 LJwUnXeU2fLs73KwU6y5Q85qowkPeMwn//gBOSuPOb5HvEuVyBpjszjrDAOU93QoRg5vL
	 Qp6Kzl68ebodFpW1hZqAfk3HC5VxgRWVsiQwpKfa8w4zYqcND47bXe0/GUmY7vvTosiIP
	 TR4PoHQ6Xni8hT8s6ZmX2fuCQGjEt0Dtba/tUw2ICfVbRrVRQRCsQpnI/y6XI+Iisbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=b3yDAQuzuo6bqMPKrwUD7VXuUsfjIZP/lDVvzvf9Fe8=;
	b=Rw+CsrIMdmkl2FX8UkP8vBaENgUhagypytWzQopHLcZij2fpwXtkK4ddCipitESQ9QGw
	 y6li15+W4wv/L/AH/+h8a1zsKkuE2+fMzYgrWh+2WMCICAHysJnZ8ZrUVfElawEah+pnq
	 GmwkcHcY0Pq7RMXc+e4a0LStGSSvaNfz5Wdbv/XDf8+UBVSnY15e2SIDZUcDVUxFzsYv1
	 GQGSRdzYIwt0WLJI42gll9fohYyVD/u5EsqX6UsMT7cQSL9n0lh6zPK2URlUDoBfVbLmS
	 c4/YWGov+0mzZkEmS1b5hSQvuRsbarc0ln9KcGLy1evJSKxdidr75GNnrvhK67G3CKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yiwsn3sY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E21606A326;
	Thu, 19 Nov 2026 04:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yiwsn3sY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EEE1F000C4;
	Thu, 19 Nov 2026 04:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061780;
	bh=b3yDAQuzuo6bqMPKrwUD7VXuUsfjIZP/lDVvzvf9Fe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yiwsn3sYibCCWEJjlLIdRidXGF5W7xUUC1elDvH/JrsXB7aINspfYzi+0Me2/FM45
	 TZBihu+lbg1c0KhuEdJDoRhHR1s+4Dt6UbUb80ImsvDL3ll0O1NF0gu6Dp3vNWwGaw
	 KOQY5JRI+NlUDfZeRBvKanHgaGfiQTj3IOzzDyQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1674/1848] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150029.899737616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65db083e242b3..073555b5294b2 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -237,10 +237,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
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



