Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6017261B;
	Tue, 15 Jul 2025 13:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585386; cv=none; b=WNyUYtEIwiDnDT1eaNIW9XHeuoSmrqHLZB6/15H0gAK8R+3P2qqbbG9YwRvMlxMc5PkC9Wtjqi4Q1gv10dg0j+Mkg6SGSJzAqN8dZKDr9eyyUmBdvjVYi3Uws/gFx7HvYt098U45rbbVNLr0rt0x0OM6lEm1ieV6SsVfyVSN2eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585386; c=relaxed/simple;
	bh=0Klyfocii2P9PNJKPZUShcHvOwhDg7KRmrln4WcINIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKCg6pOG7dS7PB5yU+9ugzxjRNT5DJe/aNUeg/QiiEdjRVZmp/WKnPuu/UekT9DhWfGkL2MZ5GtagBhI6IUiI9d2EEJyqhwqUWv3PtJGWajPqdKgjIOf7MzYez22Cq8VeWP34/FOZ/GQTRb9gfsEuiW9UJkdEU6X6IGBbNVP0Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T9Li7Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T9Li7Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BEEC4CEE3;
	Tue, 15 Jul 2025 13:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585385;
	bh=0Klyfocii2P9PNJKPZUShcHvOwhDg7KRmrln4WcINIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T9Li7Ry1PmCyKkSss8u0Xjk3fA5oWnYf0/7eue3i3KU6+dpWbaFDKjP7Y92gT/B/
	 PblgOnFG09bpn0CXt1OmlQEDdfI4Kh6iMIgYF9tDWPKVfZwbIR6VdyoHrR8xg2tnF5
	 b/O557YZ4HInCROt7XGcbB9VobCxhj4aO8GnDjiY=
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
Subject: [PATCH 6.12 008/163] ASoC: Intel: SND_SOC_INTEL_SOF_BOARD_HELPERS select SND_SOC_ACPI_INTEL_MATCH
Date: Tue, 15 Jul 2025 15:11:16 +0200
Message-ID: <20250715130809.112130168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc10ae58b0c7e..8dee46abf346d 100644
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



