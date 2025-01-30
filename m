Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F811E522;
	Thu, 30 Jan 2025 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247198; cv=none; b=C5WSpgttbU7UIIXcQ46MAE3EzePDAP/e7Aasjphm0zekwnBWP0xcWVT5zXaBo9hg8DrAU4nGgzlArrzuA5dMNUJ+4TyVR9w/VEN/aaNhT83OfzMb3AwIWx9U8bapXUyOeaNQO1i5rfAAa696H6UZwhsMAkkSOfOaPG6dXxCEhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247198; c=relaxed/simple;
	bh=uSSSKHEo1Uqpzh4UNinWksXl8qryvjgei/IL3d0tj4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgjQsYyvsiyXv0ojgXuOHAq07a2f1ZNtLqvjxfcQhYilHw2coxgMTKwWo7EZbCvNXdqlb3WCaqb/OQs+oV0ZCs1vXxYRTNRtMsEpoWBO32XR8cV91cjHEFInIxtunYZnwAcimEAToG5zTSG9HzAkxgszHkQWmdTr6Qc85N7o2zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLQB3M9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLQB3M9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529EC4CED2;
	Thu, 30 Jan 2025 14:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247197;
	bh=uSSSKHEo1Uqpzh4UNinWksXl8qryvjgei/IL3d0tj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLQB3M9C8tcNWCRpXhzXaW+ggH1+S5uK+DZC5zP9BpFFsWoSHqGfF/gKAtc3h5QuX
	 Hfm0Vcky9fq20qMYQwO/F9JxTCMPzqEOVIlPW/GDkG4afUhgOBS42dWI4UMoTLtdQm
	 CT8/3KGgwk3sWxE32+xPUAtc4kOI+OvTT1dBcfA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/133] ASoC: wm8994: Add depends on MFD core
Date: Thu, 30 Jan 2025 15:01:44 +0100
Message-ID: <20250130140147.162985043@linuxfoundation.org>
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
index a8b9eb6ce2ea8..18131ad99c6da 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1647,6 +1647,7 @@ config SND_SOC_WM8993
 
 config SND_SOC_WM8994
 	tristate
+	depends on MFD_WM8994
 
 config SND_SOC_WM8995
 	tristate
-- 
2.39.5



