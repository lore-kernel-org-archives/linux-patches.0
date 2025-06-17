Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD7E2EF659;
	Tue, 17 Jun 2025 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174288; cv=none; b=bTyVRwRua/RuRAgIT4c0NNF+/X0Ocov44TfddplO1jjGOciEOUQMD/eFonjZ/kUxnLtUg4viLocudRqsE8t+qokR9NpkxCXm2jMgkytC4Q/VF8Q5tZ9ulDsN/EUyx1N8jQajeTR2LKaZun/L/ZbvNuM8k4pxWVCOwpbpBLZ7hbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174288; c=relaxed/simple;
	bh=KkQsXmrUiw/7932r+05jz4Z6ANoSyxrh94LVLgjBMcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA6kiDuyO/rVZ93qX474u4B3D5gGrRCQwaV3Fr3Rnzy3RZ8IQ3ecyCIhDBk3GfBCQAhSdhWP3CqvGhSiNvqPoemwTVJjSI1IZmKjEN9jh+cGkUqMmAbNNZDyeCKWIFXLeE4y1hDWovxynslMuoDckpZaTibOhAcz/wm2VcyT8N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWAVizYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWAVizYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60ECC4CEE3;
	Tue, 17 Jun 2025 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174288;
	bh=KkQsXmrUiw/7932r+05jz4Z6ANoSyxrh94LVLgjBMcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWAVizYNuQjtZ4mr4CPgCfyK/XYt1LAxYv/YVOD/0ozNyAJ6wG9MxG1DmNFHAORkQ
	 fUydEolk7hV5L9HuhcavigIlHUdI+YT9WI61cOmocEEG1EZij4ctZA4euGKSX6Qz9F
	 dlnAY0+3Fkpo/a8iuQtQG0riFDYwAF42NWebfQGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/356] ASoC: tas2764: Enable main IRQs
Date: Tue, 17 Jun 2025 17:22:35 +0200
Message-ID: <20250617152339.847201923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit dd50f0e38563f15819059c923bf142200453e003 ]

IRQ handling was added in commit dae191fb957f ("ASoC: tas2764: Add IRQ
handling") however that same commit masks all interrupts coming from
the chip. Unmask the "main" interrupts so that we can see and
deal with a number of errors including clock, voltage, and current.

Fixes: dae191fb957f ("ASoC: tas2764: Add IRQ handling")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250406-apple-codec-changes-v5-4-50a00ec850a3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 72d6356b89814..054c6f860675a 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -542,7 +542,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	tas2764_reset(tas2764);
 
 	if (tas2764->irq) {
-		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0xff);
+		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0x00);
 		if (ret < 0)
 			return ret;
 
-- 
2.39.5



