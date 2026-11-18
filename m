Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019380;
	b=lFDdOjw+vI5LCNfk85XHhYrPv+HsrB+jixleWXFggPNdVFt58ogohVBF1IKHmfUYvIbj
	 MgGc+vXA3M7uwhqKYntr+7caEPD0Ij4TiR7yrjXJzuhwhFiBXLtXvnO9mJiWZBlpkSbmi
	 mbj7KbBfObNiXvI8p3uGLm0uWxYMPKzTeQ4PlQllXf15YF17JQ6Du4RC4Nis/fs/dgwFn
	 bjtMen2b8YAgLwO9gsK1PU5L/LYR3gEHLeijgCz4nC8niFr3w/gzdBEvQgXK2iJ4ve+Zh
	 IgFjN2irINYL5VeGHl4akkIHxA2TRuixTreNwFfkkr65P3MSNt1yYa4Z5VAPpzRaCMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hDnCvQYXehmrhw/4ZMVmUrsLMvYcV6LMjrxarU+P8S0=;
	b=QyTzF22iuwPLTv1ks03Yr9ptPi0mqjBM/KDNhi//oDXhYSK9I3xTWGUOhVr5YxtGAfxc
	 d8qkUfoEPjhcAcipW1ppGeoyVNjn4NlpLocAK3sIy/RqBR0ulmJRilJfk+sKQnuuMms+G
	 Iq4EdDTT6A/H3Jqzh79eTWbqowBoYkHaf4WWMTPWiXlOKVUkAiEVH+PbnhYaVmqppzumS
	 S9wIi2pvS83M8edQ4fUOCH6CxOIB/9jdeIlz1FrXctn0lcRf0tbwF5NCdST/9c/GCkrjr
	 ttTYjC6ruGl5hAAqX9aaB3i2KTEi4PG1FaKQCtJ/NwS/luGf8zF5a7A0kQLWJP4u1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8HRfB8I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4913C60A2607;
	Wed, 18 Nov 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8HRfB8I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE081F000C4;
	Wed, 18 Nov 2026 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019380;
	bh=hDnCvQYXehmrhw/4ZMVmUrsLMvYcV6LMjrxarU+P8S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8HRfB8I3IqC6aCii0q52cpvE6SGTIaCUFwQg5PAJ8JWoSRY908xmCooz45bUvNIF
	 PpTWtcWhI90/OPr+Gl8Z1NAgWQhY71OOBpU8SSWKT6Mlzw3bFLH2Tl+uRREk+DfAGH
	 C68hT8z/sQUnRpkxXf+pQo0CaHIN9J2tZgMKWPhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1534/2651] ASoC: mediatek: common: Keep codec references until the card is bound
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150343.204817576@linuxfoundation.org>
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
index 2d39ff23f8540..4bb98412feb11 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -129,6 +129,11 @@ void clean_card_reference(struct snd_soc_card *card)
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
@@ -325,8 +330,22 @@ int mtk_soundcard_common_probe(struct platform_device *pdev)
 
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



