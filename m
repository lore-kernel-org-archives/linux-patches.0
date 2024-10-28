Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F055C15B10D;
	Mon, 28 Oct 2024 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097831; cv=none; b=RswdaCAe1xJh6KydokylpsOwaX2S2UzuLAljyaZ9FUItDr65K3wV/2IWD9lt2KrYiqzDui4EzkVBi6mLvewGxDvtJtG8pF/1LF73Dk4NFoMn3XEHd4JNUsyiv4AfDBQkp/pb+bay88tcuzacUl4A9o8Fk9TFA2gihIG55n5bN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097831; c=relaxed/simple;
	bh=ZQImhHMdSHi9h+0zUzG07+iLWS3/tbLO2cSSm/J9jeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgcEffx+vl4Xqxjb06TpKnb2GM/wxRxFDU43gkw7mjrEOYwdB92013eIHHUA6B1b+jOFe0WncznIubVEr+Hivv7kB1nOwUJfhEI0Up9tSdwvFgl3UCPF2Ydcz4PjN7YOVeFOcEiS9QOGsfZwZGJkAcRUVJrCk39GxzDL6CKuyzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cDmv2kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cDmv2kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCDDC4CEC3;
	Mon, 28 Oct 2024 06:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097830;
	bh=ZQImhHMdSHi9h+0zUzG07+iLWS3/tbLO2cSSm/J9jeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cDmv2kDH79BwXchqzf4tggNDwjN4l6eKanv2Twocm+iZMriTeItJo0wMibfATAmd
	 MA8Y6Nj7LkC5KnLhEdwe1o3goe0FwUVLEI8+VbC3Svr0RLvQb1y5BG3gsAhf0uWFqw
	 Kse124XbzvPzZJIdb2Yd9UZPScYFygEXjOzf1sg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/208] ASoC: loongson: Fix component check failed on FDT systems
Date: Mon, 28 Oct 2024 07:25:46 +0100
Message-ID: <20241028062310.718500661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit a6134e7b4d4a14e0942f113a6df1d518baa2a0a4 ]

Add missing snd_soc_dai_link.platforms assignment to avoid
soc_dai_link_sanity_check() failure.

Fixes: d24028606e76 ("ASoC: loongson: Add Loongson ASoC Sound Card Support")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://patch.msgid.link/6645888f2f9e8a1d8d799109f867d0f97fd78c58.1728459624.git.zhoubinbin@loongson.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/loongson/loongson_card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index 8cc54aedd0024..010e959d4c69a 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -137,6 +137,7 @@ static int loongson_card_parse_of(struct loongson_card_data *data)
 			dev_err(dev, "getting cpu dlc error (%d)\n", ret);
 			goto err;
 		}
+		loongson_dai_links[i].platforms->of_node = loongson_dai_links[i].cpus->of_node;
 
 		ret = snd_soc_of_get_dlc(codec, NULL, loongson_dai_links[i].codecs, 0);
 		if (ret < 0) {
-- 
2.43.0



