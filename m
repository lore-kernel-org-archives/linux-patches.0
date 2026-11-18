Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017258;
	b=dUXUPmjbQpbxNDjyev9MyxDwA92RFVGGoV03ffD5osYOwZRsLYAqiUF4N2Ow/ddFx6qR
	 008Sf95e9T09OhS5fUK9qaruz7saiyPzT1/gbkoA2PKZX0T9pJK7Ke2q2IKTvh5Q8kvf1
	 6XUD/2XbtJgvwzc9/rmkpYjd+wpwHi52xC5yqXMXYt3OkkNla5pqJTaYUo7cuDOwhnCVW
	 404oSRjPhgboVun2NxoGesWmMm7iNRsXEtPDCfBWqfDeldmOPj0wkNjj+fqA2LurliCVG
	 UrSw80AkZ2bb3Kh6gTR8kyYgSwRohYxIwW3hGqugyF0llRgI8jnBSC8eTggLaDjwmOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXpAl5a0Y2feO0op1f4V4opMY9eMVirnj3iNpB0jU7Y=;
	b=446D8xWWINXE+LY6CbQrpRbXFDnuH9i6Ll0drgUvIJM9dOWuNqqLZESVVjM6LZXFMKsI
	 w49GZHWqDOXqu9poV1d++jqNl5VERaz7exVHE/kPUdgynL1Koa0WynKP8mV5F59iNJKOz
	 Z0r/npUto96KDOfRNNUyyxLYq+JFt6xa4A5rnWDd2+VDHp8Ssj0lg8iJuwG7Sra0ZnKi/
	 75Pjbl/ybieED/pUmtJmGNzi/ofNnrlm/9Ow9RingI3BNibzC3KDsa0/G/pxyp49EymU0
	 MLhDt1xUcldwvELwPw0DHzo8tVfCwR9oXOU7TCEDwoyFqiBxaYSlSaMeNAcpdD5V6Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2M5HBN4I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B0C606A320;
	Wed, 18 Nov 2026 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2M5HBN4I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48331F000C4;
	Wed, 18 Nov 2026 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017258;
	bh=JXpAl5a0Y2feO0op1f4V4opMY9eMVirnj3iNpB0jU7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2M5HBN4IZpLtzUtK38NAcgqW3zOfDgd/YEDvquGptW8iuB5g1x//pKrfDR1NeHywh
	 Ryx3uKSHlTlNssBmp29m7x7/c319DAIwxBpvATu45TzHlA6w8n/3wbd4gCAwGqOGCU
	 qPEgMCgOsWbMoea+FcVbsWYl77tpFknGadSetL58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0783/2651] ASoC: amd: acp: fix TAS2783 SoundWire codec unmet dependencies
Date: Wed, 18 Nov 2026 15:33:43 +0100
Message-ID: <20261118150316.077650083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit d06607bafb36abc14ed34c8adfb1239bebcd83d1 ]

SND_SOC_AMD_LEGACY_SDW_MACH unconditionally selects SND_SOC_TAS2783_SDW,
but that codec depends on SND_SOC_SDCA and EFI in addition to SOUNDWIRE.
An unconditional select force-enables the codec even when those
dependencies are not met, which the kernel test robot reported as unmet
direct dependencies when EFI=n:

  WARNING: unmet direct dependencies detected for SND_SOC_TAS2783_SDW
    Depends on [n]: SOUND [=y] && SND [=y] && SND_SOC [=y] &&
      SOUNDWIRE [=y] && SND_SOC_SDCA [=y] && EFI [=n]
    Selected by [y]:
    - SND_SOC_AMD_LEGACY_SDW_MACH [=y] && ...

The other SoundWire codecs selected by this machine driver only depend
on SOUNDWIRE, which the driver already depends on, so they select
cleanly.  SND_SOC_TAS2783_SDW is the only one that additionally needs
the SDCA core and EFI (it reads speaker calibration data from EFI
variables).

SND_SOC_SDCA cannot simply be selected here, as that introduces a
recursive Kconfig dependency (SOUNDWIRE depends on SND_SOC_SDCA_OPTIONAL,
whose default pulls in SND_SOC_SDCA), and EFI is a platform feature that
must not be selected by a driver.  Instead, guard the select with the
missing dependencies so the codec is only (and always) built when they
are satisfied:

  select SND_SOC_TAS2783_SDW if SND_SOC_SDCA && EFI

This keeps the TAS2783 SoundWire codec built together with the machine
driver on platforms that can use it, while avoiding the unmet dependency
when SND_SOC_SDCA or EFI is disabled.

Fixes: 28114992dd2f ("ASoC: amd: acp: enable TAS2783 and add RT712-VB SoundWire machine")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609182147.gfofWIXW-lkp@intel.com/
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Link: https://patch.msgid.link/20260924124205.3376083-1-syed.sabakareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/Kconfig b/sound/soc/amd/acp/Kconfig
index e880e44b9763f..6433876430f04 100644
--- a/sound/soc/amd/acp/Kconfig
+++ b/sound/soc/amd/acp/Kconfig
@@ -181,7 +181,7 @@ config SND_SOC_AMD_LEGACY_SDW_MACH
 	select SND_SOC_RT715_SDW
 	select SND_SOC_RT715_SDCA_SDW
 	select SND_SOC_RT722_SDCA_SDW
-	select SND_SOC_TAS2783_SDW
+	select SND_SOC_TAS2783_SDW if SND_SOC_SDCA && EFI
 	help
 	  This option enables Legacy(No DSP) sound card support for SoundWire
 	  enabled AMD platforms along with ACP PDM controller.
-- 
2.53.0



