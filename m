Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7BB2DE1E3;
	Tue, 17 Jun 2025 12:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162920; cv=none; b=EVrVlq0Sr0u+xfFu+uHaQ7/G4Opp5nJKRcy7JaVwokSSnoTccX/EY51R+nqTQtpIRRm0wlEZ5GRDmJa60JyBmRCbiOgeKWMa5n3ygowqkRnfcslqMI5tjOuX8KNLTv0/PBGevnRFQZR268KwWF33JhqS6l/3Cs3wiudBOCvu1xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162920; c=relaxed/simple;
	bh=jxweRrSyJmlejxLShqVqk+8CM+SQVxFAHYGOL2a+QPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbjI77ISzIY/6WH90Fj7FR8MUaZoOhWOiHDTWRJJHDkWJYof8S32KdHyDkFwJ0VPcwrBINKNWMK7+U/MCTCCThRoS83GqC9kkYyoylgMPfnhQP2erTM4kuet/hF9hztYD3DsggfD9Qhx8VqMgItxZE8K7Nhodv2WEIcjwjBYZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTOmDRMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTOmDRMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A7AC4CEE3;
	Tue, 17 Jun 2025 12:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750162919;
	bh=jxweRrSyJmlejxLShqVqk+8CM+SQVxFAHYGOL2a+QPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTOmDRMH6402mvieq7LCUztMm+NwCcnSt5HMqr9s3aYBrHdtz5ubw3shS6Qv9EyPL
	 wctgk+N9R+AQ7T+23AfVvNViAeop6s9wfLljhoRLdLcZ0fDUxOI/2G0Br8soWcGoJr
	 E5jy/uSULmbiRQe7CSssf/RFsTBXOGeZoBlsmhK5DmS+vbsle/TY9EFuIUD0b0xwjh
	 3+mJePge3YGxmzkLih7uA6I+YkPDYFEACqINU5Swl7kXmU8+K/JcVVSzHCSozM2Lst
	 cv/LGvotBd9nIBMgDZoiqcRCVw/VGMisIR+g6h3HnRuUxz/H0jbRCFwGSzQaQc4B4p
	 zYXex754eb3sQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	pierre-louis.bossart@linux.dev,
	hkallweit1@gmail.com,
	yung-chuan.liao@linux.intel.com,
	maxtram95@gmail.com,
	phasta@kernel.org,
	zhaoqunqin@loongson.cn,
	TonyWWang-oc@zhaoxin.com
Subject: [PATCH AUTOSEL 6.15 05/15] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Tue, 17 Jun 2025 08:21:35 -0400
Message-Id: <20250617122147.1968355-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617122147.1968355-1-sashal@kernel.org>
References: <20250617122147.1968355-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit ab72bfce7647522e01a181e3600c3d14ff5c143e ]

Add new pci id for AMD GPU display HD audio controller(device id- 0xab40).

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20250529053838.2350071-1-Vijendar.Mukunda@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the similar historical commits
provided, here is my assessment:

**YES**

This commit should be backported to stable kernel trees based on the
following extensive analysis:

**1. Hardware Support Fix Pattern:**
The commit follows the exact same pattern as the historical commits
marked "YES" for backporting (Similar Commits #2, #3, and #4). All of
these commits:
- Add new PCI device IDs for hardware support
- Use identical driver configuration (`AZX_DRIVER_ATIHDMI_NS |
  AZX_DCAPS_PRESET_ATI_HDMI_NS | AZX_DCAPS_PM_RUNTIME`)
- Are small, self-contained changes with minimal risk

**2. Code Analysis:**
The change adds exactly one new PCI device entry:
```c
{ PCI_VDEVICE(ATI, 0xab40),
  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
  AZX_DCAPS_PM_RUNTIME },
```

This entry is inserted in the correct sequential order between existing
AMD GPU audio devices (after 0xab38) and follows the exact same pattern
as all surrounding entries. The driver data flags used are:
- `AZX_DRIVER_ATIHDMI_NS`: Standard ATI HDMI driver
- `AZX_DCAPS_PRESET_ATI_HDMI_NS`: ATI HDMI preset capabilities
- `AZX_DCAPS_PM_RUNTIME`: Runtime power management support

**3. Risk Assessment - Minimal:**
- **No algorithmic changes**: Pure PCI ID table addition
- **No new code paths**: Uses existing, well-tested driver
  infrastructure
- **No configuration changes**: Same capabilities as neighboring AMD GPU
  devices
- **No architectural impact**: Confined to PCI device recognition
- **Regression risk**: Nearly zero - only affects this specific AMD GPU
  (device ID 0xab40)

**4. User Impact - Significant:**
This enables HD audio functionality for users with new AMD GPU hardware
(device ID 0xab40). Without this change, the audio component of these
GPUs would not be recognized by the kernel, leaving users without audio
output capabilities on affected systems.

**5. Stable Tree Criteria Compliance:**
- ✅ **Fixes important bug**: Lack of audio support on new hardware
- ✅ **Minimal risk**: PCI ID additions have extremely low regression
  potential
- ✅ **Small and contained**: Single line addition following established
  pattern
- ✅ **No new features**: Pure hardware enablement
- ✅ **Clear benefit**: Enables audio on new AMD GPUs

**6. Historical Precedent:**
Similar Commits #2, #3, and #4 (all marked "YES") demonstrate that
AMD/ATI GPU audio PCI ID additions are consistently considered
appropriate for stable backporting. The only "NO" examples (Similar
Commits #1 and #5) were either preparatory changes for future features
or lacked hardware urgency.

**7. Maintainer Endorsement:**
The commit has proper sign-offs including review by Alex Deucher (AMD
maintainer), indicating technical correctness and hardware necessity.

This commit perfectly fits the stable tree guidelines: it's a minimal,
safe hardware enablement fix that provides significant user benefit with
virtually no regression risk.

 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 512fb22f5e5eb..3f8b2bf6eab56 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2715,6 +2715,9 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_VDEVICE(ATI, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_VDEVICE(ATI, 0xab40),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	/* GLENFLY */
 	{ PCI_DEVICE(PCI_VENDOR_ID_GLENFLY, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
-- 
2.39.5

