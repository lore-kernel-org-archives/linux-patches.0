Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743171E9B17;
	Thu, 30 Jan 2025 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246504; cv=none; b=qXM6Ys1QbJmTQqWn+VzP8t6CZyyGdcQGyKRlHSIQ3xu6vb6YiARYiTihe5rjEE+t3qiRUJ5e7WZ4jw8nvyeveV7yBDdYHRnaMXyH9mbXhmTba6B+Iaty+QqXaPV3NhZbpcj9toZwVV8pjfssaTQBHmOXyUncBg+dJRfpYRSgU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246504; c=relaxed/simple;
	bh=kpDbO71tfKWgArVDFriL2lpe8yTMzgqWbOo3AJT/52Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SukAn/LhB1Atjp5RHMEJBhqZf3t32913nAePONsTHHOZg696g+ZyUie5GXcSjqQJEtPxNF563stvvB9XA5lyxIzcnF/IYjO6RljOJqnlodRo9SOAKeGuN8V8mkxHjspW4KgKPS6IKaoH5aWYmcnJLwZaY5eqMh08z64ZRsLO3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fkcoxn4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fkcoxn4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83AAC4CED2;
	Thu, 30 Jan 2025 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246504;
	bh=kpDbO71tfKWgArVDFriL2lpe8yTMzgqWbOo3AJT/52Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fkcoxn4/XqS1jmNhkcLJOGvbWBLjAgHVbyf58IhOO3shwrkqPagLYHiyCfKOvj67i
	 6AAv59LC53A8VfoIowSxrKyu65Hc2AG+rcunX/eWA5xL9XmLgcse0n0MA+sOsMqOLD
	 hCCGYJT0z7SYqRnWNWk4w2RMGJ5V9RNAVvDrZvF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/43] ASoC: samsung: Add missing selects for MFD_WM8994
Date: Thu, 30 Jan 2025 14:59:09 +0100
Message-ID: <20250130133459.001819630@linuxfoundation.org>
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

[ Upstream commit fd55c6065bec5268740e944a1800e6fad00974d9 ]

Anything selecting SND_SOC_WM8994 should also select MFD_WM8994, as
SND_SOC_WM8994 does not automatically do so. Add the missing selects.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501071530.UwIXs7OL-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250107104134.12147-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 93c2b1b08d0a6..77d3beea1d715 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -127,8 +127,9 @@ config SND_SOC_SAMSUNG_TM2_WM5110
 
 config SND_SOC_SAMSUNG_ARIES_WM8994
 	tristate "SoC I2S Audio support for WM8994 on Aries"
-	depends on SND_SOC_SAMSUNG && MFD_WM8994 && IIO && EXTCON
+	depends on SND_SOC_SAMSUNG && IIO && EXTCON
 	select SND_SOC_BT_SCO
+	select MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_I2S
 	help
@@ -142,6 +143,7 @@ config SND_SOC_SAMSUNG_MIDAS_WM1811
 	tristate "SoC I2S Audio support for Midas boards"
 	depends on SND_SOC_SAMSUNG
 	select SND_SAMSUNG_I2S
+	select MFD_WM8994
 	select SND_SOC_WM8994
 	help
 	  Say Y if you want to add support for SoC audio on the Midas boards.
-- 
2.39.5



