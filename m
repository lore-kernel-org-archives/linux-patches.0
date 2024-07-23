Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2270C13D896;
	Tue, 23 Jul 2024 18:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759760; cv=none; b=UjHSXSpPv/NsK1BRmWCarEqKTsfkeaElJgI5/Xx8+nwv4ne+tBiBdQ2dEH10Mo2MSiqohMMnE2SC7skQKQDK9EiihP8d7kX8lK+n8OzWIdO3DbDv1Bm+yJ3EjoRyrHXp9m/HkhTQrhnCQKmkChPbCBYo24NUGBdulGlzZbl0qkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759760; c=relaxed/simple;
	bh=vK0a0X3ccvBZ1xnaCZsBhcexaKCYwxPpTvUzGAik6Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eutd2BiRjzRGDRuYA16b+1avjpgKPNtmW5Je7IIt1q36HxPyFd+YqSwZStmLCkENLS68H1Fq3HjnJqksxDlcRuKl5RLYu9zs8Bx+967r0HxWbsRgpf/9FBAb7cNz9xo+GP+pAnOMX3VAt5WZ6FQ2pi8QQ7Un8VRrpF1HmBSRges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qHMgVbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qHMgVbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9498CC4AF09;
	Tue, 23 Jul 2024 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759760;
	bh=vK0a0X3ccvBZ1xnaCZsBhcexaKCYwxPpTvUzGAik6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qHMgVbGWyqHz9IPUNO76prt+3zOwPozG8G2f9cqp6Qk6TocLSS8zRhTITXw7Ah/g
	 /gUjvid73+5XozmUgY6yzEg6tCrq1sIPo6ggZq3UbGJljGO1ioY8cgmgmSr/HN2q74
	 7pbGpF8Oj/Aga88W2eCzJyBNWKjBhnGRFLHcJc7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/129] ALSA: hda: Use imply for suggesting CONFIG_SERIAL_MULTI_INSTANTIATE
Date: Tue, 23 Jul 2024 20:24:26 +0200
Message-ID: <20240723180409.349017294@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 17563b4a19d1844bdbccc7a82d2f31c28ca9cfae ]

The recent fix introduced a reverse selection of
CONFIG_SERIAL_MULTI_INSTANTIATE, but its condition isn't always met.
Use a weak reverse selection to suggest the config for avoiding such
inconsistencies, instead.

Fixes: 9b1effff19cd ("ALSA: hda: cs35l56: Select SERIAL_MULTI_INSTANTIATE")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406210732.ozgk8IMK-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202406211244.oLhoF3My-lkp@intel.com/
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20240621073915.19576-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index f8ef87a30cab2..9698ebe3fbc2e 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -141,7 +141,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
-	select SERIAL_MULTI_INSTANTIATE
+	imply SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -156,7 +156,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
-	select SERIAL_MULTI_INSTANTIATE
+	imply SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
-- 
2.43.0



