Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D92F235D;
	Tue, 17 Jun 2025 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175329; cv=none; b=hchdWMqyly/lOxcZCF10klNun803ima0gB9nGu1UqZTGnLBqUQRNYdeJlaP4IaxCpilc+yycAFRy5DYMvOvjGbTKGSBnd2K03DRrF3PJWdZU24D0zT14uY0r2b1I3ntYk/mV8OjHPNOArKmUXY/GKF+MNj25yvmS31m6J1KvrbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175329; c=relaxed/simple;
	bh=IwIYY3wrygYNJmYdNDlQ+20ylnVssXf4ugT5lp4tGPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBwbGJr+44jnWniYxFZ0MTZApUEamDcuVhMHQ8hVaEwAZyIa7kB0SVwY4GX9nmVDcBSMftNIqywqztRxgoLqevPv1AECGhlFp+iZvtUTAGs2MeA8QI4GpgFpQRkTwLVEI+uZWo6Zlnkg6VMq1wLbNq8mugO8PDfj69ocHwTl/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8ZQD0yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8ZQD0yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6089C4CEE7;
	Tue, 17 Jun 2025 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175329;
	bh=IwIYY3wrygYNJmYdNDlQ+20ylnVssXf4ugT5lp4tGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8ZQD0ypzyV/aWu0bhURyXeiBDAREhg67CyvqRLHgrL7s5QGilwiFRRvlQfX3jtYB
	 qvwFH+gq7cOnp3geyjgG1Q6VWSkulUkjD3CsaOOTfU4B3SoXvQlM39jpC2h1aDzDah
	 DjmYge9h1TYk+x1ZUX6GxIHt9V/Q75+LCUWkq3vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 056/780] ASoC: tas2764: Enable main IRQs
Date: Tue, 17 Jun 2025 17:16:04 +0200
Message-ID: <20250617152453.783284790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 49b73b74b2d9d..fbfe4d032df7b 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -564,7 +564,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	regmap_reinit_cache(tas2764->regmap, &tas2764_i2c_regmap);
 
 	if (tas2764->irq) {
-		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0xff);
+		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0x00);
 		if (ret < 0)
 			return ret;
 
-- 
2.39.5



