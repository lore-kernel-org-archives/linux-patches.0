Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7478622A80D;
	Mon,  2 Jun 2025 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877255; cv=none; b=nnb13ZCWrQi0OVCwqXNtv2NAZQPUgcldJjBZgDtG2TaN44rzrAFqkQHqPcljrqO35fZS/6hrx4GyA74/ihZVdX9GnUqFMHZrV0sk2Z6DG9QzFPthbgfspN/ZT9jpkSl8WmoUMiMvP+M93zKona8opRrPXY4PwwjVqywxW7zWuiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877255; c=relaxed/simple;
	bh=8Sc8PLZ/CPpX7dqNZGoI8ngFmRVFkvUkFp9c7GPwXTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOtqX0t+aZ+Rp7VkXOEDavUV9zYghMiM8hLPQQnMEPF/ZlXxcPb4rstg0rt2SBYwGG5xD7t7WEQHThgepfXGPpCJLb6Ld6mojjyFTbxlTo2CRwxwQcs5FXUXBQ5SE3F2AmPOa/OV6MnAV5/rboYT6GWSrFhUZY0ZVO2NyiFYN98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVIpiXrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVIpiXrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C61C4CEEB;
	Mon,  2 Jun 2025 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877253;
	bh=8Sc8PLZ/CPpX7dqNZGoI8ngFmRVFkvUkFp9c7GPwXTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVIpiXrBLxblhwWoOFf+dHr2xOyv6IpwWHgEINnpfjNrboemi9FOWKnbnFB58UoyT
	 AD1DPd3xHhElcnus/s0AtxovVagIwthHqrs9dhljY6H//6f545LUsCmsf2ZtB4aKSx
	 hbjybdIPw523FWjjkJjeu69qapbnZtaZc3q0NIz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/325] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Mon,  2 Jun 2025 15:48:16 +0200
Message-ID: <20250602134328.727846753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a9a69c3b38c89d7992fb53db4abb19104b531d32 ]

Incorrect types are used as sizeof() arguments in devm_kcalloc().
It should be sizeof(dai_link_data) for link_data instead of
sizeof(snd_soc_dai_link).

This is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250406210854.149316-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index c6d55b21f9496..11430f9f49968 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -517,7 +517,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5



