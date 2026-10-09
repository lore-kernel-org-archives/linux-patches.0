Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EC64E3252;
	Fri,  9 Oct 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555924; cv=none; b=t5VNUxTkgrrhSMX3CK91TNi8eMAfKjcyHgF2x0btvT3s53QAPdQsUoOT+/Qox97HfI0pUNcxaGWeo/NtDWh19dN7SzwFmKzq+GO3dJN4WDXJTtPeUH5nbQi3AzFrLI7VX8Bl58urATT2bhJ29wUcZlSLZ2CoHcgluP6ITf6AAgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555924; c=relaxed/simple;
	bh=IQManTD6upOiJAaHG05PnYH1mqiiYz6fqI8/ee5DwSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJ2wuipVpjRglvyD+YorFJ+wVMcGxzUtALqvylab9nzcw7UNV/pNI2Iwff5///6DxkBxXWfphqh0HIY/WMX+BVaBt2Khv5lzng1WqFH105qEEii5F5eQ8cfpGOCs5XaUpopFB/+9ughCuu1pzKuk7ean08Mu5ox1T0OkYQdxrmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p81JEj8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p81JEj8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0F1F00893;
	Fri,  9 Oct 2026 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555923;
	bh=lnUxzFjiIcXB6yft6ui892LJYrU16TaBQMcXYvrObKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p81JEj8dgfb5l2YhoYRYEZdGpWw2GKMFX8hJiQnHDexHp6C+SCwrWVAq6hXUcnH59
	 JqkyJXiYGIKDXxTOA8rjjFK8M7PXzGVGQyTXTefYz0t0felGo274HlFjP+iatqRlKn
	 YHlRV3MZ577sSkmgfYElmckCF3lg+7ubGZpduzOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 091/428] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Fri,  9 Oct 2026 16:07:08 +0200
Message-ID: <20261009140948.199022260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6eda8938a790f65bd24fcfaae7b40ad4613fb7a2 ]

As per specification, Sample Base Rate (bit 14)
shall be set to 1 for 44.1 kHz.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index f8c370106504c..3c47f1ae8db99 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -619,9 +619,11 @@ static int rt274_hw_params(struct snd_pcm_substream *substream,
 	unsigned int val = 0;
 	int d_len_code = 0, c_len_code = 0;
 
+	/* bit 14 Sample Rate Base, 0: 48kHz 1: 44.1kHz */
 	switch (params_rate(params)) {
-	/* bit 14 0:48K 1:44.1K */
 	case 44100:
+		val |= BIT(14);
+		break;
 	case 48000:
 		break;
 	default:
-- 
2.53.0



