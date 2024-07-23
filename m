Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66426155351;
	Tue, 23 Jul 2024 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759671; cv=none; b=VlNPx78nMjwtR03urEKw2xY1rHbAsze1gGWOlZzi4yOtbeul2wjLAgOpuF52jceDDxPyyvqVulfiMEN1HUIiNW8DV8rTKLMWFgDS9Y9oI+B9lWOMgh4byajgUJKMv8opCupxo6/jO4Kb49cL8iDHBqQAGZLCPCo8002ooUeOA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759671; c=relaxed/simple;
	bh=ns3txKkwnz3kFZdkLzKlF7/KOnATLoop5FbNSTgMKdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoXXgIQML8l+R4vblQzj0zw5pG+Vm5p5pHTBkEYocu6dXHsNV490esRdqg9t/975A60ff/lih1tgJ4yQ01QLOI5H+QcmnUno7zVpJ06l/cH0ezNTvdhgucK4xfoIX9fxBXA3rJvkMokcMRwBqkPknj4kTT7O4TXeAygGRRy66UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MDrYNb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MDrYNb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1767C4AF0A;
	Tue, 23 Jul 2024 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759671;
	bh=ns3txKkwnz3kFZdkLzKlF7/KOnATLoop5FbNSTgMKdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MDrYNb90AWdEAOu1DRzVlf7h7R4IfXUE0jw1464GUZjeSbzyFC4xVOF2KuWVPrwm
	 qS/zoj2wi/jj3vRGgUabjG8wrYB1iAPmasmKwPlkAuyyPdMcvEXIhuGGGTlVXdqd23
	 bT7vz34UsSfB2SUSd2XSsYs+ARve8yQcP0f0BvJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/129] ALSA: hda: cs35l56: Select SERIAL_MULTI_INSTANTIATE
Date: Tue, 23 Jul 2024 20:23:29 +0200
Message-ID: <20240723180407.143962331@linuxfoundation.org>
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
index 21046f72cdca9..f8ef87a30cab2 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -141,6 +141,7 @@ config SND_HDA_SCODEC_CS35L56_I2C
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
+	select SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
@@ -155,6 +156,7 @@ config SND_HDA_SCODEC_CS35L56_SPI
 	depends on ACPI || COMPILE_TEST
 	depends on SND_SOC
 	select FW_CS_DSP
+	select SERIAL_MULTI_INSTANTIATE
 	select SND_HDA_GENERIC
 	select SND_SOC_CS35L56_SHARED
 	select SND_HDA_SCODEC_CS35L56
-- 
2.43.0



