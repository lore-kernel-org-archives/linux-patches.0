Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A73158A3C;
	Tue, 23 Jul 2024 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760252; cv=none; b=Z0SdCI7t1kruM0S512L5Ry7ZhRplSYLltAIsnzfFVE+qHs7XwsjYvrqxS+DHeIvVfxS6yOFwj4MFqPbnXBwi9t0cWnI0MbeqTffrgXoS3lChnQILFccTWOynvyxWWNYUq6Zgkz8XvH2vnDD7nWv0MPNzgKM3r29FsJHgIYi4/LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760252; c=relaxed/simple;
	bh=Joc6j0ndcT26eKPQqMPXXMmfYBj5D0hb435YAQrgXWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LttK0DZ6ruEMOFJABps7qDbiWCjWLSBNwu0q8XYQdDVI9x3xctKzky1WgPr+Cd+C3xBCnBRNSSKs9Xh7SZzgNVtKLJQTV2wUaNKwDQxpDYzEX3V773+uFL3EehX29rjhd6zEFHLuib66Js6/uYPAtLlsMtOqhf0/pOfk1WTBO7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gj619XEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gj619XEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F93DC4AF0A;
	Tue, 23 Jul 2024 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760252;
	bh=Joc6j0ndcT26eKPQqMPXXMmfYBj5D0hb435YAQrgXWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gj619XEBDtv0l1mtPRF+p0YD1fDeLlARzYuojnNttaA2oaj0dGHWAxNS9dOXbbeaA
	 ApO5Iu4o39tJ28tXUB1g1e8F0O/7fHcvYh0gifVEU7AICN8lnVIUw2DTJ8qxoOvDR0
	 PIvYwFK7AULC2UaPy0WWQPer+lBuNKP2d2xQow2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 153/163] ALSA: hda: Use imply for suggesting CONFIG_SERIAL_MULTI_INSTANTIATE
Date: Tue, 23 Jul 2024 20:24:42 +0200
Message-ID: <20240723180149.380687323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9f560a8186802..b6869fe019f29 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -160,7 +160,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
-	select SERIAL_MULTI_INSTANTIATE
+	imply SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -177,7 +177,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
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



