Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85329A0;
	Wed,  7 May 2025 19:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644568; cv=none; b=kp4eIKhvda+IG+WOVVMpvHjoSq/yEFnATIr5m8loIHIz1m5muo5P2y+yWG/SplxB1sF9jtBOnvcbLLBXQ6F2ibq18nzSJsJwfZC0zjUdI2Rc4BeHLZCizyt42yaVpNUVYR0wRhGQAI5p3OOheBpDYXsYkM2/N4E/TO/fPR9vWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644568; c=relaxed/simple;
	bh=EDlQ+TBOTVlYRryWeZoD57IcA45iPFSx1gNIRMkW9y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSqjh/f6IenpL7U6e1f+edpbHnYoNonVK2UvMjqMbXqyd1yjQPVGA+ODDSG2VzGE12Q9fknkO+gAHnI5CT7UqwW2sbxEB7Sm2a1F/G5EGwONRs/SsT07IGjJ1u2YHM7gadGCBBrcBObyvJZG5PfXavCeMTuE7PnNtdHDXEh17ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Vl17En0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Vl17En0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59FAC4CEE9;
	Wed,  7 May 2025 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644568;
	bh=EDlQ+TBOTVlYRryWeZoD57IcA45iPFSx1gNIRMkW9y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Vl17En07qtql8sy2/jl9ptZc+K6ibvjaPB7oQB4AQ+WZXge1Ea8zd+dOWUxqmtdm
	 ZR2DOuJIJcc8yjQK//EegBkEHpBV1jMfqZULFlphj4PdO5pEE9n6njoCLEVCcw1LKX
	 cUBwfVgLTpxEggqkjJZCO+ff3tbSbz+QLtv39Ii0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/164] ASoC: Intel: sof_sdw: Add NULL check in asoc_sdw_rt_dmic_rtd_init()
Date: Wed,  7 May 2025 20:39:03 +0200
Message-ID: <20250507183823.283268061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 68715cb5c0e00284d93f976c6368809f64131b0b ]

mic_name returned by devm_kasprintf() could be NULL.
Add a check for it.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: bee2fe44679f ("ASoC: Intel: sof_sdw: use generic rtd_init function for Realtek SDW DMICs")
Link: https://patch.msgid.link/20250415194134.292830-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_rt_dmic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_rt_dmic.c b/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
index 7f24806d809d9..74bca3d04e4f1 100644
--- a/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
+++ b/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
@@ -29,6 +29,8 @@ int asoc_sdw_rt_dmic_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_da
 		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "rt715-sdca");
 	else
 		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "%s", component->name_prefix);
+	if (!mic_name)
+		return -ENOMEM;
 
 	card->components = devm_kasprintf(card->dev, GFP_KERNEL,
 					  "%s mic:%s", card->components,
-- 
2.39.5



