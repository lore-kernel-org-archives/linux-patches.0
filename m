Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F721DE3BF;
	Wed, 19 Mar 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395142; cv=none; b=ZorENde28yxiAniAHC8/iauvaA5t0UZDRn7TJhgIMhM7vj80EJhYGUX7M25q2IfhK/jfiytHJ2seS31i3e33pPfupKDXx2SpdJASf6A+br7weMpKdP6MjxPja40AeYRbnzAg95/fH5JmSXx1K8Usmhn4VbhIpL5dY/VyHTAoO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395142; c=relaxed/simple;
	bh=AcPRGL6MPLCKaJPeKb/HBIsQVuZwAenDgwKx3f2xK5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcht0c93aLbJcfKpYnYnnzF3V1zY2rlzx3akD/hZv79eBgrlBf2ap5vhyrNIPyX6raWlWWEDGHQdQYYumLMA7MX4OkkMyiUKUo+8eotgplxER+VIBOR7FnlTBWkgmjKSE5cGXlubdYILkwtEFLqgLkcr0qN13NHTTdRW3UQAzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL/nBj1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL/nBj1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2666C4CEE4;
	Wed, 19 Mar 2025 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395141;
	bh=AcPRGL6MPLCKaJPeKb/HBIsQVuZwAenDgwKx3f2xK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL/nBj1Ys6Pgxvc7s30B0E4W4z4w6VCvmImvSToC93CX9YOJy/RfxIC0wNq9ooY/q
	 I9b637tV5UQ9tg2PriI4/kT7ZMr/aE9CId2vySKOnICHcnAlTZUNayJyGR5aKEFUF3
	 d1rUKcLumlGqS+bfcZjfu/H4KPV+n0/Uk2OG/5fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/231] ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()
Date: Wed, 19 Mar 2025 07:31:42 -0700
Message-ID: <20250319143032.013129361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ed92bc5264c4357d4fca292c769ea9967cd3d3b6 ]

Free some resources in the error handling path of the probe, as already
done in the remove function.

Fixes: e3523e01869d ("ASoC: wm0010: Add initial wm0010 DSP driver")
Fixes: fd8b96574456 ("ASoC: wm0010: Clear IRQ as wake source and include missing header")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/5139ba1ab8c4c157ce04e56096a0f54a1683195c.1741549792.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm0010.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
index edd2cb185c42c..9e67fbfc2ccaf 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -920,7 +920,7 @@ static int wm0010_spi_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(wm0010->dev, "Failed to set IRQ %d as wake source: %d\n",
 			irq, ret);
-		return ret;
+		goto free_irq;
 	}
 
 	if (spi->max_speed_hz)
@@ -932,9 +932,18 @@ static int wm0010_spi_probe(struct spi_device *spi)
 				     &soc_component_dev_wm0010, wm0010_dai,
 				     ARRAY_SIZE(wm0010_dai));
 	if (ret < 0)
-		return ret;
+		goto disable_irq_wake;
 
 	return 0;
+
+disable_irq_wake:
+	irq_set_irq_wake(wm0010->irq, 0);
+
+free_irq:
+	if (wm0010->irq)
+		free_irq(wm0010->irq, wm0010);
+
+	return ret;
 }
 
 static void wm0010_spi_remove(struct spi_device *spi)
-- 
2.39.5



