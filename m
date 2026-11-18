Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032116;
	b=hpRKMGWUZaltC9x7Tac+YSwWXlbQ+nU4ROevrTa2qeWwXDtRINvKFyc0MOBXSRBtYy8M
	 mX/EwU7wKylL3HTcd/Z22VfcSnvtI3Gq8m7J/yYfWmWJJxPoKCtIDZgTAZuQK+YQ682W9
	 NckGrVNi2P2tZi/xYIUlOJ2uAuTR39jYNDaHoSIyilS7Yqp4FdjZhHWRR5zgRYN5zw+dS
	 Q6AWEeyGQhFLI++Jz8qBy2cPn6aVCpoAFyH8M6n8ItH92Wxeb9FQqH6r8+vZv01U5eUn4
	 4cBnAEt0sYuVRA5ejR5gYDdO7b87eAlScRmTNSnRL3OQjjCagFlS+rjQCA8VuMVEc9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JCMBXQYBclCfWM3iWr8qNkP3Wp9OMZUkTkRsA45u2zo=;
	b=ehZ/TLuugDDuc7UFMSMkPNUX4/dbEJc6WITCMsyAqWPOU8JuDSbWgIn70IzH3QY6z4UX
	 pB8MnxNfT8WaxV344OdIYtOs8RaPOpwxBCzAxry0yU2rdWArSr/7zd8dz7/z/JG6CPdgj
	 OmFS3z/YFxCAMaOMo9i5CwGfAjdIvILUaHahAWLAPW0PtDUvA8f7VR96cyB9OmitlWH6u
	 MPCzmXkzzVI0Z0Mv+VdllHDhftW9vDCZ8GGzSgH0aHlwnirHygK29dMeVOGytXcYHRlur
	 HBjNVlQ+i8p8qIz13B/noI9aCxG6Z6gnTAF8leAK4vbBSL43v2G4i7thFgVztTFae2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2SS5Ltb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E5606A31C;
	Wed, 18 Nov 2026 20:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2SS5Ltb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6361F000C4;
	Wed, 18 Nov 2026 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032116;
	bh=JCMBXQYBclCfWM3iWr8qNkP3Wp9OMZUkTkRsA45u2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2SS5Ltbaxrky+hCQSv7HOWYMLypODJ2Tp+iKlcfbSHBlw11BAGXoOo44pAbY4lzf
	 a4BSqevQCPfHsAGS3f9X4E0w5orn+x3v51psGGddaTrQVfTqq2iKCcK+yGaSuWz2IH
	 gPRgkT1hT8oMBtveZSRGJ5Gmou3OHIWcfsvvhkiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1299/1756] ASoC: soc-card-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150101.229579116@linuxfoundation.org>
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



