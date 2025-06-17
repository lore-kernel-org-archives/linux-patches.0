Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE918A6AE;
	Tue, 17 Jun 2025 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174580; cv=none; b=tf3YZXHljHwA0VMGxZ4NQl9ZO4IZdROL46Ku5C8FEvkFGNoR7IZldGFBQ87QpuuZdyyAU3dYPbKeNddQsIr0PnTGIryfnBovSgD74wJhID+wwjrfiOodF/MZLYUYQmz+G/yHE0UYNxudXBQKOPce0aE69HqpC5TZpGIeY/Gt1dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174580; c=relaxed/simple;
	bh=9AogUGnM62OCn5ULMiGpJCVLfHpSG+rQH5YRCu77xPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHaDYBUfmBjA8RdhNA8DIQt9OYtjlfBnn+hdvCsO+n6OYv0Fewf3xmXdpV+1wk8enH881AieP4DzN7fMjiHLpEp7nysSOXKQTlsuhiWAbekHV0cGTG16cdz48Tx2HNJfjLt0+Mc4tSxtQMGzyyqsPIMK9MDtAulf02eQg17cX/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHrxiQGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHrxiQGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0B6C4CEE3;
	Tue, 17 Jun 2025 15:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174580;
	bh=9AogUGnM62OCn5ULMiGpJCVLfHpSG+rQH5YRCu77xPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHrxiQGPuLqgOOayQHM/yTqdQM9vrSKfvry+61YXrQihKDfegWDdSpc0N2u6ZrzPX
	 4hscWuEFSbnJqJsLx/neaspl9wsQkxd7eMVF/5a+ViqIAlGphEBNhAUFqMSibB3M3n
	 zna7xrKB0Im4FqczcgugZjxOCLVuKdMfIuomqTtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/512] ASoC: tas2764: Enable main IRQs
Date: Tue, 17 Jun 2025 17:20:04 +0200
Message-ID: <20250617152421.093456061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 39a7d39536fe6..4326555aac032 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -540,7 +540,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	tas2764_reset(tas2764);
 
 	if (tas2764->irq) {
-		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0xff);
+		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0x00);
 		if (ret < 0)
 			return ret;
 
-- 
2.39.5



