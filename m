Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D5D38BCE
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrJa/wTf";
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOFAHyuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FDAC433C7
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698424065;
	bh=LySMjcb5ZeZeBpmsv8KiI7rJYVEnv2CzkA7+tr3Fe3Y=;
	h=Resent-From:Resent-Date:Resent-To:From:To:Cc:Date:In-Reply-To:
	 References:Subject:From;
	b=OrJa/wTf9a5iSeXYgkUxJknA9RAbM2SNSrp4pXvKj/HxenTjmUn2mVA3vMfQJJTvC
	 Ay7ir1a2ajlarnAwW9pPZTLD7mCGUGOKPD7tsrjWfx+xvw1ahLPR8lMdyQNve6sRnu
	 heDG+ZwzJtYxkCfbFXO7xVjIpIOyfnrkgoNgAXXUp0Z5jsT9CtaQKBiEjB6b1S8bdO
	 pcdQm4MH9+T222K6RPLgqVI2rLCv0UgfpBcAVRlczzOZfnwnwVavknn85ro1zpwC6U
	 JNZYvLxETNyt4mcu2U2d1YNmvtRA9vgyjO+D4CyG15E/cKOgURoVOAedikhdCby2rR
	 ssOOesDbuKBpQ==
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 27 Oct 2023 17:27:42 +0100
Resent-Message-ID: <ZTvk/uNIU5YGLEz/@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 27 Oct 2023 16:24:45 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <arnd@kernel.org>)
	id 1qwOhX-00FfFj-80
	for broonie@sirena.co.uk; Fri, 27 Oct 2023 16:24:45 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by ams.source.kernel.org (Postfix) with ESMTP id 0CACDB81CEC
	for <broonie@sirena.co.uk>; Fri, 27 Oct 2023 15:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7B889C433CA; Fri, 27 Oct 2023 15:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE1DC433C7;
	Fri, 27 Oct 2023 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698420282;
	bh=LySMjcb5ZeZeBpmsv8KiI7rJYVEnv2CzkA7+tr3Fe3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOFAHyuMJHa0w0v+mSF7AQWZxIU3NmIl8RsBWMGuDwWcZy9B8b8UNe4tmPw/i4Pl5
	 bUci/EC3MAknaR6atH0pZEpvzlwaH7koG3cEal/5B0DMuFCPrYbMkQtpuRB2ZDJgJS
	 3qVumWhfiJoxFZIoL++wdnqmzW7m5p8Ankx22pPBt09xwjiCc5im/rnVPzHbMZE3Jq
	 bVZPybOIt6SKFlu2Ds6M31qxlZqONIMD1ColxfQgPciM+kdk4SgHB28wmsnt7Cb66d
	 +1vxS1N9OL2azizro0pZVinPYa8nBt1Cw9AF9wCmUssk3oYqaHgO1YwHJleme0MrTj
	 E2Db/6JU13SEg==
From: Arnd Bergmann <arnd@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 27 Oct 2023 17:23:54 +0200
Message-Id: <20231027152403.386257-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231027152403.386257-1-arnd@kernel.org>
References: <20231027152403.386257-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: arnd@kernel.org
Subject: [PATCH 3/3] ASoC: amd: acp: select SND_SOC_AMD_ACP_LEGACY_COMMON for ACP63
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: M1U8CeHBrm0o

From: Arnd Bergmann <arnd@arndb.de>

Without this dependency, acp63 fails to link:

x86_64-linux-ld: sound/soc/amd/acp/acp63.o: in function `acp63_audio_remove':
acp63.c:(.text+0x22): undefined reference to `acp_disable_interrupts'
x86_64-linux-ld: sound/soc/amd/acp/acp63.o: in function `acp63_i2s_master_clock_generate.isra.0':
acp63.c:(.text+0x6f): undefined reference to `smn_read'
x86_64-linux-ld: acp63.c:(.text+0x81): undefined reference to `smn_write'
x86_64-linux-ld: acp63.c:(.text+0x8e): undefined reference to `smn_read'
x86_64-linux-ld: sound/soc/amd/acp/acp63.o: in function `acp63_pcm_resume':
acp63.c:(.text+0x230): undefined reference to `restore_acp_i2s_params'
x86_64-linux-ld: acp63.c:(.text+0x23d): undefined reference to `restore_acp_pdm_params'
x86_64-linux-ld: sound/soc/amd/acp/acp63.o: in function `acp63_audio_probe':
acp63.c:(.text+0x474): undefined reference to `acp_enable_interrupts'

Fixes: d4c2d5391d7e ("ASoC: amd: acp: add Kconfig options for acp6.3 based platform driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Note that the original Kconfig entry is also whitespace-damaged, which I'm
fixing in the same patch, as it didn't seem worth having two commits for
the same few lines.
---
 sound/soc/amd/acp/Kconfig | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/sound/soc/amd/acp/Kconfig b/sound/soc/amd/acp/Kconfig
index b0e4d5117b81..5fb322212938 100644
--- a/sound/soc/amd/acp/Kconfig
+++ b/sound/soc/amd/acp/Kconfig
@@ -61,15 +61,17 @@ config SND_AMD_ASOC_REMBRANDT
 	  If unsure select "N".
 
 config SND_AMD_ASOC_ACP63
-        tristate "AMD ACP ASOC ACP6.3 Support"
-        select SND_SOC_AMD_ACP_PCM
-        select SND_SOC_AMD_ACP_I2S
-        select SND_SOC_AMD_ACP_PDM
-        depends on X86 && PCI
-        help
-          This option enables Acp6.3 I2S support on AMD platform.
-          Say Y if you want to enable AUDIO on ACP6.3
-          If unsure select "N".
+	tristate "AMD ACP ASOC ACP6.3 Support"
+	depends on X86 && PCI
+	depends on ACPI
+	select SND_SOC_AMD_ACP_PCM
+	select SND_SOC_AMD_ACP_I2S
+	select SND_SOC_AMD_ACP_PDM
+	select SND_SOC_AMD_ACP_LEGACY_COMMON
+	help
+	  This option enables Acp6.3 I2S support on AMD platform.
+	  Say Y if you want to enable AUDIO on ACP6.3
+	  If unsure select "N".
 
 config SND_SOC_AMD_MACH_COMMON
 	tristate
-- 
2.39.2

