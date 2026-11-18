Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032096;
	b=CXvyYe9lQoe5186ijPL+N9go5TF1XyzvtRfFzLOEauZeaWc37q5Yx0y0bknS7j5ndWFr
	 58TYXtGkncZ9Q0QdqIY96XkPMqaFKfUd1yMs2bzqsJynzm/gDOsANbgOi+j4dKkiKWbvS
	 MFeDcsHVNvaBcA7xPp+SuPZGEWpEXhKnDH7LgD2NbokxDUiAGMKU5nsqWKK1lxgmnEho3
	 A5/MmQPyrDnPQNNbhSGU6ME9dCPWW+Lvtbp37mCi6LoWLw+IIlSLpMI3D68ZKXUPk3t4C
	 5UcjPh7KsexBDLV0faQZkd6jQgbtG9PbAhNkzO8M4UajxkGUsTM33y7LDIuqEB/a6kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fnvrtaaQXEZ3uHhyEbOwUEuBhX2J4dSbmNSdVs9DhZE=;
	b=Yu2hHErO1749F4cpug18EDJEv8OEkIOh0v+Gt3SLal6xriK6cqIgHSyBmjeSNfefpKUX
	 6cueeE/5/XuFpqJwTF/dnFtdHKvXVMO5qNlu10icqX1KO+7FBnJlO3+M84caqMiVLMN1q
	 vzHEPe84vnRc+SrFw5dsLpY3AEBiNuZmaBGbABM9YyNODptGRp7GNmcph5AUWocDKkxbI
	 s7kL5+Fg1RwCfgdR1mPH07qDVBu8VszcVPJ7ve7Bk/plM8wAWX7x8vtWgyL1+WVWGR9K9
	 SEavAZXepFHmbKr4IkuUEMbc/vSbH9SIlexiWa/qj06YWWA8IoNj5eUs4dqmfqd2F4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oL2fT8NA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0C606A31C;
	Wed, 18 Nov 2026 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oL2fT8NA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2D81F000C4;
	Wed, 18 Nov 2026 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032096;
	bh=fnvrtaaQXEZ3uHhyEbOwUEuBhX2J4dSbmNSdVs9DhZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oL2fT8NAvBTnS8nhIy968zDjh1Gx190UfZ1+yzj6J77044HRVD9FOugJO3atlHU1P
	 b7iToYoFnOLf+5Xc3ImZx+Smr0mDS3U73l4Ix/dLTXXO5GO2JwOd67cN+mtw3Q2H6H
	 7XIJEE+uTFU+Fp09P2Uysze2L3A+gYMLWUTQE8ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1292/1756] ASoC: rockchip: rk3288_hdmi_analog: Use dev_err_probe() for error handling
Date: Wed, 18 Nov 2026 15:56:59 +0100
Message-ID: <20261118150100.982158814@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 06f5854050f56775977f9972b78a21806de001f0 ]

Replace dev_err() with dev_err_probe() to prevent log spam when probe
returns -EPROBE_DEFER.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260806052136.21034-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f15b2df0b940 ("ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index 2b06ca336ec16..58ee60173153e 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -204,10 +204,9 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	}
 
 	ret = snd_soc_get_dai_name(&args, &rk_dailink.codecs[0].dai_name);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to get codec_dai_name\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "Unable to get codec_dai_name\n");
 
 	rk_dailink.cpus->of_node = of_parse_phandle(np, "rockchip,i2s-controller",
 						  0);
-- 
2.53.0



