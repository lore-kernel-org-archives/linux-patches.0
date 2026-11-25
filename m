Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621871;
	b=h3bknqMR9+JlMcnjnAc2wAl3rpBNZwmKAVmpgnErHzSFf5m6zj1u3dm625cCiFghp2Pl
	 CVlhHcQu5v+fAwmGNzD2oPvd6Wpl62JIL59Jx050RRmAEd95BRCG4F/0QQ8NpE47disDV
	 ARkLTq3ov0Ixg23PvsSgVDjjJI6AEeHcoHxE67OkfvGKT4kcygy0nszrD8SCTHE7womMq
	 McFWvCzPGtycMorCwK7XdtXSGVWYz3Y+rciTmg4kDXsIZZKzI1hGMAZETFufmiIA/o8jy
	 5o96Fo0t4V6ad5HHqC10VeOhjQO6GhxldZpTdVcJezdXx5cNF7NeS2goozi3cXXl8iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g4VvpawkCPBWvHhflzY61vD3qBIh4rbJD3loCSnv1DY=;
	b=TUfsb7Vg6vUOo8F0hbRQ959q59bSk9e63jhVSsY0yEOKS62QfGT4yztj/rf0gMATG9Ei
	 2uJ0hVMV21eDRHC0m+ONWj8P3QKl7IldDtgRXqIQ6yx3ZCk4S5/eHSMcPaFyIKLxRDQnF
	 534Dy1WQvh/I15U28MuwvP70zcGYxDX3q+ixirid+T16tt5Pcwzg4418aAKxeIE0EbvWe
	 ++HX6kFxOprVdPRI4+b3/g/qO/4Jj9x9yuzYajZ3eNgMKM6VvoloCBZi8FIOo04UCh1lT
	 pWv3jipp1F/yyAgoD7/UjVR7nGmyE+5p3gnnpO773SCcBMf/6vxi+AIDGgHeu/xWMBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j9w+8I+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8F606A321;
	Wed, 25 Nov 2026 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9w+8I+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BD41F000CA;
	Wed, 25 Nov 2026 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621870;
	bh=g4VvpawkCPBWvHhflzY61vD3qBIh4rbJD3loCSnv1DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9w+8I+/66Pwo6UtaPoyTFYcQm3YvUrhZyUtwfW4sG/yAnTa57fGvnJxGzBwqSvSP
	 TeForJKPQM8IquYSado82mOihZ9zZbQwfr1GXLipPrYB3jlSIasczzG0TDr0GANuDu
	 4a8nuEU31NwtlOQMxZV3RBXsTJC+0imWoPeW6Ce4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Baker <tyler.baker@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/990] ASoC: qcom: x1e80100: recreate the headset jack on card rebind
Date: Wed, 25 Nov 2026 15:28:48 +0100
Message-ID: <20261125143830.548092811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a3f4785c4bbe6..f9a1dfe3e6ae1 100644
--- a/sound/soc/qcom/x1e80100.c
+++ b/sound/soc/qcom/x1e80100.c
@@ -49,6 +49,23 @@ static int x1e80100_snd_init(struct snd_soc_pcm_runtime *rtd)
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
@@ -153,6 +170,7 @@ static void x1e80100_add_be_ops(struct snd_soc_card *card)
 	for_each_card_prelinks(card, i, link) {
 		if (link->no_pcm == 1) {
 			link->init = x1e80100_snd_init;
+			link->exit = x1e80100_snd_exit;
 			link->be_hw_params_fixup = x1e80100_be_hw_params_fixup;
 			link->ops = &x1e80100_be_ops;
 		}
-- 
2.53.0



