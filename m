Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020547;
	b=Xo1a0INvyAk3RzYhNakmTjYgotpPuSNU/xsJ/zOJNm4HL+QUf7K6K0BJ/zpGJa/8htcV
	 5vVVnDIPDMWbby1z+rq/bSPsPUl9um3NYeThOgwB9P+iUcaAS4pQiJhloB6Xecp2VwZvk
	 iy+Wd/PI2h59HHS1+AHN/ktCki9Pu2ORCa/4Ia7DIQrkYtWetPZ2N12IokMege+1XN7K3
	 OZmAEe+qoZDS+KNCE1VR6c94oWJcmiFgAuuzKCCNR9moeMqqBAkBL7dWTHzKrpZKa9lmc
	 x3QcdsYoc9BQGU+HndE+OqoMc1vRUAkWiSZxJ64vlOptvxPNSTEST7IK6Ut96rXIFMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ByvTR0v8KsLN0dfXXc1nRTzeUvz1XJlnbxVwFi5gwU4=;
	b=rwYF92YoBvWXnupRwvl/LltDqWZAEosqRBnG88hoFJDPZKQdr1nMrIWoJhIiNW98KES9
	 bTD5DYLVa+/xl3M849ae52JoPXy63K6RWEDn33o7WoHbEdcyddm4cK6n+RWhvufuUbb6i
	 PwSMA9jyNwkHR4BX7+kj+J9gnQH893/QXUKw4QwV5GJjRjOa9lafHHQ7CFl+d1CvqZQeO
	 phvHdQl1W9dl9HDD9IZs71WnGLbufoKz9GHA/yYaQT81EVnsHxq8lCsn4GPEC27E9FuaK
	 LJ5skZFITmtVyRUpbwZ37cNzOD/5wZI6wAkQTgdOZMUwPXuzvPcsixC579ewkniwHHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09HoISC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27953606A320;
	Wed, 18 Nov 2026 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09HoISC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6221F000C4;
	Wed, 18 Nov 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020547;
	bh=ByvTR0v8KsLN0dfXXc1nRTzeUvz1XJlnbxVwFi5gwU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09HoISC4TY3huBu1hpdlBZLEBTKB6R1WsYpOLTKb8tdIadxqXKk9yGLgCB5uivNbi
	 0/QZa5oHlHcUnG4S/6Do+ovIUvLjcJ1FuO9l05iH4jkyvvPfL3rSkS/l11F/lBEuYx
	 FMRPxeU79a+DKYS6lT7qp5rK7nlm9uLtGbN9ntXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1990/2651] ASoC: soc-card-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150358.000432014@linuxfoundation.org>
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



