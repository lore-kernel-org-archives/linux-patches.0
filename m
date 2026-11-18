Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025985;
	b=37ZVC5ql3I/jnkQHlHB0tKpBr4UAmwVGJxIpATNIH7+HNH+1tz2uMCmsj0h+rAW/8OUJ
	 rIp6Ew5XrLEGjuEJpIhW+qzYoUxGe1ywb6UJH/3E0UnpF680IonTOdf9rS1lkzTs0GAp/
	 xI7p7Tgn8nUrj3NaO3HBixVybljSHJgg3dA2yI41Hea/1F+0h37L0zgSvzR20+7XbZN1L
	 JElRqFDr1OmPcne5h9V46atGy/941B65RDh62FVQ/XpNdYPxxOqc5psSvVtM31pm2c0+5
	 P3A6FKGMB8coGCFD+VI8fd+iszm6ROMF0Li3bl097bItIP/Gd0LT9ypoxCOhDNQNvzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QZpjer5qkCrKvRvoOckybWdfy6r6hD2qyb6lUDXWYKk=;
	b=rxPNk211CKjetKY79GAOub/IjrjaR45no5Y/Y0E6WhTXlw7DwTPl7lrd95S4N5O2pgYY
	 f6u958OhPGoQRjk3lW8VbLmH/9tvCrHY4C6gJtbJBuNKHL12J5zML4lePxQF2MEBiFI+H
	 R0B1NszFHjxT7dyAWoA3EfZbSBwRPeoDYe33pHAU3IIVokD6QbbpK5XKz9/xeGelSORtO
	 bs0iDezZUx2s2jn3a9Cz2NoVkpO2vGO0dw9vbXD5+4jQXZBo0rBb34vNH6/Nk1/DjQogx
	 xhIihrP7xzonndUUufAa1tdwJ5dt0e2WYVkD5tcV+hyxQhbm8lzFBuQYAwJLvOE/m6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gr2Xf1rT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA553606A32F;
	Wed, 18 Nov 2026 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gr2Xf1rT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA841F000C4;
	Wed, 18 Nov 2026 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025985;
	bh=QZpjer5qkCrKvRvoOckybWdfy6r6hD2qyb6lUDXWYKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr2Xf1rTED5zd2JylzRt/7oJVygkSDxzj/3cAvC7l0313ZIcdTJKkjPojpzS2AdrN
	 xIHn0hKbzF0CzOFcvtbghxMN2v/EVDKXT8Ksr2jIKk0O/Eb3xvi1huQjPawfGqY0qq
	 gnSVIiPItJ2nrLWTngqe782d+l7is4uLI3TAUqeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1273/2151] ASoC: mediatek: common: Keep codec references until the card is bound
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118150208.501815050@linuxfoundation.org>
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

From: Michał Kopeć <michal@nozomi.space>

[ Upstream commit 6cb1f09e1f699d0c7f748057bc50d84a1e9e77fc ]

mtk_soundcard_common_probe() drops the codec references parsed from the
devicetree right after devm_snd_soc_register_card() returns. When a
component is still missing, snd_soc_bind_card() queues the card for a
later rebind and registration still returns success, so the card is not
instantiated yet. The rebind reuses the same dai_link array, but with the
codec references released both the codec name and of_node are unset, so
it fails the dai link sanity check and the sound card never appears.

Release the references right away only when the card was instantiated
or registration failed. Otherwise keep them for the rebind and release
them when the device is unbound.

Fixes: bce93a162505 ("ASoC: mediatek: Add common machine soundcard driver probe mechanism")
Signed-off-by: Michał Kopeć <michal@nozomi.space>
Link: https://patch.msgid.link/20261003194501.832558-2-michal@nozomi.space
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/common/mtk-soundcard-driver.c    | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-soundcard-driver.c b/sound/soc/mediatek/common/mtk-soundcard-driver.c
index a2a30a87a359f..102499bfffe18 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -131,6 +131,11 @@ void clean_card_reference(struct snd_soc_card *card)
 }
 EXPORT_SYMBOL_GPL(clean_card_reference);
 
+static void mtk_soundcard_put_card_reference(void *data)
+{
+	clean_card_reference(data);
+}
+
 int mtk_soundcard_startup(struct snd_pcm_substream *substream,
 			  enum mtk_pcm_constraint_type ctype)
 {
@@ -331,8 +336,22 @@ int mtk_soundcard_common_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 
-	if (!needs_legacy_probe)
-		clean_card_reference(card);
+	/*
+	 * When a component is still missing, snd_soc_bind_card() queues the
+	 * card for a later rebind and returns success, so the card is not
+	 * instantiated yet. That rebind reuses this same dai_link array, so
+	 * the codec references parsed from the devicetree must be kept until
+	 * the device is unbound: dropping them leaves both name and of_node
+	 * unset and the rebind fails the dai link sanity check instead.
+	 */
+	if (!needs_legacy_probe) {
+		if (ret || snd_soc_card_is_instantiated(card))
+			clean_card_reference(card);
+		else
+			ret = devm_add_action_or_reset(&pdev->dev,
+						       mtk_soundcard_put_card_reference,
+						       card);
+	}
 
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "Cannot register card\n");
-- 
2.53.0



