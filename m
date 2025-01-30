Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F71E522;
	Thu, 30 Jan 2025 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247213; cv=none; b=ePVUyzdsHu29M+Vxl0lntdwnfl5n9nCEIIsRtTSu9h5V4W8vZupz85t1FVFGMx+GXhw4p/ovx+oxjvG9qAp3h+T4Om/rGRoxfxBxmZzlgHkzhtzAfVdJFa6mGBcSzTlqOuZEBOZdY5EN8HZOIM1OP9c3tGN4bICoH7rBSSMWhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247213; c=relaxed/simple;
	bh=XpmDTMTt5XrnD4OFUIgf8JgIXVtIh08kIxElXcDdjKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgbRLXUByHLjRm/+eCuixCQlYje9mJJQquGNLP3KBGqdWy2NckulGzVo+deMc/g6DywOsmX5t9rwV3gRu1cQHVl/ydgPe3uEdAdMQG1CDqj4S695tygcxHbb6qUwgGq6zfyfCoifOQYsxLlvmDIbSIFbxcL1+69K6Ohus5qFvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfZqUmKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfZqUmKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A08C4CED2;
	Thu, 30 Jan 2025 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247212;
	bh=XpmDTMTt5XrnD4OFUIgf8JgIXVtIh08kIxElXcDdjKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfZqUmKJCqx32IDJNrY4GvOeqtu0XvqzYduOrR1wfURbIbiwl5eFywRtTocxjIG9o
	 r7UpoE7shC2cacm2XdIXm2COqLn9JtuQ5oBzCNV+a/TiDbPQC6oSyo/RsZkXfulcsA
	 3fmp0bV3KTfHVgn67XoB68KrYDERb54ZF9iIPXxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/133] ASoC: samsung: Add missing depends on I2C
Date: Thu, 30 Jan 2025 15:01:49 +0100
Message-ID: <20250130140147.359885641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



