Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E8A94A;
	Tue,  8 Apr 2025 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113861; cv=none; b=UChXXjLBtomRmpShwdZOpUQFd+BjZ8gHYGhkQjkmFLBMftCa5dd/ceUL8W9DtiQNAFyV83YXlOLRUtMyaSdog/cd3ohyL14QFDymTl/zzgDtCR8RvAQIcQdU2LLIkegG5zESXMzA2e4vd0phUN/i84fReRaXUjzxfKmXyzhMlCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113861; c=relaxed/simple;
	bh=PqOaQ74/hLUVzvLFfg0PHb+P7PiIcvf6aXquz/ovKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGOWGBXhukCzxkDNj0N8Fa3+YcYDLqb4Czf0uCaxDQpOlQ4aLIwkYM7pqSghQd9SezOK4IQiokKpQsYluYHhoiii8NOvkjM3UF4GdYh2S+Pych6Dpls35caz4WLgkeOuU37+Hh3LI3YfuQA87hzmls0tt9dp4GNqWdBUaAz3Gog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8xBIsyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8xBIsyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BC4C4CEE5;
	Tue,  8 Apr 2025 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113860;
	bh=PqOaQ74/hLUVzvLFfg0PHb+P7PiIcvf6aXquz/ovKpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8xBIsyJdoN/32bPOv4Qruu81sPcWC9F9N/DbAtBIGuR7CIINmRYSfLVe0cKAXsOx
	 bD8mGIDnkm/PW8HvJ0f7Rvc6shWYZeFp7UUcACANgJccUO04iya+Yoh2fHnXT20rlH
	 0ceCYOyIxvyW+5BuXBBd2YsS5baSS5ufJPVptZP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/154] ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104816.784047158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 727d6703c905a..ff4bd7d5c59e5 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -955,7 +955,7 @@ static int wm0010_spi_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(wm0010->dev, "Failed to set IRQ %d as wake source: %d\n",
 			irq, ret);
-		return ret;
+		goto free_irq;
 	}
 
 	if (spi->max_speed_hz)
@@ -967,9 +967,18 @@ static int wm0010_spi_probe(struct spi_device *spi)
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
 
 static int wm0010_spi_remove(struct spi_device *spi)
-- 
2.39.5



