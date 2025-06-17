Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6F32DE1E0;
	Tue, 17 Jun 2025 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162972; cv=none; b=DEjWVP9FbqUm3Q67GhxB1TU0oCjr7VT+9RkZd2ZIl/ojEluThuZrs4Seh4FWJjlOpnBEtJiFpP6DRgpBr9aPguj5o4c+720bvcEGSGfk7CT77BMFOrXsQVgbQvygHym7kb2cGHa5erb8y3ExKLKeZk/tyysTRzIW+clqenuu9bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162972; c=relaxed/simple;
	bh=dssgEvl4sw/Iv7BRlum/lKbHRZHNU0YpXOrZ6yd8VS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJMsNpIdBV67q5+XcTsT34/ALB+m3eJCFdlsfVBBPzBkKBySusop66fqu8d6hGeUb4H/QYM31mB/3C7zeqf7G/ATZQhFx4w9PrhXfDAOyM+u9U0378QPUyU3sKBM1tJ2jtR8a/3xPYgOIFYhGBgT2gO3u2uFXbgi5XycoTTeQO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QuUZjHfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuUZjHfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E26EC4CEEE;
	Tue, 17 Jun 2025 12:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750162971;
	bh=dssgEvl4sw/Iv7BRlum/lKbHRZHNU0YpXOrZ6yd8VS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuUZjHfWZoissyIVy4AAvkN0kf+RQAgYiQf6qjq2JV6P3Fy5Ae2i/CVDEOOvKsRQM
	 EdF7QcJPfhvVgWA6J7BxAo1zYeSWKr0oSlEXzUhCxxhq+mfTgJevcwxWlFkhCyRJDa
	 dspMYaxN6bWEgtzvgF3OZsisk9qF4e0nrbfDQTRAGinyn/EDub0hxrAObSoSRWxSSc
	 sUuBmUbTpZKwQWi5ndCYqvNBf765IPQxAIOhuFkJEI7BP6asOA6ohYQYGn04F9hlDx
	 WgWPMBMS+vpEOAyOhYPP2AQ5FxJVT3zUPhisXSszgIvfu+8uKRT1a5js6TYsTmayMb
	 I5yO9fK7bjCqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	maxtram95@gmail.com,
	pierre-louis.bossart@linux.dev,
	yung-chuan.liao@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	hkallweit1@gmail.com,
	TonyWWang-oc@zhaoxin.com,
	wangyuli@uniontech.com,
	phasta@kernel.org
Subject: [PATCH AUTOSEL 6.6 2/9] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Tue, 17 Jun 2025 08:22:39 -0400
Message-Id: <20250617122246.1969130-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617122246.1969130-1-sashal@kernel.org>
References: <20250617122246.1969130-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
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
index 3a0df631d25d9..cbd864e6da05c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2725,6 +2725,9 @@ static const struct pci_device_id azx_ids[] = {
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

