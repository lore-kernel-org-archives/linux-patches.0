Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026985;
	b=4Ih7KcmgVE+xfEXE9TvSDQf1vf5Te88aQLvqfjhH8TRxfuErinzaMpjNIXYTHm9K4Epu
	 eo2kq2nM2Y+yOlHU7QL3JilNfg0/B19YEiDAKdjr5Ugyv/Dx41rKH/cZs2YKdReAbNA1T
	 w+RQP6ltpeTgluFYnP/RYASPhJ+6WG3oAuIrE1al4QofwZFfSmK9BzDq3+qRbYarT58ti
	 X6zkHFTbtwYUdARPAdH+VjZbimVSvDNpP/A1IKV+svF8HLW5WA1jEYNs+AlTCx/kzLPjS
	 YozHpwU0ETUrdXG858GDOGnqEictP9pN+3a3eYMGxcCxjrKw+Qzk5EmUexSIRO82/4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iDWv1ZQWU6Z7egaeQFXPgqUNG0TJTEKcusTqOS/8Qhs=;
	b=y1/AgWSD94n4iGmVXBRP8tLIaEjvM6FGkfdUWI27HtO5dZwJALfcczne2CtbPsVlJJyb
	 /9baZ70j7Acko/ulzr7Rc3rQYsDoknPt0OBJP4vn+0DjIHymXhvBVBGEw3N1m2bgiIN92
	 m+0GLD+XJfatTMteJ83hK4I0z0hc6wbBwVN3osWWfxR0tZpCh22JGAk9PvE5NXG3cz63F
	 uPf6LotZr9Ij0niNAIF7m7PZY7JyiZGqbBvCQVyKVrDzvHb9iYcHj9kPhPEd8Fyq//Afh
	 6ieEQwWibU8Fi61AsQc8Fg6KJ4tV7mBEybPvPIppNTi14b98EXk+qr4DZ29wAMa7OWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PI9aKWed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9D3606A325;
	Wed, 18 Nov 2026 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PI9aKWed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EEA1F000C5;
	Wed, 18 Nov 2026 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026985;
	bh=iDWv1ZQWU6Z7egaeQFXPgqUNG0TJTEKcusTqOS/8Qhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PI9aKWedgvbsjjbiXKrMTqsyW55mvKG44rWUWBwJaD8V3YvFWcjG9tuII7JSxwA0D
	 j9lMylj757eWy1osGeI9yUclNScIe17eqnCqfIdjzZh+VejXwkUfqaxE6DrzccdhuX
	 CPIdB6QRpMBNsYfzhFShEv35MIDHUBkd6cqmpIUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1628/2151] ASoC: soc-card-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:56:03 +0100
Message-ID: <20261118150221.176987918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 77dfd98b1642b9bc6c2312bd8b805c321fb878b0 ]

Call to kunit_device_register() can fail. Check return result of
register call. While at it introduce helper variable so that if it fails
put_device is called on properly initialized variable.

Fixes: ef7784e41db7 ("ASoC: soc-card: Add KUnit test case for snd_soc_card_get_kcontrol")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-5-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-card-test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-card-test.c b/sound/soc/soc-card-test.c
index 47dfd8b1babc2..610b8220786d1 100644
--- a/sound/soc/soc-card-test.c
+++ b/sound/soc/soc-card-test.c
@@ -70,6 +70,7 @@ static void test_snd_soc_card_get_kcontrol(struct kunit *test)
 static int soc_card_test_case_init(struct kunit *test)
 {
 	struct soc_card_test_priv *priv;
+	struct device *dev;
 	int ret;
 
 	priv = kunit_kzalloc(test, sizeof(*priv), GFP_KERNEL);
@@ -82,8 +83,10 @@ static int soc_card_test_case_init(struct kunit *test)
 	if (!priv->card)
 		return -ENOMEM;
 
-	priv->card_dev = kunit_device_register(test, "sound-soc-card-test");
-	priv->card_dev = get_device(priv->card_dev);
+	dev = kunit_device_register(test, "sound-soc-card-test");
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	priv->card_dev = get_device(dev);
 	if (!priv->card_dev)
 		return -ENODEV;
 
-- 
2.53.0



