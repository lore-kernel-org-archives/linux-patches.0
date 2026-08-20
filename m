Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3C379EDA;
	Thu, 20 Aug 2026 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238763; cv=none; b=C/RjZOap5RF/Y0hmOKnfPJvhKe7ZGRYCNI4111i3PURF1mD3oX6cRh2A2rc0R9barzf0yi0+DmIvx3jeQb2DhqEBtkYErT2aPJo6tAfRaiSAQP60Og5S4adfB90S8Kw2XPjyVUMRjp0V+jvaOakJ8XRGzuPd50YJHCj5ZYyV3ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238763; c=relaxed/simple;
	bh=+y+qMebsO/0lmeCDQ2VuI6dFW9DPlrXOV+KYi3nm35E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCiMJkQZrkwrep7d/wII+7qFMiVVkjakf/O0wMsV/6jSRKF3FEEYslI28A+dDCyUCkpvAMxyO7czySF6nmMYvnkfO5U+sveEQozKkkwfxqX3Jj/YpaOrXAr8zJrTrGFVMbXnVOB37s/ynlJlS9soFpR0SDWMYF87VhbS4nNMC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlNzkjCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlNzkjCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10C71F000E9;
	Thu, 20 Aug 2026 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238762;
	bh=0SZBXJNq652lWt4QE1P8Of9QwFqci8Q0Lj4X/QJL8YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlNzkjCdpKwj/eOjVS5xBuHiqxjTVgpXxMN4vNMWalEqrQ7cFKR1V/ZauwZtmqoD9
	 x6GHSMq4bNwQKBtn8mXi6If1wz3+aHNsvEPbFWZU8Ol1gzjZgyZLfX8jfYm9aPldB/
	 Z0EpjOLzmoHXPXLOgpOYOD0FabRXXij9pHcj+CtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 031/217] ASoC: SOF: topology: Use acpi mach from the machine driver
Date: Thu, 20 Aug 2026 16:53:19 +0200
Message-ID: <20260820145238.555633008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit ae63720dd7c3647d64f7a85e5e1870f90eb569d6 upstream.

The parameters may be changed by the sof_sdw machine driver is the
SOC_SDW_PCH_DMIC quirk is set. Use the mach_params from the machine
driver to ensure the sof_sdw_get_tplg_files() function select the right
function topologies.

Fixes: 2fbeff33381c ("ASoC: Intel: add sof_sdw_get_tplg_files ops")
Cc: stable@vger.kernel.org
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260730071724.22296-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/common/sof-function-topology-lib.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/common/sof-function-topology-lib.c
+++ b/sound/soc/intel/common/sof-function-topology-lib.c
@@ -30,7 +30,12 @@ enum tplg_device_id {
 int sof_sdw_get_tplg_files(struct snd_soc_card *card, const struct snd_soc_acpi_mach *mach,
 			   const char *prefix, const char ***tplg_files)
 {
-	struct snd_soc_acpi_mach_params mach_params = mach->mach_params;
+	struct snd_soc_acpi_mach *card_mach = dev_get_platdata(card->dev);
+	/*
+	 * Use the acpi mach from the machine driver because the machine driver
+	 * may change the dmic_num based on the machine driver quirk.
+	 */
+	struct snd_soc_acpi_mach_params mach_params = card_mach->mach_params;
 	struct snd_soc_dai_link *dai_link;
 	const struct firmware *fw;
 	char platform[SOF_INTEL_PLATFORM_NAME_MAX];


