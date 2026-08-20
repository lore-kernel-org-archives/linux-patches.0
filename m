Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F23737C90A;
	Thu, 20 Aug 2026 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238122; cv=none; b=QXyBKQw3o7riMiG55mT58ktK62jRDcLjcCLcGNFgC64qlLENzsuZCVMgYtarPzqTC5fmZPY576SHZQY1fxnbJc3wHT50jfsvS3tJOCqyggSvGFE7dFQpiD6+bhfsS81m1cGjIkpMYIZg3IlhwOzg9y+OTD9Fr0yYlQCIjzLZTEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238122; c=relaxed/simple;
	bh=Lz5O4I+mp7/z6lLbQ3WgwLMOXFmEuNoaIOt4pQ4nlvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RE4vq6PpvJjnjONCMio3PcoQ0U+5Z8nwdCWI4R/d8Vl+FjoTBQhe6imlzkulzgPHi+QvYHaoKfK9UYzwDC9q/YS2SuXV+UA6GqvV7UZoCza4HhfDqpWCevCl5P11BeZVRSeWff0BpYIBO0s/Xi6kh8wHrAcq4lAtUbDiSnCbG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsMUt7HJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsMUt7HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C925C1F000E9;
	Thu, 20 Aug 2026 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238121;
	bh=Le97d1Fl0aNdxa4SH1FvK9XKJlm0PbgAPQb3J37W80I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsMUt7HJIf3+M6DTAn2MPHAWQ42IYgqvjK6cR5OZK/2LWSJDR25279hijpFr9vgVH
	 EF2Tqj/yjxCZmIbK26YNZ7xdcBhcKaKjqCIaKAEcQVaQdMtkOJkDcoFkT6tB0GtZka
	 rzjpBxraSF+J3QV+9FrcDzY81xD8uL0QZpEtLKtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 039/228] ASoC: SOF: topology: Use acpi mach from the machine driver
Date: Thu, 20 Aug 2026 16:53:01 +0200
Message-ID: <20260820145245.655777124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 			   const char *prefix, const char ***tplg_files, bool best_effort)
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


