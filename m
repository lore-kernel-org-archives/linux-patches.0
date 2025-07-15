Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17CB3BBF2;
	Tue, 15 Jul 2025 13:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585365; cv=none; b=Da3qI0SXZr8QX7f1nnbjvrP7Z6nkmqUd/gLD8QLRuChI6qAHdaeq+YPGKD2/IXTywEAfB0snONDPPHGNSfHZymAJuuvAnJBBi74lyDcG4hEAu7HKuf9IcmJrfT3CWmgXYQ8gj3FV+js+x1FBljohZqynDksofjJRSZZUgRibo50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585365; c=relaxed/simple;
	bh=vn7eUvlzNPyqgQHA08g+n5AL4NkT1PG0aH9rJisyrfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FINtrd9EGkzsg7oLUiqntpzYV+32oCh9ADPCyHZ1gy+1vLgzzRs10A803huD4vBySra3ICkOrdYdLPfcRWFdzneKaUzg1EpYhFetOG7swKBvhGG3p3ME2TpY1hAVLKA0mX6PpJAYCIF7aStOoMgARQtZbwpgS8T4ci/mQinho50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkB2MN1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkB2MN1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E601FC4CEE3;
	Tue, 15 Jul 2025 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585364;
	bh=vn7eUvlzNPyqgQHA08g+n5AL4NkT1PG0aH9rJisyrfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkB2MN1/X2zFp199qTxxYZu/5KLctDi4GAVLAUGHe8EUBJ1KwPyuGRUcsB1AtQP1x
	 gyz55Q68KpNv9yxGSeNlkMC7NvwMgFuz1lxRlOlyIv/+HQiK6h1ES7FPYGj8R7ZEs6
	 9K35pCP0AH1x3QBorCYiflJ9hv+4beTP5MPjl54U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/163] ASoC: Intel: soc-acpi-intel-arl-match: set get_function_tplg_files ops
Date: Tue, 15 Jul 2025 15:11:21 +0200
Message-ID: <20250715130809.308132428@linuxfoundation.org>
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

[ Upstream commit d348b4181cd15ed432c2ae7eb33ef1bb7dfd7527 ]

The audio configs with multi-function SDCA codecs can use the
sof_sdw_get_tplg_files ops to get function topologies dynamically.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250414063239.85200-8-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a7528e9beadb ("ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-arl-match.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 32147dc9d2d66..73e581e937554 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -8,6 +8,7 @@
 #include <sound/soc-acpi.h>
 #include <sound/soc-acpi-intel-match.h>
 #include <sound/soc-acpi-intel-ssp-common.h>
+#include "sof-function-topology-lib.h"
 
 static const struct snd_soc_acpi_endpoint single_endpoint = {
 	.num = 0,
@@ -436,42 +437,49 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
 		.links = arl_cs42l43_l0_cs35l56_l23,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l23.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(0) | BIT(2) | BIT(3),
 		.links = arl_cs42l43_l0_cs35l56_2_l23,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l23.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(0) | BIT(2) | BIT(3),
 		.links = arl_cs42l43_l0_cs35l56_3_l23,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l23.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(0) | BIT(2),
 		.links = arl_cs42l43_l0_cs35l56_l2,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0-cs35l56-l2.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(0),
 		.links = arl_cs42l43_l0,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l0.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(2),
 		.links = arl_cs42l43_l2,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l2.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = BIT(2) | BIT(3),
 		.links = arl_cs42l43_l2_cs35l56_l3,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-cs42l43-l2-cs35l56-l3.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{
 		.link_mask = 0x1, /* link0 required */
@@ -490,6 +498,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
 		.links = arl_rt722_l0_rt1320_l2,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-arl-rt722-l0_rt1320-l2.tplg",
+		.get_function_tplg_files = sof_sdw_get_tplg_files,
 	},
 	{},
 };
-- 
2.39.5



