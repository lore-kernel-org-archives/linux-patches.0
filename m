Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E53E13D600;
	Tue, 23 Jul 2024 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760039; cv=none; b=OzjpR33F+TEUm/PAjISRDE84O5qR5D6Uu7hoTwj2aHDpqgqYK6nHwOd5NqUdvI/xTk8nZ3GE++J3FJUfRfJeNs+k6ZdVDY7JxrmwKGuP2Sr3jRwjUFyIuKw+2W2wdyqip0h+Zar/dkQ5K6DARdUFhhYbveBlQ7QP58MCcPmp93U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760039; c=relaxed/simple;
	bh=QJWEm6CqPo9EXOSKBMS8J+0nKCvA1BiVSlLQqHRipcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjqSfamS1ZSvGwZ8UoWVLeVgAWb+5UgSy9OGhR7kEvxvz2tr6zRhKVs1oG4eUYFBoTJQOupvVC6uu/0nghsk62ZsufhmLzUsi9xigIIHMhtVyufBB2j8nFTod9uJFZApZOLz6WuMVxHeSRedmYgyX6tV5YqriUF/ykIRyTwS46U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keJ3iOGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keJ3iOGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B95C4AF0A;
	Tue, 23 Jul 2024 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760039;
	bh=QJWEm6CqPo9EXOSKBMS8J+0nKCvA1BiVSlLQqHRipcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keJ3iOGNTu2lDGiIqKKt9k13p3Y5mqQLl4ud/5ZWLrlIx5BXT7GLeN81CBpb2eYCj
	 c8n7jaeztz49AguncSUtBQ58OPoR3maiehP1SFLcfOBlg7407pU2mZEm4M7blBA8E/
	 nBo/GM02eY13n34x1vVAm+SVmuPc5tp+OBLALIPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 083/163] ALSA: hda: cs35l56: Select SERIAL_MULTI_INSTANTIATE
Date: Tue, 23 Jul 2024 20:23:32 +0200
Message-ID: <20240723180146.679529179@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 9b1effff19cdf2230d3ecb07ff4038a0da32e9cc ]

The ACPI IDs used in the CS35L56 HDA drivers are all handled by the
serial multi-instantiate driver which starts multiple Linux device
instances from a single ACPI Device() node.

As serial multi-instantiate is not an optional part of the system add it
as a dependency in Kconfig so that it is not overlooked.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://lore.kernel.org/20240619161602.117452-1-simont@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index f806636242ee9..9f560a8186802 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -160,6 +160,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
+	select SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -176,6 +177,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
+	select SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
-- 
2.43.0



