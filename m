Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB981D6DBC;
	Wed, 19 Mar 2025 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394924; cv=none; b=ZIJMrU0ZPA8PgNxMlRptZtWdJ0Zym9foTrnVypqbX9Iu9e+4w29Fv/vA2pU/G5aepILcbY3IZJ/ZJmNSifBu/ShAJQUqG9IParOpFtMWvxLBgrL/05n44GJqorV6g3G2+OXlwva3WJFWcuMfSoqGXqGnQLBfpInECy1G2IocVoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394924; c=relaxed/simple;
	bh=R278BY4aQrC4rNO+RgGLmV1EyAJZxdkDO77nyXpZF94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRJbZIILAOjKdGoxREvjtor0bqKISv+TU7IsGokdv65fyVz3qO7UN1IaFyD1jEhFd3eXu/g8Sp015vJnFqqfewql8heZltgcvZ7RuCXkmK9qeUzjY+PIKpsnMhPHTEyBr8E5ZI4R15vhPi2ggZ0YmiOqZzQxlpiVNR+mwo2qoaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4dEUhqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4dEUhqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB72C4CEE4;
	Wed, 19 Mar 2025 14:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394924;
	bh=R278BY4aQrC4rNO+RgGLmV1EyAJZxdkDO77nyXpZF94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4dEUhqiMwDYdqUlgM8F6dIrtZ1fit6o5cNOhTPXr6qfv70LVcjIVPPsYJy+0kQI1
	 GJRVbGbujWhyruZbt1CI0ehnSRwPHeaiK/CYyNiVqzRKjcj7ayV9uN4WI8rVM3LKVg
	 CO25qWWkxq6ldVdJzVQ5gHkbgSyEEWic4tMeL7go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 110/241] ASoC: simple-card-utils.c: add missing dlc->of_node
Date: Wed, 19 Mar 2025 07:29:40 -0700
Message-ID: <20250319143030.446591588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit dabbd325b25edb5cdd99c94391817202dd54b651 ]

commit 90de551c1bf ("ASoC: simple-card-utils.c: enable multi Component
support") added muiti Component support, but was missing to add
dlc->of_node. Because of it, Sound device list will indicates strange
name if it was DPCM connection and driver supports dai->driver->dai_args,
like below

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.(null).rsnd-dai.0 (*) []
	...                                     ^^^^^^

It will be fixed by this patch

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.sound@ec500000.rsnd-dai.0 (*) []
	...                                     ^^^^^^^^^^^^^^

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/87ikpp2rtb.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 24b371f320663..5b6c2f7f288a0 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1103,6 +1103,7 @@ int graph_util_parse_dai(struct device *dev, struct device_node *ep,
 	args.np = ep;
 	dai = snd_soc_get_dai_via_args(&args);
 	if (dai) {
+		dlc->of_node  = node;
 		dlc->dai_name = snd_soc_dai_name_get(dai);
 		dlc->dai_args = snd_soc_copy_dai_args(dev, &args);
 		if (!dlc->dai_args)
-- 
2.39.5



