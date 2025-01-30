Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0A1E98E7;
	Thu, 30 Jan 2025 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245754; cv=none; b=VHcTYS9d89if/2+8KvBog7n0LcU/9sFuEV/EtFHEyjrckONT7SUqDUZHkOuyzEUQcJDzo4GWb8/Agb4shZQ1z+J+aywQU4lmsi8xMKk4ci4i9QB0nX7IrBu/ZbXB6RxKyDTf7XfHdveNdWcGcqwX0tb8Y/uVR0AY3AjnIvuC+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245754; c=relaxed/simple;
	bh=CNSH61maOtbT+52trt429CJ9p150lM1fQwuajq1Rw3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9Gv86I7OZ0bRHrdzuAqdWXAt9HX/wVjqtFI4fjLuCRdrm8l9nQ456EvwFWpY3jWrDVh8mzdVHl6LAqWNCjKmp8LFc7wm5H8DzWFZHmrU/BOuCy4Dkb0GsvFT/y/HpipRmPBbBw84MTRbx2vW51Bui/aZCi96VsbJcuUMtRI9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgYZMGcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgYZMGcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64203C4CED2;
	Thu, 30 Jan 2025 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245754;
	bh=CNSH61maOtbT+52trt429CJ9p150lM1fQwuajq1Rw3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgYZMGcSdb0mTQeAL9lVWwMqkgf+1V+OKV+WHqM29UJMzR4LV2I1PP+ak7MZgDXid
	 Eaiu37kBKNA2j0Vq88q5sFPfvx+L5vDOKVsQAXW+4Rs9v+tQpbPlqf/2qY5Gz7iZAb
	 SzpYe26KzhEPahBwoKEGvalPVbm10cpOZM39Zses=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/43] ASoC: wm8994: Add depends on MFD core
Date: Thu, 30 Jan 2025 14:59:08 +0100
Message-ID: <20250130133458.963913232@linuxfoundation.org>
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

[ Upstream commit 5ed01155cea69801f1f0c908954a56a5a3474bed ]

The ASoC driver should not be used without the MFD component. This was
causing randconfig issues with regmap IRQ which is selected by the MFD
part of the wm8994 driver.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501061337.R0DlBUoD-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250106154639.3999553-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f1e1dbc509f6e..6d105a23c8284 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -2209,6 +2209,7 @@ config SND_SOC_WM8993
 
 config SND_SOC_WM8994
 	tristate
+	depends on MFD_WM8994
 
 config SND_SOC_WM8995
 	tristate
-- 
2.39.5



