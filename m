Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F408638BCE
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apOMbx2I";
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kR7uDf06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1922BC433C7
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698424061;
	bh=ZIhEUto7Ie2F1PnCeV7zW6ioXwNxMy5PW9CRsJ9ceaM=;
	h=Resent-From:Resent-Date:Resent-To:From:To:Cc:Date:In-Reply-To:
	 References:Subject:From;
	b=apOMbx2IMgv9XRn974vegRClvwRjzhwaXvjSnGFmXhQpuhh5XsutyAxJoIuhN1Pjk
	 5TWhh07xGSLaYsq2nWs2ioYPB1Ad1VkQ1E7lXivRTgDVWDzginGQbqiSDVP7FgX7ac
	 V+/j8A3fwajwEu4LEThjOMjyJFXhTgAETMegQ857XmLq8Z5qLS6qjajlLQrJXVnXNW
	 FVHvHrE8P8i8tPud9t06PIZG0kEmFI+fjjenukv6xH2CUzIQ/d5icmWdlPXw0H+jeA
	 fagsy33vRo/pCFCtOAKuYacg/33tvQJLZCy3/pUBbHNPODsq71I5TEnYUMMP2xdyp4
	 rc8QlGcmbaqQQ==
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 27 Oct 2023 17:27:38 +0100
Resent-Message-ID: <ZTvk+jc6cik0jA9K@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 27 Oct 2023 16:24:35 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <arnd@kernel.org>)
	id 1qwOhM-00FfFc-Nv
	for broonie@sirena.co.uk; Fri, 27 Oct 2023 16:24:35 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 08AF361009
	for <broonie@sirena.co.uk>; Fri, 27 Oct 2023 15:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id BDE3DC433CB; Fri, 27 Oct 2023 15:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF2EC433CA;
	Fri, 27 Oct 2023 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698420271;
	bh=ZIhEUto7Ie2F1PnCeV7zW6ioXwNxMy5PW9CRsJ9ceaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR7uDf06h08elvu+XJN8uZlCZ8dl1wqzgxoWyGmvZjCeMLQULFLtq6usskfz3qYS+
	 JL1BZvVg2IZX1FH0mJbEyKq3GzuYT1UlOQqnZmlpFvd01imUoGbeecshd/eYSLYXB2
	 OJ5hG6QPDg3s9L33vsAeAfk7itH22rIeemJ1LlMHWyfAXTs7/eMgFt/daFGMV31Yip
	 wQ4tmit17eQkF1VvPfcVQ9nABob44XSSjs+q+dPZkzL6fIUA5S9HdzTLvEmCrmQxD+
	 6kUkvUmAes0O4NtGxZw3R/qRGaU8n5XdGvzJ5YnWSnwn5Ekf1o4TxUQzD8JkRIGK4A
	 EZRQgWSrO+Jdw==
From: Arnd Bergmann <arnd@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Weidong Wang <wangweidong.a@awinic.com>,
	Shuming Fan <shumingf@realtek.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Herve Codina <herve.codina@bootlin.com>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 27 Oct 2023 17:23:53 +0200
Message-Id: <20231027152403.386257-2-arnd@kernel.org>
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
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: arnd@kernel.org
Subject: [PATCH 2/3] ASoC: codecs: aw88399: fix typo in Kconfig select
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: piJ8cbEPl9mC

From: Arnd Bergmann <arnd@arndb.de>

The aw88395_lib module is shared by all the aw883* drivers that
need to select the corresponding Kconfig symbol. The newly added
aw88399 incorrectly selects SND_SOC_AW88399_LIB instead, which
is not defined anywhere in the kernel, causing a link failure when
the actual one is missing:

arm-linux-gnueabi-ld: sound/soc/codecs/aw88399.o: in function `aw88399_codec_probe':
aw88399.c:(.text+0xbc6): undefined reference to `aw88395_dev_load_acf_check'
arm-linux-gnueabi-ld: aw88399.c:(.text+0xbea): undefined reference to `aw88395_dev_cfg_load'

Fixes: 8ade6cc7e261 ("ASoC: codecs: Add aw88399 amplifier driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 sound/soc/codecs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index cc4026d93654..3429419ca694 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -687,7 +687,7 @@ config SND_SOC_AW88399
 	select CRC8
 	select REGMAP_I2C
 	select GPIOLIB
-	select SND_SOC_AW88399_LIB
+	select SND_SOC_AW88395_LIB
 	help
 	  This option enables support for aw88399 Smart PA.
 	  The awinic AW88399 is an I2S/TDM input, high efficiency
-- 
2.39.2

