Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214895;
	b=HU40is4w7BLS7gFhwE27cERDlZCUuFvS13vB5V2lG1Z8ZtVvx6KpTxFsr2vZL36lc58w
	 +AdVtGA8OkwYB0Re+CVuusBvgHH1yJ4V4vkp0XwYq0NmwJVdlGOOhcDLC3q0gjTTaGvRs
	 6T+u8x3TFjGnCG6moVC6ImzTdQeAVk2LEWI4OohrhYbq+7L2e6bNl2BWszUYodPzIqCe6
	 QBsKCbXYZ4iI5dwWeWo6xT1PfymyacEXzlAaE9F55MpTTyRRZW1ppeha/VK6ZYx6LRwtb
	 dVmBmJPe06gNRdTeb117xUxTWiBXK5udI4UDzcqDT7MtwxK1F32wbBW//OKWwLuj+uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Nx0FrqUi+8dDfAFTgJcRfg8QwN97l45pSLgKg+Lhx0=;
	b=U3W6Xr6wZiOrr5QLeprpshfZ2rDsEi7DjcAuqQu8PffT8/Q5Dnf7T1Jz2fQjhffooYzL
	 BOPWxmWKgIHoPPMhHVu6QIhUVBzH6GA5J6O//AKl78q9lN6xiaIYu2bbBGpxXO6LkWoCy
	 i3J67VWoaKz3qVwXrepY4ddQD65PqUwMqZFort57vKGAPPB6Tc/ysJcUyJ5qHQRXchcgl
	 IYWKZHsMFBdss71zS5kv6RffIHKCklK9RbGp9MOmh2O3chkxk4/wqd3Q0dc4pNeLh1z6L
	 s4sx4SxwdUHAPokXmZLQnMYnQjRodbO/gjIzftK5a/pKrvSQWSntylOEH1uBRBuEXLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPuxnVho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C1606A33A;
	Wed, 28 Oct 2026 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPuxnVho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783DA1F01825;
	Wed, 28 Oct 2026 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214895;
	bh=7Nx0FrqUi+8dDfAFTgJcRfg8QwN97l45pSLgKg+Lhx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPuxnVhotf0N9M30Wu9fKWO7K9353w3cCpd87NNN4oIHnfUpKTFKRLDOrWzb4fYU1
	 FrO4iS8yMR8q5XqF6Dh4rj3JUa7OyA2gsD5IzWkdDXoL4QU0rX2nM5G3/a3yZoBe1Y
	 qAdv19o/5wsIo1vRLE51o4Z36QA+JNk6h9VnTbqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1020/1887] ASoC: amd: acp-mach-common: Add missing error check for clock acquisition
Date: Wed, 28 Oct 2026 17:51:56 +0100
Message-ID: <20261028170522.627113540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 30c64fb9839949f085c8eb55b979cbd8a4c51f00 ]

The acp_card_rt5682_init() and acp_card_rt5682s_init() functions did not
check the return values of clk_get(). This could lead to a kernel crash
when the invalid pointers are later dereferenced by clock core
functions.

Fix this by:
1. Changing clk_get() to the device-managed devm_clk_get().
2. Adding IS_ERR() checks immediately after each clock acquisition.

Fixes: 8b7256266848 ("ASoC: amd: acp: Add support for RT5682-VS codec")
Fixes: d4c750f2c7d4 ("ASoC: amd: acp: Add generic machine driver support for ACP cards")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260310044327.2582018-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index 1d9eab824145c..093c3fa708291 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -87,8 +87,13 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682)
 		return -EINVAL;
 
-	drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
-	drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
+	drvdata->wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+	if (IS_ERR(drvdata->wclk))
+		return PTR_ERR(drvdata->wclk);
+
+	drvdata->bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+	if (IS_ERR(drvdata->bclk))
+		return PTR_ERR(drvdata->bclk);
 
 	ret = snd_soc_card_jack_new(card, "Headset Jack",
 				    SND_JACK_HEADSET | SND_JACK_LINEOUT |
@@ -248,8 +253,13 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 		return -EINVAL;
 
 	if (!drvdata->soc_mclk) {
-		drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
-		drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
+		drvdata->wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+		if (IS_ERR(drvdata->wclk))
+			return PTR_ERR(drvdata->wclk);
+
+		drvdata->bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+		if (IS_ERR(drvdata->bclk))
+			return PTR_ERR(drvdata->bclk);
 	}
 
 	ret = snd_soc_card_jack_new(card, "Headset Jack",
-- 
2.53.0



