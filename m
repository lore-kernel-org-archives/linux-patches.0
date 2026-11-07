Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064168;
	b=0dVINiC2YfD5KnTLK+M4eA7taoEzyxMptGhfeCwYk3bV5sHDsO/TfI+1qpZvn54XEwWl
	 G4QuUCEtIirPtx1vGD20EEPmR2dstZjFyNXnUnoMMIqtV9xfaxoRQQ/TpFzOJ6/3WRFhp
	 gkaR+LljkH0JmOjy42Fuy1vknPTIkZgRQ+1fOslRnfl4bcQ+X6Ddz0h6D/sXd+yFf6JCh
	 VTJpuOhoHyD0WCGRuKwEr06t3RrwqsgEj4o1IjAk/f6csHelNn7L8YL9hXnrHvVbr65HD
	 5BuNScXsaYXxbkEtTq9ntXuCmSin/Bick8F60bRfZhLkH1RSFdh6Z/hrw+jYE8XmkuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgNJXc5U+g5c2Orp5PFcFB1yXfSZ5dGvU6OE3r6JkTc=;
	b=YmP3o3Y05VlBXERwayrDAVqTfiNTOToXheO0Lh8cp82EKkH8kXw9lqaUDu6lgfdsgcUM
	 Tpp/0Zz7kCtxRc7n7kHpzycqak8GDrbjTHclgdSeoRFv7dgU5w6BOLuhdPZLiM82FoNNu
	 c2m3qCcODXr9Im/N3AyNh5EpNfS5HsT3euXf6pKd0ahdeJzhq3vgOrST0CZxY/3+g/Fcm
	 Yb+ic0mKpZIgS54xPAs49XmO1XA+iiU2f6ScJo90MsjQ4Op0K4CQxNPSczXxXYMwpZImP
	 9fxT5ZpL7xoKAR0VcNQA9D03Ti/WL5oye2PNmo5GpyiVdMuyIiJhOyHNGitCG7Oiepw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr+oIo3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D54606A32E;
	Sat,  7 Nov 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr+oIo3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6821F0089F;
	Sat,  7 Nov 2026 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064168;
	bh=ZgNJXc5U+g5c2Orp5PFcFB1yXfSZ5dGvU6OE3r6JkTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr+oIo3UQEgByakyX1RrlYqJIfDPM6lw1cNPnfDENjIN4S8mS9VhsbtclWhGXJR4e
	 PGAFNWD1XhGqyTCBHRy3n1zsQXDZaF13y+lXi3weus94Mo+0y8dXmRQQa0zn5G0rG4
	 wyZNXJUrsQV0vKcFpqONdrQJRJbQG42pvq0bkzEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0314/1257] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:43:30 -0500
Message-ID: <20261107134948.109588825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit f0cc352be29ba616e0682f66f551d3f3029886fd ]

wcd9335_slim_status() obtains the SLIM interface device with
of_slim_get_device(), which uses device_find_child() internally and
returns the device with a reference held.  As the device_find_child()
documentation says: you will need to drop the reference with
put_device() after use. The reference is stored in wcd->slim_ifc_dev
and never dropped, so the SLIM interface device cannot be released.
Fix it by using devm_add_action_or_reset() or put_device() respectively.

Found by code review.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20260914095009.12049-1-make_ruc2021@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 40de279a9750a..9332082092c79 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5096,6 +5096,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 	return 0;
 }
 
+static void wcd9335_put_device_action(void *data)
+{
+	struct device *dev = data;
+
+	put_device(dev);
+}
+
 static int wcd9335_slim_status(struct slim_device *sdev,
 			       enum slim_device_status status)
 {
@@ -5120,6 +5127,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 		return -EINVAL;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd9335_put_device_action,
+			&wcd->slim_ifc_dev->dev);
+	if (ret)
+		return ret;
+
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-- 
2.53.0



