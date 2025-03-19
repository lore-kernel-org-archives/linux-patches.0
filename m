Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEDF1E32DD;
	Wed, 19 Mar 2025 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394927; cv=none; b=U6Gibi6CAS5mwf3WNKY9DPe6mrckh+jCOb0lws1yHdpi9SK0Im6hD3P7bwoHAWYrqUUQxO/TjN5tGTJk6iShlq6TNuB+XRubrFttXK8+d5vR7axsdkVV4lHmvj1/5yzYh+zEvccJmL677keV7o3WvZaKRnc8B72GlZSPEKgNjoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394927; c=relaxed/simple;
	bh=xjQLqPLsS2V+hZK5oEY5x9zv0iGPMQxMeKsXv01Tdn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M814zsCStPBCzwUd1NlLe3HIFgO4LRKIl1QeCi2HRB2qmT6qlKxOzY4A01WqVJ6TiPj3QNYF3BH5nFhJEJ9JPT5OgC3sLbJtNPm/k7CATxtuVecYEfSe9ppk9Ta1D5+LF+9EnvsUqilQW5dDSGD/jmF5xrexfzbANU/eFNg744s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTI2TGYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTI2TGYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4FEC4CEE4;
	Wed, 19 Mar 2025 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394926;
	bh=xjQLqPLsS2V+hZK5oEY5x9zv0iGPMQxMeKsXv01Tdn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTI2TGYrc3n4veW7morSZrPqorA7ADg5yaXc2M/8C6cmcdVLlMVkZMCEAaCVOeTbC
	 xUTQsFS2UHmiwKyoY3Oo/NBOFduU4uFNtD70mTMa1RQZ93/s/PlwIjQa3F5MUgt0Fj
	 P1RJsfGj0XEV0tEGElOBAMcv34XXuG326fRsfVFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 139/241] ASoC: SOF: Intel: dont check number of sdw links when set dmic_fixup
Date: Wed, 19 Mar 2025 07:30:09 -0700
Message-ID: <20250319143031.162693452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 56a677293509b2a0d39ac8d02b583c1ab1fe4d94 ]

Currently, we assume that the PCH DMIC pins are pin-muxed with SoundWire
links. However, we do see a HW design that use PCH DMIC along with 3
SoundWire links. Remove the check now.
With this change the PCM DMIC will be presented if it is reported by the
BIOS irrespective of whether there are SDW links present or not.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250225093716.67240-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index be689f6e10c81..a1ccd95da8bb7 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1312,22 +1312,8 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 		/* report to machine driver if any DMICs are found */
 		mach->mach_params.dmic_num = check_dmic_num(sdev);
 
-		if (sdw_mach_found) {
-			/*
-			 * DMICs use up to 4 pins and are typically pin-muxed with SoundWire
-			 * link 2 and 3, or link 1 and 2, thus we only try to enable dmics
-			 * if all conditions are true:
-			 * a) 2 or fewer links are used by SoundWire
-			 * b) the NHLT table reports the presence of microphones
-			 */
-			if (hweight_long(mach->link_mask) <= 2)
-				dmic_fixup = true;
-			else
-				mach->mach_params.dmic_num = 0;
-		} else {
-			if (mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER)
-				dmic_fixup = true;
-		}
+		if (sdw_mach_found || mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER)
+			dmic_fixup = true;
 
 		if (tplg_fixup &&
 		    dmic_fixup &&
-- 
2.39.5



