Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B8611C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88CAC433C7;
	Mon, 28 Aug 2023 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218190;
	bh=jMHoe6+51Hq1FIXHacKKX5i0+7fuV+H0V/ozH9Xhwr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUJgLpLjxe2gHEegsk9IsXz7DTRIqhgU0p988pHGjv/aDY8HfoGP0/ZnIL7qnv85h
	 4GqEQlmJLEL6OxpSSDu5BR7CULUcfEJP8sw48E/KFuaHiPjC14UEFptRfDABIhkC0Q
	 SvC6hWs3kB96wfndjmuBcU0KOSVA1Kykdya35LO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 127/129] ASoC: amd: vangogh: select CONFIG_SND_AMD_ACP_CONFIG
Date: Mon, 28 Aug 2023 12:13:26 +0200
Message-ID: <20230828101201.697006745@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit fd0a7ec379dbf21b7bfd81914381ae5281706ef5 upstream.

The vangogh driver just gained a link time dependency that now causes
randconfig builds to fail:

x86_64-linux-ld: sound/soc/amd/vangogh/pci-acp5x.o: in function `snd_acp5x_probe':
pci-acp5x.c:(.text+0xbb): undefined reference to `snd_amd_acp_find_config'

Fixes: e89f45edb747e ("ASoC: amd: vangogh: Add check for acp config flags in vangogh platform")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230605085839.2157268-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/amd/Kconfig
+++ b/sound/soc/amd/Kconfig
@@ -71,6 +71,7 @@ config SND_SOC_AMD_RENOIR_MACH
 config SND_SOC_AMD_ACP5x
 	tristate "AMD Audio Coprocessor-v5.x I2S support"
 	depends on X86 && PCI
+	select SND_AMD_ACP_CONFIG
 	help
 	 This option enables ACP v5.x support on AMD platform
 


