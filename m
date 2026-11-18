Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020533;
	b=bj/TEmtNRUzbGt4Asof5SMP3AjKgQfn8km0fHib4q+mkapTPeGim2WSlosWNhjnBYHYZ
	 wABsz2Tt5AinpOVG3kyBPS6i7RKgVIHNJlMxwwJmURq+17FsJbcvFwbhdsib9cdhRZ59/
	 S0kpx4xUhsKPNLXOXe7snNfJCY7Y9AM3caENzFNsm38n5jQCdZj9QBCHm+CL7yH+xmgp0
	 0hDxklv/OJ4nifurlcONKRyG7nmcxlMw6Xi6Oq0hpAfveV8qRcPjn0jwnav3nqKDNXGHB
	 AUF2uFQQ+Y+IHE6TMAHzCRwwME11T0pXhuzyR5LEhUr6YHunZOVm5YLmLfP5hNUzpog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/oLB/LW1lc8YlOv7ZMdp23Kd2jcWYIGzLXGe5kPP2K8=;
	b=czpVvq3debhDoCbt2Igi/XJ8DI5Xooc9dx5tjLimCxLWfumr7mZGzEqjZ7Uz3AKQ6nVU
	 CWqydyH5TVI07v00XVMihhWo2vP1gcaYpC5fbb7no312bMGUx4mZuYh1L6bdJA39koLBp
	 e11hW4J+V7HqDLnX+Ix94vL8EX+hw86Xnq/iCZSBsJaT80nHBZU+fquRbx0akWsBs98DB
	 Et4gfLY28qeICZSOCx0iS+m9c3N4TyATY8Yol/YbKddC7I9sSJTpr//kALPbeLlXUTKrb
	 cou3mrapYAXyQsbX0gGfCKnK3MMtXlePPbPg9fUvn9aMWkdRLPRgpUX3kwG9cKFt8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eo8vnlmd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256BA606A31C;
	Wed, 18 Nov 2026 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eo8vnlmd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7416E1F000C5;
	Wed, 18 Nov 2026 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020533;
	bh=/oLB/LW1lc8YlOv7ZMdp23Kd2jcWYIGzLXGe5kPP2K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eo8vnlmdC84lghTf1a/zbJj/y9khshFzh/T7HwpXJF1eKpMiaFgaL9PICZZ5I5GKD
	 qrnqyd51A1WV17VO+VgpXPB1yrA7cmvdiyKgEw8O+jSk3wKNUd+BQ839LuyvZmGbJ+
	 lUgnqFNMRQnpRA7RS4D8/FN+Oyul+Z3ravY/C4e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1985/2651] ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150357.849157266@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit f15b2df0b940cb2c01797f78791de3279d514086 ]

snd_rk_mc_probe() acquires references to the codec and CPU device nodes
with of_parse_phandle() and stores them in the static rk_dailink, but the
driver never calls of_node_put() on them. All error paths and the success
path simply return, and the driver has no remove callback, so the
references are leaked for the whole lifetime of the card and each failed
or repeated probe leaks another pair. The same pattern was fixed for the
sibling rockchip_rt5645.c driver.

Release the codec and CPU device nodes on every probe error path and in a
new remove callback, and also drop the extra reference placed in args.np
by of_parse_phandle_with_fixed_args().

Fixes: eaae2ea73593 ("ASoC: rockchip: Add machine driver for RK3288 boards that use analog/HDMI")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261008181459.2762862-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 42 +++++++++++++++++++------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index 541163ed56fc3..9bb02d41d9013 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -201,36 +201,59 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to parse property 'rockchip,audio-codec'\n");
-		return ret;
+		goto put_codec_of_node;
 	}
 
 	ret = snd_soc_get_dai_name(&args, &rk_dailink.codecs[0].dai_name);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "Unable to get codec_dai_name\n");
+	of_node_put(args.np);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret,
+			      "Unable to get codec_dai_name\n");
+		goto put_codec_of_node;
+	}
 
 	rk_dailink.cpus->of_node = of_parse_phandle(np, "rockchip,i2s-controller",
 						  0);
 	if (!rk_dailink.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'rockchip,i2s-controller' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_codec_of_node;
 	}
 
 	rk_dailink.platforms->of_node = rk_dailink.cpus->of_node;
 
 	ret = snd_soc_of_parse_audio_routing(card, "rockchip,routing");
 	if (ret)
-		return ret;
+		goto put_cpu_of_node;
 
 	snd_soc_card_set_drvdata(card, machine);
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "Soc register card failed\n");
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret,
+			      "Soc register card failed\n");
+		goto put_cpu_of_node;
+	}
 
 	return 0;
+
+put_cpu_of_node:
+	of_node_put(rk_dailink.cpus->of_node);
+	rk_dailink.cpus->of_node = NULL;
+put_codec_of_node:
+	of_node_put(rk_dailink.codecs[0].of_node);
+	rk_dailink.codecs[0].of_node = NULL;
+
+	return ret;
+}
+
+static void snd_rk_mc_remove(struct platform_device *pdev)
+{
+	of_node_put(rk_dailink.cpus->of_node);
+	rk_dailink.cpus->of_node = NULL;
+	of_node_put(rk_dailink.codecs[0].of_node);
+	rk_dailink.codecs[0].of_node = NULL;
 }
 
 static const struct of_device_id rockchip_sound_of_match[] = {
@@ -242,6 +265,7 @@ MODULE_DEVICE_TABLE(of, rockchip_sound_of_match);
 
 static struct platform_driver rockchip_sound_driver = {
 	.probe = snd_rk_mc_probe,
+	.remove = snd_rk_mc_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.pm = &snd_soc_pm_ops,
-- 
2.53.0



