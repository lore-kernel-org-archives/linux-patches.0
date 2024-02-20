Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB90152E06;
	Tue, 20 Feb 2024 21:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464474; cv=none; b=CSP0MHftyQv7/ozwE3O2KBrlGxQmbEPVy/B+K4xOmwzN82HGkpotdcI71yl4HzfZLtIFF46TGm9gEL0fvmmOaq2MgGtKKfeDVACYXcw/J/mvNt54t6DmEaw8T0w3CFBs+yiLX6ieZxeA3nmCeOAnJZKdwpF+czLqUQ6ir5Wl/jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464474; c=relaxed/simple;
	bh=HzihEej5vWTdwXh4PEP2TxrhWY1q3Xi28obrYOTbHoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX3blcVFzqQVdCWzAmfCodRX9j/yoTuiQAHCpD/PqKpCTO14m9ezvacYGvGNCVZMB0BGBN0/g10zDj6llAkCnOZCUKY+LIx6pe3S+Eb7Ks1oo6SsmmCzYi7HAnK/PWNgOjz4ZayzgH7Cf0UKuGe9jmpiRy2OVd5MVwm4CBuPb5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bArGT9Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bArGT9Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ADAC43399;
	Tue, 20 Feb 2024 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464474;
	bh=HzihEej5vWTdwXh4PEP2TxrhWY1q3Xi28obrYOTbHoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bArGT9Da7LcybOGBo0xdY/M782MmNnGZybgCg5NNxVas7OJXVTA3Fld15ubpS/+CA
	 7Pcb+LZQVJVBk7r6Y0Y1h9kKlN6qUfYGNe6sJdrblD4UkLSYEu//SLhetlEk1qoQ3S
	 nZDtqUaGq5T4F+5CsHXeruKxVMyYaffet74wE45E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/309] ALSA: hda/cs35l56: select intended config FW_CS_DSP
Date: Tue, 20 Feb 2024 21:53:16 +0100
Message-ID: <20240220205634.345914077@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit e5aa6d51a2ef8c7ef7e3fe76bebe530fb68e7f08 ]

Commit 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic
CS35L56 amplifier") adds configs SND_HDA_SCODEC_CS35L56_{I2C,SPI},
which selects the non-existing config CS_DSP. Note the renaming in
commit d7cfdf17cb9d ("firmware: cs_dsp: Rename KConfig symbol CS_DSP ->
FW_CS_DSP"), though.

Select the intended config FW_CS_DSP.

This broken select command probably was not noticed as the configs also
select SND_HDA_CS_DSP_CONTROLS and this then selects FW_CS_DSP. So, the
select FW_CS_DSP could actually be dropped, but we will keep this
redundancy in place as the author originally also intended to have this
redundancy of selects in place.

Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20240209082044.3981-1-lukas.bulwahn@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index 21a90b3c4cc7..8e0ff70fb610 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -156,7 +156,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
-	select CS_DSP
+	select FW_CS_DSP
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -171,7 +171,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
 	depends on SPI_MASTER
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
-	select CS_DSP
+	select FW_CS_DSP
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
-- 
2.43.0



