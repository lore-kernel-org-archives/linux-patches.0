Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334352FA647;
	Tue, 17 Jun 2025 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179176; cv=none; b=qTCUPVWhowiDg75+DWUtw4mxjG1WEpWaxmNv2vvpH/K9vc6Rrk4apzRS788QqJBTq7+qU6utE0bdTGYkJxZNt7zHeSRwiKDiMlEKMOS6ydBucADDiALP9epRzUHRx0BcQNsCxc65IcOE7ZUhMwXuRhbaKIAD/Hym4KGgubF0850=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179176; c=relaxed/simple;
	bh=90K0exlP+YC7yUDPDOflNCS8P5nqF0RfOeReoD/5e3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=altLFW4qFTwqsAC1XT8kuOC/8J3c4WI3VZECdu6+7BHDyl91Regpa27Fd6dmZBxj07p0vCB/RASAp1ErkDFPblrDGWQBq0slUGReGBUagXFkEQ1K6YP+hr4FYPlWPTsoiyLGcYbVTVSDCXap1raP73lNYlrjyQUxG9uOHEXvjSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX7XZkio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX7XZkio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979F5C4CEE3;
	Tue, 17 Jun 2025 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179176;
	bh=90K0exlP+YC7yUDPDOflNCS8P5nqF0RfOeReoD/5e3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX7XZkionp87e6sIJ0Xvj5xN1OzjbR2lUoq4vZpjEmV4hO1VMLloEQ1/n5miWU5kw
	 NREjVUG4zZIGYrFz/2ll5R8U1TkbdyqdoQvFDP7aMoNOvGXbf3reRj5mUAgPKpoq2K
	 eh9qOi+m+fPvB9D620d85uU6O8mLnKEJ+QMxejfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 641/780] ASoC: Intel: avs: Ignore Vendor-space manipulation for ACE
Date: Tue, 17 Jun 2025 17:25:49 +0200
Message-ID: <20250617152517.583894305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit acd2563f30886730757062b9b3efe8043daabbc3 ]

A number of Vendor Specific registers utilized on cAVS architecture
(SkyLake till RaptorLake) are not present on ACE hardware (MeteorLake
onward). Similarly, certain recommended procedures do not apply. Adjust
existing code to be ACE-friendly.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Link: https://patch.msgid.link/20250407112352.3720779-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9e3285be55e6 ("ASoC: Intel: avs: Fix paths in MODULE_FIRMWARE hints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/avs.h  |  1 +
 sound/soc/intel/avs/core.c | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/avs.h b/sound/soc/intel/avs/avs.h
index 585543f872fcc..91872d1df97a5 100644
--- a/sound/soc/intel/avs/avs.h
+++ b/sound/soc/intel/avs/avs.h
@@ -72,6 +72,7 @@ extern const struct avs_dsp_ops avs_tgl_dsp_ops;
 
 #define AVS_PLATATTR_CLDMA		BIT_ULL(0)
 #define AVS_PLATATTR_IMR		BIT_ULL(1)
+#define AVS_PLATATTR_ACE		BIT_ULL(2)
 
 #define avs_platattr_test(adev, attr) \
 	((adev)->spec->attributes & AVS_PLATATTR_##attr)
diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 8fbf33e30dfc3..72a14dca1a1ed 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -54,14 +54,17 @@ void avs_hda_power_gating_enable(struct avs_dev *adev, bool enable)
 {
 	u32 value = enable ? 0 : pgctl_mask;
 
-	avs_hda_update_config_dword(&adev->base.core, AZX_PCIREG_PGCTL, pgctl_mask, value);
+	if (!avs_platattr_test(adev, ACE))
+		avs_hda_update_config_dword(&adev->base.core, AZX_PCIREG_PGCTL, pgctl_mask, value);
 }
 
 static void avs_hdac_clock_gating_enable(struct hdac_bus *bus, bool enable)
 {
+	struct avs_dev *adev = hdac_to_avs(bus);
 	u32 value = enable ? cgctl_mask : 0;
 
-	avs_hda_update_config_dword(bus, AZX_PCIREG_CGCTL, cgctl_mask, value);
+	if (!avs_platattr_test(adev, ACE))
+		avs_hda_update_config_dword(bus, AZX_PCIREG_CGCTL, cgctl_mask, value);
 }
 
 void avs_hda_clock_gating_enable(struct avs_dev *adev, bool enable)
@@ -71,6 +74,8 @@ void avs_hda_clock_gating_enable(struct avs_dev *adev, bool enable)
 
 void avs_hda_l1sen_enable(struct avs_dev *adev, bool enable)
 {
+	if (avs_platattr_test(adev, ACE))
+		return;
 	if (enable) {
 		if (atomic_inc_and_test(&adev->l1sen_counter))
 			snd_hdac_chip_updatel(&adev->base.core, VS_EM2, AZX_VS_EM2_L1SEN,
@@ -99,6 +104,7 @@ static int avs_hdac_bus_init_streams(struct hdac_bus *bus)
 
 static bool avs_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)
 {
+	struct avs_dev *adev = hdac_to_avs(bus);
 	struct hdac_ext_link *hlink;
 	bool ret;
 
@@ -114,7 +120,8 @@ static bool avs_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)
 	/* Set DUM bit to address incorrect position reporting for capture
 	 * streams. In order to do so, CTRL needs to be out of reset state
 	 */
-	snd_hdac_chip_updatel(bus, VS_EM2, AZX_VS_EM2_DUM, AZX_VS_EM2_DUM);
+	if (!avs_platattr_test(adev, ACE))
+		snd_hdac_chip_updatel(bus, VS_EM2, AZX_VS_EM2_DUM, AZX_VS_EM2_DUM);
 
 	return ret;
 }
-- 
2.39.5



