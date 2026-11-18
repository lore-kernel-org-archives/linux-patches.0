Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050345;
	b=F7Q0es0op0PfwCuEHJpPoCeMxzyKSB5tUEGUbNNjmyCSwviOExfBjfNfyYQHG8gW1s5+
	 fjyWb1XWKa71PF95IMIUcIlaZYqq6obAgMHzXPC/IDBLIkTrc9EkNFw52jEKEXssJxdid
	 QPQ5VTN9e1HXTQnuyPCRtsKOqwPXPv07zk6r8t2WVL1NfmPBme0CXPGcDgrmDS5mQrrxp
	 Hzy9oG8PGSJaL7jcKGof/PlOCARhCbuGU6xidZYDS/KF5JHRUxwgai1+P5ZmWxyo4tJHF
	 aIk4bdqNRZUu7JrofUvr/THAo86MEEt+8+h8boDNblUCV0WKbxSepovjbBVD3FvSB6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RayNijdgAKKepVRKcDNnZe0sgvUKeoRB7ujN3P8HPmI=;
	b=bAarg9X8xgtrfJ87rRUbMH04CaCBd4Es3AbWsh1xewcGh/9TfVYbwfoJIF91Sfm/nikO
	 MlQujMI2eZ6PvIKRqRDx19D+A9oEm+wkpjfgnaghDXyAKI6++AHRkLjTDgvKC2KRldJJj
	 En77E9I17+42w6jQBMo1bpDywD3OReKaaFPKWRJpVDcEN6AVLKXMQnT240gQ1Yre+IWNm
	 Fi3HkWlpFHAuF6jhaku1UCNduUFINcoOMMQ+R8lTBEQwOygbnvb8r2nLbG2sYd7GUBpSL
	 vCXbIcUn4F/ynhyHJhKzxmzbq3tsChoJn50qhPqhEZMUzsC32Ni3jOgLZ5oqklNIp4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQNxYTu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF90606A32A;
	Thu, 19 Nov 2026 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQNxYTu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503501F000C4;
	Thu, 19 Nov 2026 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050344;
	bh=RayNijdgAKKepVRKcDNnZe0sgvUKeoRB7ujN3P8HPmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQNxYTu5u82qGjWVh+xbr/LSm8GQsz5jV3vlJGMcSgh+hP6jVZAjecwyACHon5ghH
	 2OsQiMSo52NZH4T2hw+DpbQSCqM6We/4Jxrkr/YDNw4KH2nuLjDjSyqAYIV5nvb5qI
	 fX15rQstY7b9oA4pWSAL48nIOFv26EL+tO/uqn4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2676/2857] ASoC: soc-utils.c: add asoc_dummy_dlc
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150337.925760138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit d2a4e0d7409705a0b6010ee537c5114eac31bd13 ]

ASoC uses dummy Component, sharing snd_soc_dai_link_component
for it is better idea. This patch adds it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com
Link: https://lore.kernel.org/r/87a5yy0zyk.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org
Stable-dep-of: d9c23ac1217a ("ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h   | 1 +
 sound/soc/soc-utils.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 015d5fff397fa..cb6bfa8d69fe3 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -875,6 +875,7 @@ asoc_link_to_platform(struct snd_soc_dai_link *link, int n) {
 #define COMP_DUMMY()			{ .name = "snd-soc-dummy", .dai_name = "snd-soc-dummy-dai", }
 
 extern struct snd_soc_dai_link_component null_dailink_component[0];
+extern struct snd_soc_dai_link_component asoc_dummy_dlc;
 
 
 struct snd_soc_codec_conf {
diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index 1bbd1d077dfd9..9c746e4edef71 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -225,6 +225,13 @@ int snd_soc_component_is_dummy(struct snd_soc_component *component)
 		(component->driver == &dummy_codec));
 }
 
+struct snd_soc_dai_link_component asoc_dummy_dlc = {
+	.of_node	= NULL,
+	.dai_name	= "snd-soc-dummy-dai",
+	.name		= "snd-soc-dummy",
+};
+EXPORT_SYMBOL_GPL(asoc_dummy_dlc);
+
 static int snd_soc_dummy_probe(struct platform_device *pdev)
 {
 	int ret;
-- 
2.53.0



