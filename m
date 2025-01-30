Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61F6C13D;
	Thu, 30 Jan 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245650; cv=none; b=I4mrQtTWNNxA2jUONvBaZibPnAnpo3Xlhdd0gZXivkHKOgezmSfyg/DoHBLN1bbOxzYo+bIw5i9wYo/jtQadf5UM1cNk0eh2S1Vv4NXpkpe1WD5JI52/heuAnZox7FWJKe362tap5J7I+yuwwK/7vst772yPc6UmZJ2GkgziA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245650; c=relaxed/simple;
	bh=hUjhuZN4yBJJwrFee//X8yp85555ywD6JycqsD2sddg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9F5M1+YuBx12+l3WA0Q67k1GvfJjHs9PoDZCn8tW7J8508aZzCtjLIqbZcTCiT56B1uImUI2ZE8f5WtUYdUR2MgpCHx/+wJd7Ziq4VD/UDZFOvk+EolK4vGOblkaV1KlVnPcKzMOSgr/mou4nveYsN88KqUb/+CNUZGaq1syBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OQWU+m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OQWU+m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD99C4CED2;
	Thu, 30 Jan 2025 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245650;
	bh=hUjhuZN4yBJJwrFee//X8yp85555ywD6JycqsD2sddg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OQWU+m6X7DJcREjW6ZzZ/RWvANCn8lO8CatNT3ShdBKzpXZTAg/e6jV/by8p2DDE
	 3Hznu9fbHdXfzvJitiCb7VSrCjJexIPSTi1p94MzSjpL0D4bhHZrMk0IMYRu8O2L/g
	 EzUtWu/E4h4nbK46CJbVe9IupinzTk9OlHJEmCdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 14/40] ASoC: samsung: Add missing depends on I2C
Date: Thu, 30 Jan 2025 14:59:14 +0100
Message-ID: <20250130133500.284018481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 704dbe97a68153a84319ad63f526e12ba868b88e ]

When switching to selects for MFD_WM8994 a dependency should have also
been added for I2C, as the dependency on MFD_WM8994 will not be
considered by the select.

Fixes: fd55c6065bec ("ASoC: samsung: Add missing selects for MFD_WM8994")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501082020.2bpGGVTW-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250108134828.246570-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 1a05f0e7078d3..60b4b7b752155 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -127,7 +127,7 @@ config SND_SOC_SAMSUNG_TM2_WM5110
 
 config SND_SOC_SAMSUNG_ARIES_WM8994
 	tristate "SoC I2S Audio support for WM8994 on Aries"
-	depends on SND_SOC_SAMSUNG && IIO && EXTCON
+	depends on SND_SOC_SAMSUNG && I2C && IIO && EXTCON
 	select SND_SOC_BT_SCO
 	select MFD_WM8994
 	select SND_SOC_WM8994
@@ -141,7 +141,7 @@ config SND_SOC_SAMSUNG_ARIES_WM8994
 
 config SND_SOC_SAMSUNG_MIDAS_WM1811
 	tristate "SoC I2S Audio support for Midas boards"
-	depends on SND_SOC_SAMSUNG && IIO
+	depends on SND_SOC_SAMSUNG && I2C && IIO
 	select SND_SAMSUNG_I2S
 	select MFD_WM8994
 	select SND_SOC_WM8994
-- 
2.39.5



