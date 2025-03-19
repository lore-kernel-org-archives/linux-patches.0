Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566F1DDC01;
	Wed, 19 Mar 2025 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395115; cv=none; b=LEC16XxMttzM7nmdWMhb8NdhuI+wTz71+a0smEZSGPDx20FYKSZvzkyA1jHA3HHDHliON95dDm3pNPpEZF80MWtO6hfQ20B3APmYWtXl7WlVjj9Dpunzn2wQVe71ZAT8ju1tmNsUSYfvCMpNeleg95V+9H6DLUT1DHaMQMdsRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395115; c=relaxed/simple;
	bh=HZeNP+Sx0VP3jQKqf0ETUn5r+BSCxrO1ANWloDMEse0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brT9Vd++8H/JuTE+CaOp49b2ngvLPTggBs1oullBKnspLM3yvonsoC2H9p47USM6FH25mRxwap7pu+OL7qb/dQqaa4jAvgI+4Af3LwGVfRUgTel4YRPLa1hHd0R9D+BCb3JRr89BMAhov66y5M2hsItDhsRGvsQf6Q00p9ej+w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XNK1AGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XNK1AGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B744C4CEE4;
	Wed, 19 Mar 2025 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395115;
	bh=HZeNP+Sx0VP3jQKqf0ETUn5r+BSCxrO1ANWloDMEse0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XNK1AGBsGeGkSt0lkKMm4VVDI2i8H9VB4rTIARIRkmqb7FL/N2u3+DIus7/uLpUC
	 dVu/PVWxROVfMv1flE4LQp0K55DxU0yFcu5IpLSZsp7cflEcfeFTqZ1zu3t8dMNg7c
	 8JF0Anjpl+LBE9QjlO8iGycVtDxGboBRV4/v3ba4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/231] ASoC: SOF: Intel: dont check number of sdw links when set dmic_fixup
Date: Wed, 19 Mar 2025 07:30:26 -0700
Message-ID: <20250319143030.120905577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index f10ed4d102501..c924a998d6f90 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1305,22 +1305,8 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
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



