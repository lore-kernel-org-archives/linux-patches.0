Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810401E522;
	Thu, 30 Jan 2025 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247291; cv=none; b=Wg0J8xQoVOO3JkI5IIdfPx6iLJeNMTBHq+49PYkPQeDN7PGhezyx/dwEIIidzI9skngrAljC5e1PPIWjzp1x71ZRqeFD4BsQpJB4GzUNEe+leNq2LRDvzcPcjOvoxrwymAG6isv0eDz9+726MyxntvXP8zgsURV3Mlf+2XpEmjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247291; c=relaxed/simple;
	bh=ouAfgo4k4j3CSmmlOu5K+UQWE2ECBlx6AmavgktZdY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzGVuE6huEO/SlVdbtYONohyqpWWvFJwRGXHcBm9c4S/yRd3BcrH0fQ8w1UWA0cE8HSgI21oDxeM48Dx27bhaQv/lLB60ygcSeBRbs0zicF7Fcr+JStXSyrLKnOgYWu2v9rK7xOZQSbEYLzTsF/yhwClRZVea2skss8w8nRidr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/WyZjhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/WyZjhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB72C4CED2;
	Thu, 30 Jan 2025 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247291;
	bh=ouAfgo4k4j3CSmmlOu5K+UQWE2ECBlx6AmavgktZdY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/WyZjhA6Dmu6otZsaGTeNgkuu59q0HJHpCvLhR2+J2vY4ZUw02Fp3WLvys9eqrJO
	 tqKjy1KIkTWd8bWc2IF1nMexeAvGc6+gQRIqs/C9n7coTDSVhpocc9yQX9Yec4FW14
	 9aYyzUU+oQgL4g9cseH4o1mE+L/zkjAJQgO3vhqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/24] ASoC: samsung: Add missing depends on I2C
Date: Thu, 30 Jan 2025 15:01:58 +0100
Message-ID: <20250130140127.551868625@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 159bc501186f9..c04c38d58804c 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -214,7 +214,7 @@ config SND_SOC_SAMSUNG_TM2_WM5110
 
 config SND_SOC_SAMSUNG_ARIES_WM8994
 	tristate "SoC I2S Audio support for WM8994 on Aries"
-	depends on SND_SOC_SAMSUNG && IIO && EXTCON
+	depends on SND_SOC_SAMSUNG && I2C && IIO && EXTCON
 	select SND_SOC_BT_SCO
 	select MFD_WM8994
 	select SND_SOC_WM8994
@@ -228,7 +228,7 @@ config SND_SOC_SAMSUNG_ARIES_WM8994
 
 config SND_SOC_SAMSUNG_MIDAS_WM1811
 	tristate "SoC I2S Audio support for Midas boards"
-	depends on SND_SOC_SAMSUNG
+	depends on SND_SOC_SAMSUNG && I2C
 	select SND_SAMSUNG_I2S
 	select MFD_WM8994
 	select SND_SOC_WM8994
-- 
2.39.5



