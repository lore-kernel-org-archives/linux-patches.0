Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019263;
	b=KfJHGU1ApBc1rJsP71+tLmL1u37cuJ+K0KXNm1vvu3mEJhkW1jx6XNYvfnHw184fdl5a
	 4O+G7cAczIVAkTgsBFkpX35X89PifOVOkaP7M6OtbukvYfJg9wAnGpRwfCsmQRrVh8NjU
	 z3F2+8jzzphw9d+u5WQkIEffoSZDfuCLEmX+d2LS6Ycy9jI4Ca/6Z+xlNv1tmtHrDEUJL
	 FJdR6gB5My+1v8CO/55JwLzPLB5E3rioOPY5PZQGcJvageGLKK3q/iN98QCLKzXffo8vY
	 klljBF2n2Egjh2vGAj3mZR7Q+G+kBFW30RXbadUKDjUeALGl5O7gcNmbg5ds35aojrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pYlfj3RdPBnGhadhaeNWLJ1fplfJGVDUfOAI80ses7A=;
	b=czUiLwEM3S4QsT6L3/zdyY9JetovQ15OkcTn0YoyoEF9IgDRQJFGcZscWErAlF3Ee6zt
	 xu4TFKyP4lYGBl2M1VX/af4s292/xNoqxd9twpXDaGB8X1oRwjlpbpfHPygF71VRVRaK/
	 XQIoVGQt6+C7Z0aPnDTT1rNbpvWvNRN7Bq429h8GdCzSCIGMzhyakpqJultXkfRUPmyje
	 Ihz6036HTcZXyxXwdwyeh2E6xGbzC8GhGQl3iy+87SF6e8U4kI1X1EjdqvVPfjlGsrKkY
	 VHi1+d8d+k6kUfFeR3ZnlusE6ityMs1przm/UMptQr03rYNsOfEqEXiZ//Mt39FUnGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpGFNwhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69AB60A260C;
	Wed, 18 Nov 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpGFNwhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025201F000C4;
	Wed, 18 Nov 2026 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019263;
	bh=pYlfj3RdPBnGhadhaeNWLJ1fplfJGVDUfOAI80ses7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpGFNwhRYS85Lb8CurTyqHYHF3SRQFxtj+nywVM7ub91PX04uWGLZGhQiwgXRDndD
	 xcRpLayWiNNZJUccW4MGROZS50LwjBzuQFpgtUa0szOoK6sZC2quiQXcy6zvQHMtvg
	 pqv+OfcTLwR6So8bOoGTSGiIDCRrGFxkUYfJi2ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1535/2651] ASoC: mediatek: Dont keep a freed topology name in the static card
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118150343.238397837@linuxfoundation.org>
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

[ Upstream commit 50c5d7f3a9b4d2a2baca40657e46a3508cdac2d1 ]

The machine drivers pass a static snd_soc_card, which outlives any one
probe. With SOF, mtk_soundcard_common_probe() calls
snd_soc_card_set_topology_name(), which devm-allocates "sof-<name>",
stores it in card->topology_shortname and points card->name at it.

If the probe then fails or defers, devm frees the string, but the static
card keeps both pointers. The next probe does not allocate a new name,
because topology_shortname is already set, so the card registers with
whatever now occupies that memory:

  input: \xc0cr\xc2 DP Jack as /devices/platform/sound/sound/card0/input10

UCM matches profiles by card name, so userspace then finds no profile and
the card is unusable until the next boot.

Save the original name before setting the topology name, and restore it
from a devm action that runs before the string is freed.

Fixes: ec4489c43efe ("ASoC: soc-card: add snd_soc_card_set_topology_name()")
Signed-off-by: Michał Kopeć <michal@nozomi.space>
Link: https://patch.msgid.link/20261003194501.832558-3-michal@nozomi.space
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/common/mtk-soundcard-driver.c    | 44 ++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/common/mtk-soundcard-driver.c b/sound/soc/mediatek/common/mtk-soundcard-driver.c
index 4bb98412feb11..a84f4ab4488b7 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -185,6 +185,43 @@ const struct snd_soc_ops mtk_soundcard_common_capture_ops = {
 };
 EXPORT_SYMBOL_GPL(mtk_soundcard_common_capture_ops);
 
+struct mtk_soundcard_name {
+	struct snd_soc_card *card;
+	const char *name;
+};
+
+static void mtk_soundcard_restore_name(void *data)
+{
+	struct mtk_soundcard_name *saved = data;
+
+	saved->card->name = saved->name;
+	saved->card->topology_shortname = NULL;
+}
+
+/*
+ * The card is static and outlives this probe, but the topology name is
+ * devm-allocated. Restore the original name when the probe's resources are
+ * released, so that a deferred or failed probe does not leave the card name
+ * pointing to freed memory for the next one.
+ */
+static int mtk_soundcard_set_topology_name(struct device *dev,
+					   struct snd_soc_card *card)
+{
+	struct mtk_soundcard_name *saved;
+
+	saved = devm_kzalloc(dev, sizeof(*saved), GFP_KERNEL);
+	if (!saved)
+		return -ENOMEM;
+
+	saved->card = card;
+	saved->name = card->name;
+	card->topology_shortname = NULL;
+
+	snd_soc_card_set_topology_name(card, "sof");
+
+	return devm_add_action_or_reset(dev, mtk_soundcard_restore_name, saved);
+}
+
 int mtk_soundcard_common_probe(struct platform_device *pdev)
 {
 	struct device_node *platform_node, *adsp_node, *accdet_node;
@@ -292,7 +329,12 @@ int mtk_soundcard_common_probe(struct platform_device *pdev)
 		card->probe = mtk_sof_card_probe;
 		card->late_probe = mtk_sof_card_late_probe;
 
-		snd_soc_card_set_topology_name(card, "sof");
+		ret = mtk_soundcard_set_topology_name(&pdev->dev, card);
+		if (ret) {
+			of_node_put(adsp_node);
+			of_node_put(platform_node);
+			return ret;
+		}
 	}
 
 	/*
-- 
2.53.0



