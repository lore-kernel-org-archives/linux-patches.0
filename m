Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58CD2E426C;
	Tue, 15 Jul 2025 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586716; cv=none; b=XD3/9wyJM5vTwOA0RT8YGZe7a64mjgwinMGKNf7sYF5wX0lpFvT8Y7r1XIA69X91txFkpcFYo7y+vPcyS388IdU0OyRh22lfIXTra586gD7oocgtQM5/eq/kFG9lFZGcDXsUTcgMO2f8Q+cALtVazlqJRv02MT2I62IcNnI+54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586716; c=relaxed/simple;
	bh=4rvQ2Bqmq9lPGVjYYh4XqM+TQEyU3AQueeMogQpZEk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CpDmLlpHmXt7DSkkUnAv/c3ScPoI9ZbVMNCgYZehlVulmuVcKcGKOpsTszuHhL5QoTaYAcnQQElchKGk1yP7W9uHQX/wU5Xa/UmFd+qctggbW9sPCM73JQBczWfh8zOJSm6ZhS9quvCYZIey3aPEzdbsx0Q+3PfxoYc4bwJQKp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMawj5Ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMawj5Ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DD1C4CEE3;
	Tue, 15 Jul 2025 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586716;
	bh=4rvQ2Bqmq9lPGVjYYh4XqM+TQEyU3AQueeMogQpZEk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMawj5NytVFZTfQnc/T1vnvbhMcrpZrC3UPmIZwvoGS2tfO7HJowihhwLEDhyWv1a
	 dGounC4kXm3SUT7bE4qshYPeFUth7av28+5KIoz0AHVmEIdL+B0wcEtA4mdLj9O8Z2
	 05r65T1eYpce48f5m/NXrlJ/fVffY0iFFUokf3zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 004/192] ASoC: Intel: SND_SOC_INTEL_SOF_BOARD_HELPERS select SND_SOC_ACPI_INTEL_MATCH
Date: Tue, 15 Jul 2025 15:11:39 +0200
Message-ID: <20250715130815.037976440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 960aed31eedbaeb2e47b1bc485b462fd38a53311 ]

The helpers that are provided by SND_SOC_ACPI_INTEL_MATCH
(soc-acpi-intel-ssp-common) are used in SND_SOC_INTEL_SOF_BOARD_HELPERS
(sof_board_helpers).
SND_SOC_ACPI_INTEL_MATCH is selected by machine drivers. When
skl_hda_dsp_generic uses the board helpers, it select
SND_SOC_INTEL_SOF_BOARD_HELPERS only but not SND_SOC_ACPI_INTEL_MATCH
which initroduce the undefined symbol errors. However, it makes more
sense that SND_SOC_INTEL_SOF_BOARD_HELPERS select
SND_SOC_ACPI_INTEL_MATCH itself.

Fixes: b28b23dea314 ("ASoC: Intel: skl_hda_dsp_generic: use common module for DAI links")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506141543.dN0JJyZC-lkp@intel.com/
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20250626064420.450334-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/Kconfig b/sound/soc/intel/boards/Kconfig
index 9b80b19bb8d06..4db7931ba561e 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -42,6 +42,7 @@ config SND_SOC_INTEL_SOF_NUVOTON_COMMON
 	tristate
 
 config SND_SOC_INTEL_SOF_BOARD_HELPERS
+	select SND_SOC_ACPI_INTEL_MATCH
 	tristate
 
 if SND_SOC_INTEL_CATPT
-- 
2.39.5



