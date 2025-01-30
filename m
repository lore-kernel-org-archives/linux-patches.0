Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A721E522;
	Thu, 30 Jan 2025 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247280; cv=none; b=VzvwoHSINwQJQmlMsvGc2d3T76cdTU9W5uFgZ56y0UX04pLSL7lF2exrZywwfyPPBQz4xvPo0PefgtKaYQz7tg+yPl+/nbrXd/vUHZHCXEzBdGz7nplzturhIin5WCk3UFOtlzzjcGfPfmmEze+EApqQ4hAC9L9SrQ4pcNHKDBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247280; c=relaxed/simple;
	bh=DRQ0SJD+Xl4EShedzHaL/k27CBi9+NPPc2WkRnkbtfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJWFoFutNRJCyGCTVvSOhFk/UXDNd9qFg0vXFpQNGWajEOstaUPg64+JtWfFwuh7bSMd6a2/LKIij6loExnn6x9XZSJndPXleOB674GU3xr2gat63oZUOIeFng1nMuZy1EPwz4R+HICJ32Mth/PccinBguadQ5RB6AmEBq2ZlSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xktf92dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xktf92dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B02FC4CEE0;
	Thu, 30 Jan 2025 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247279;
	bh=DRQ0SJD+Xl4EShedzHaL/k27CBi9+NPPc2WkRnkbtfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xktf92dhtwjtA3x5M7AgWRkeCTI/DUIJYr02ZoiTyCk63SvPBmlk77FcJq8x6S4pv
	 r0gRCNpzgvsXRuQLdC0qqFnQZVinP48jB2V5Nvr3330IA+0L+CKNTmicaVxktCRcew
	 M21ON1g8po27McU1FBGP4OBKOCOoV9SHRZd2yQ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/24] ASoC: samsung: Add missing selects for MFD_WM8994
Date: Thu, 30 Jan 2025 15:01:54 +0100
Message-ID: <20250130140127.394359555@linuxfoundation.org>
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
index a2221ebb1b6ab..159bc501186f9 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -214,8 +214,9 @@ config SND_SOC_SAMSUNG_TM2_WM5110
 
 config SND_SOC_SAMSUNG_ARIES_WM8994
 	tristate "SoC I2S Audio support for WM8994 on Aries"
-	depends on SND_SOC_SAMSUNG && MFD_WM8994 && IIO && EXTCON
+	depends on SND_SOC_SAMSUNG && IIO && EXTCON
 	select SND_SOC_BT_SCO
+	select MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_I2S
 	help
@@ -229,6 +230,7 @@ config SND_SOC_SAMSUNG_MIDAS_WM1811
 	tristate "SoC I2S Audio support for Midas boards"
 	depends on SND_SOC_SAMSUNG
 	select SND_SAMSUNG_I2S
+	select MFD_WM8994
 	select SND_SOC_WM8994
 	help
 	  Say Y if you want to add support for SoC audio on the Midas boards.
-- 
2.39.5



