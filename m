Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619001;
	b=Bt0hVu+xEIv0JnyxQk0Sxl5/CCoyuYWNzxlGy/ELvb315PzP6SWIhBsBVLj4Pu9AV6/6
	 EVkQ6F+qdUZUw2zWps1+nUbtvamUEzDS4W2c7xF2cp/vhP7z1F3TRMvdT3ruT5XXXDLe5
	 hgoP21bhCpe7O7u9cas/99Q8r4POZPo1vhMlKhGY0wz39ndMBrI0g0LYcEhvvb4UEJf8C
	 RtmPW+3SNb3ikIK82mAnLyKniEssfMNVr55hn1At/AwwdhxmxeuInoGPbccfWinuD3DQa
	 Amj8u2jSP8Gyjd3Wl1foSgMET6NkTAfAf+4jpR128do7VMYmMr7IUv/Wg6Pa5Qxt1mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NoNQKgG0E6HZDByHEjRXEmdsYfrFga8lTUJh4s0qOE=;
	b=xPBH4IBscA1/a4HW0WBLebjx79AG+9bDvUpGQiIt8st4p/oVZV2axqneXTDfqRp+P7Bw
	 8AlJea5j0waFyKPh0ylv/iJAvxeGhIos+YAWNCAZR6rbGLtXWQM8C99d6/QT0Av1llaic
	 bTTDoquvNWSvUFFqo51I3TTmM2C8Cx+wF2e1Uns8f/11MJFiG9RICJHphy/KXiOcRMEWx
	 2ysgC8wM1q/82l3sEREnW+1mkWONWy0MsqN0Cp2Lp+/LMokFdahb8qTeGUo90/OLf3Gr6
	 22HxC7y3Y7ranqRSwohPU0qBULu9hacP6jP2JsLYJyNSqhviDlK7W1vIJs8yKk4dwAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpnCup1c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E17606A327;
	Wed, 25 Nov 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpnCup1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A015E1F000E0;
	Wed, 25 Nov 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619001;
	bh=+NoNQKgG0E6HZDByHEjRXEmdsYfrFga8lTUJh4s0qOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpnCup1c26BOUFYcqdQnJJ2oEMXnObLYgQcg3FGpfvZ8YSH5UeuJLjeM8sRSHYVGl
	 3JW3wbKS1YmihHuhLqoy7dVqYfMQ4u6bR1anxkDizKz2yS8TqnAreEUYClzOyEYhW3
	 Rgb3c7dK94KyIxUD0fWznG+tJQw/wu8a7AcMmxN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Baker <tyler.baker@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0412/1005] ASoC: qcom: x1e80100: recreate the headset jack on card rebind
Date: Wed, 25 Nov 2026 15:29:10 +0100
Message-ID: <20261125143831.403314332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Tyler Baker <tyler.baker@oss.qualcomm.com>

[ Upstream commit 704251f9dad3cb5f93ef64ff2d547868d42de319 ]

The headset jack is only created while jack_setup is false and nothing
clears it, so after a card rebind it is not created again and the
codecs keep a pointer to the freed jack.

Clear it on link exit, as sc8280xp does.

Fixes: 6b9dc2da6657 ("ASoC: qcom: Add x1e80100 sound machine driver")
Signed-off-by: Tyler Baker <tyler.baker@oss.qualcomm.com>
Link: https://patch.msgid.link/20261106054333.2748248-3-tyler.baker@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/x1e80100.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/soc/qcom/x1e80100.c b/sound/soc/qcom/x1e80100.c
index c81df41ace883..213d7f45198cb 100644
--- a/sound/soc/qcom/x1e80100.c
+++ b/sound/soc/qcom/x1e80100.c
@@ -68,6 +68,23 @@ static int x1e80100_snd_init(struct snd_soc_pcm_runtime *rtd)
 	return qcom_snd_wcd_jack_setup(rtd, &data->jack, &data->jack_setup);
 }
 
+static void x1e80100_snd_exit(struct snd_soc_pcm_runtime *rtd)
+{
+	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
+	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+
+	switch (cpu_dai->id) {
+	case DISPLAY_PORT_RX_0:
+	case DISPLAY_PORT_RX_1 ... DISPLAY_PORT_RX_7:
+		return;
+	default:
+		break;
+	}
+
+	qcom_snd_headset_jack_cleanup(rtd);
+	data->jack_setup = false;
+}
+
 static int x1e80100_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 				     struct snd_pcm_hw_params *params)
 {
@@ -172,6 +189,7 @@ static void x1e80100_add_be_ops(struct snd_soc_card *card)
 	for_each_card_prelinks(card, i, link) {
 		if (link->no_pcm == 1) {
 			link->init = x1e80100_snd_init;
+			link->exit = x1e80100_snd_exit;
 			link->be_hw_params_fixup = x1e80100_be_hw_params_fixup;
 			link->ops = &x1e80100_be_ops;
 		}
-- 
2.53.0



