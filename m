Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF80BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51553C433D2;
	Tue,  7 Mar 2023 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213001;
	bh=gtOZx16Bm1t9BQOlIwmFkTUX9uAi6WzhEXOzD39x21U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpsEP/MopC5KdfRiN1YljpUfD6zyjY6F/o1T6fUB2OR8DnFxS+iD2d6kC6Yu0RqqD
	 GD683fPo0HxQdo9bdO367diGvUZCnh+c60khh7AWQMfqDO4XV5e4XrnIS2iszJLBIj
	 enktxkdZreRUmZbGIjFztecBut90DeXHaiSqyaL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@collabora.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 366/885] ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared
Date: Tue,  7 Mar 2023 17:55:00 +0100
Message-Id: <20230307170018.203656200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Tanure <lucas.tanure@collabora.com>

[ Upstream commit fdff966bfde7cf0c85562d2bfb1ff1ba83da5f7b ]

Add struct snd_pcm_substream forward declaration

Fixes: 078a85f2806f ("ASoC: dapm: Only power up active channels from a DAI")
Signed-off-by: Lucas Tanure <lucas.tanure@collabora.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230215132851.1626881-1-lucas.tanure@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index ebb8e7a7fc29e..9f2b1e6d858f7 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,7 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_pcm_substream;
 struct snd_soc_pcm_runtime;
 struct soc_enum;
 
-- 
2.39.2



