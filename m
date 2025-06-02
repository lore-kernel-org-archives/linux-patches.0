Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C337D226188;
	Mon,  2 Jun 2025 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873711; cv=none; b=IPPZRxSLBylCx+CcpWrrnnuSiftat/02VSn0X7cktV689LY4RUACWyi1ML18vM8dfKZOoTxF3lAkhXpapX++bXsjJK24N0//dxm+yPueX6P1Tlf+fgcgt7Obfwn5T7cQj4W6HDTHdgl5lFTzUE5ljeDRHhyL0sB/DK+d0qhs6vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873711; c=relaxed/simple;
	bh=3qI/bxCjNYp78Uz2LxFo0QUQPj3IjB201GhasOws+Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l19kGbkWmOIj0HSO+G6d11lq8ssj5sXWVSzJ9JQg/f644gzbEEyoPP4omrX7awgJxuLxthcObwI6z8myQ39ihjZcZoAzWwdv8UK/noOfSBRE9yXn0qxy7+zVElTct+rnGYVrg8ioT6x7Ax43mhMZcFoVk+FdKApjvsQiD4GRGQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYEXQU8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYEXQU8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFFFC4CEEB;
	Mon,  2 Jun 2025 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873711;
	bh=3qI/bxCjNYp78Uz2LxFo0QUQPj3IjB201GhasOws+Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYEXQU8ixLwI0Xc3PekMfNCpBMPG4U6RkWGcAcGr5owYbLAQALcaSG5YcCvKwEYlN
	 Fiawgf+XsHOGzeO1Qn6jgLLGQqdHhin0U8ehmGifuevwodGvjo0bhG8jmQ/mZcSB52
	 Mm19TPdSG39LGcADcMFzMWYz6vXGfd4JFlU8bJjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/444] ASoC: tas2764: Mark SW_RESET as volatile
Date: Mon,  2 Jun 2025 15:44:50 +0200
Message-ID: <20250602134350.088143555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

[ Upstream commit f37f1748564ac51d32f7588bd7bfc99913ccab8e ]

Since the bit is self-clearing.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-3-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 4e5381c07f504..3f622d629f77a 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -654,6 +654,7 @@ static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
 static bool tas2764_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case TAS2764_SW_RST:
 	case TAS2764_INT_LTCH0 ... TAS2764_INT_LTCH4:
 	case TAS2764_INT_CLK_CFG:
 		return true;
-- 
2.39.5



