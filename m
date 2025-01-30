Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527219DFAB;
	Thu, 30 Jan 2025 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246525; cv=none; b=AoG/fYkf4ruioIv3mynnkOqnmuGPaVdaMJXvXsnNFnld46sLYPTCJZ2dQF0XTR3Ucf1Lz9fjOXYuBOIQ0N413ZZ0gTSgobTftki1TOQc2e+09vZkwTOkmOIP304aaYMMddMa1wIaRjVKS+cJ0o+bTTYpMhbLTgWoBNQybv8MU4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246525; c=relaxed/simple;
	bh=R4PhMDgMyIi/F/7GW5u+9BzI9gAoEbFO0GFgc+OjPjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qqyt2pTx9tcWomqtDCu5YdF2L/+lAfKwk0kokD4s9lQpWfi6Zr/0j6YWS1KYc2/oUetHQ0qyuFucoVFUMx6zhadFmjdB+EmgFaK0Wl5A+TGEK7BHZ98mgO+G5IwaTTUoyBfM48sHW3EAmRX2eOj9bfqcEQ4HgkXOTgUAw3bdThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1kxhPXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1kxhPXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A5C4CED2;
	Thu, 30 Jan 2025 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246525;
	bh=R4PhMDgMyIi/F/7GW5u+9BzI9gAoEbFO0GFgc+OjPjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1kxhPXc9KFrWwSkNvKKlckCEizD/aQu/DNRXkynN0ok6Ql9JlLveyZ6ofQfriKJ3
	 sSImZzb5GCZ22aSwIutqKCequgoih011JTzf0A2Z/19WF9dupww5080CbuRFUrjqzR
	 C1Q7cAs1jLuwHjcLvEydy3QZQL90yA9aDjMQa0J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/43] ASoC: samsung: Add missing depends on I2C
Date: Thu, 30 Jan 2025 14:59:16 +0100
Message-ID: <20250130133459.274282348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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
index 77d3beea1d715..e8716501685bc 100644
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
-	depends on SND_SOC_SAMSUNG
+	depends on SND_SOC_SAMSUNG && I2C
 	select SND_SAMSUNG_I2S
 	select MFD_WM8994
 	select SND_SOC_WM8994
-- 
2.39.5



