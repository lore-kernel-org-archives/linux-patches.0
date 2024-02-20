Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F5612D7;
	Tue, 20 Feb 2024 21:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463482; cv=none; b=GJPW5RP8WTD8fRi6YnaV8ctr5sfT0aBRZdg7aWgDoWae4/NlwyLx2LZi9L4+KKnHgWb9aVAiivaRMnLAOL/0TlfLhQQZNRVV+exGO2qkE1bswf4rtggxJiwooK28jQMfp9DPt3VEosouIh3AjKL6GLeJgSdGfNlOaFHc6G7Ovns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463482; c=relaxed/simple;
	bh=pN83oCIdkf7TCptRIAuv4HfcPbo+FPbLkbl0pcYnsKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clRrC5J7bTGqw5wHE2m5rDoiWXqm8S5q36wfG6FzubhMzkKUFCIgreyKw5GrlrywLUgx/VjMQz6j3XyK8HwOqAXvv0hj7qSlAODdYLAHP4FWlpr5v2HTNU87x91ikNtHzdlpViURmpRhb87H79pIc4vJCZ35acva9arK0gmw8Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXFlP2cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXFlP2cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6DAC433C7;
	Tue, 20 Feb 2024 21:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463481;
	bh=pN83oCIdkf7TCptRIAuv4HfcPbo+FPbLkbl0pcYnsKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXFlP2cBLuO24Qj3bz9qE/7r51K6vFYcyGG5bIc8C2eApcZeru+1KUeeMOsF+4zyw
	 yHW9CtnW1zg5ideRanIADG0ORtE1ZvZqJ+Jkx4wSZZdLYPsvh8vldNgNNCQdML1XeS
	 VpSpqOgYxM78++qKDxFhw+AXocp1TghEm7y5AAKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/331] ALSA: hda/cs35l56: select intended config FW_CS_DSP
Date: Tue, 20 Feb 2024 21:52:24 +0100
Message-ID: <20240220205638.472939877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
index 0d7502d6e060..21046f72cdca 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -140,7 +140,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
-	select CS_DSP
+	select FW_CS_DSP
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -154,7 +154,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
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



