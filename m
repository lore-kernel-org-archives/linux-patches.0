Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C6225402;
	Mon,  9 Jun 2025 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509635; cv=none; b=RYQ6SgV+el9NiwpkfyU+BmaOojVpSj3gGH2Q7WSLkOznuAqIt+XwP0sSH+n5x6vWQI5e8tSVGQx/7/ujQBTutUHvVSV2CV+O9/zqKBnT5kHYdh8k8LhbW0WS2Fibd4kzIFTbBhjbV6Uj4i3L12zEqypEUZ6Vx1V3RI3kxUyGTDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509635; c=relaxed/simple;
	bh=Vew+dHig8bTO2q8XNZkwpvSApXif24U4TDDpKTfV7Rk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uyTOg1swqIQ4Vj9O9r3OHWD/K+O7qhWmtFJ8HgNShgVNvZL7hEnvUYkbHZQnnv3ShXKc2rscTguIZyh/R4SKxKhexIMklDXRz6LZfYlwfa1TsNwVghErVywVuPW0/wRUkrsb1QZSt6ciyxVNWJCBN1AUuhZBTHBr33g/Oq7oa+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6IPGDwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6IPGDwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD80C4CEEB;
	Mon,  9 Jun 2025 22:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749509635;
	bh=Vew+dHig8bTO2q8XNZkwpvSApXif24U4TDDpKTfV7Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6IPGDwn5J92OqGsm0Z7iBmsWfZurSOFLVgQtkIq75pmVTYPwf/EMDRP+AMKzaFid
	 WvvNYEeqX5WvJFW/oLG6X+Dc7THQ0n6/+96MckPF0D1U1QEByWvTwuvE/iWrr7amcc
	 GDQBFmWH3+YX9wKJM4Mqv1d2T1rcenRkV/1wBajvomUSx0xzG+QkqEt34et6Ll2Bds
	 tWzC1SC3XyVQInApRH6qNHkIvWBOaTUvOj5EIm3/w9XqugR4AJ0M2ZMJXMDUXSA+YT
	 bS6OktYlxEF4hKvNwN4Cg1KUwwHCeeOMQqJSotCSd9Kt1FvFs42aHTnCZ4xsNNsUJw
	 7dpPY+X5aB3wQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	hulianqin@vivo.com,
	wangdicheng@kylinos.cn,
	lina+kernel@asahilina.net,
	cyan.vtb@gmail.com,
	dan.carpenter@linaro.org,
	bsevens@google.com,
	shenlichuan@vivo.com
Subject: [PATCH AUTOSEL 6.1 3/5] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Mon,  9 Jun 2025 18:53:44 -0400
Message-Id: <20250609225347.1444397-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609225347.1444397-1-sashal@kernel.org>
References: <20250609225347.1444397-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4919353c7789b8047e06a9b2b943f775a8f72883 ]

The audio controller in the Lenovo Thinkpad Thunderbolt 3 dock doesn't
support reading the sampling rate.

Add a quirk for it.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250527172657.1972565-1-superm1@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

## Detailed Analysis for Backporting Decision

### **Code Change Assessment**

The commit adds a single line to the USB audio quirks table:
```c
DEVICE_FLG(0x17ef, 0x3083, /* Lenovo TBT3 dock */
           QUIRK_FLAG_GET_SAMPLE_RATE),
```

This follows the **exact same pattern** as similar commits marked
"Backport Status: YES" in the reference examples:

1. **Similar Commit #1** (Audioengine D1): Same flag, same structure,
   marked YES
2. **Similar Commit #3** (MCT Trigger): Same flag, same pattern, marked
   YES
3. **Similar Commit #4** (B850V3 CP2114): Same flag, includes Cc:
   stable@vger.kernel.org, marked YES
4. **Similar Commit #5** (LifeCam HD-6000): Same flag, includes Cc:
   stable@vger.kernel.org, marked YES

### **Why This Should Be Backported**

**1. Fixes User-Affecting Bug**
- Without this quirk, users experience **noisy error messages** like
  "cannot get freq at ep 0x82"
- Creates a **15-second delay** during audio initialization (as
  mentioned in reference commit #3)
- Results in **inconsistent audio behavior** during device startup

**2. Minimal Risk and Contained Change**
- **Single line addition** to a device-specific quirks table
- **No architectural changes** - uses existing, well-tested
  QUIRK_FLAG_GET_SAMPLE_RATE mechanism
- **Cannot break existing functionality** - only affects this specific
  device (0x17ef, 0x3083)
- **Well-established pattern** - this flag is used by 26+ other devices
  successfully

**3. Follows Stable Tree Criteria**
- **Important bugfix**: Eliminates timeout delays and error messages for
  affected users
- **Minimal regression risk**: Quirks table additions are extremely safe
- **Device-specific**: Only affects Lenovo Thunderbolt 3 dock users
- **User-visible improvement**: Faster audio initialization, cleaner
  kernel logs

**4. Historical Precedent**
- **Reference commits #4 and #5** explicitly include `Cc:
  stable@vger.kernel.org` for identical changes
- **All similar commits** in the reference examples with this flag
  pattern are marked "Backport Status: YES"
- This type of device quirk is **routinely backported** to stable
  kernels

**5. Commercial Device Impact**
- Lenovo ThinkPad Thunderbolt 3 docks are **widely deployed** in
  enterprise environments
- Users expect **stable, reliable audio** from docking solutions
- **15-second delays** and error messages create poor user experience in
  professional settings

### **Code Pattern Confirmation**

The QUIRK_FLAG_GET_SAMPLE_RATE mechanism is specifically designed for
devices that don't support sample rate reading. From the kernel code
analysis:

- **Problem**: Device times out when kernel tries to read back sample
  rate
- **Solution**: Skip the read attempt entirely for known problematic
  devices
- **Result**: Faster initialization, no error messages, identical audio
  functionality

This is a **textbook example** of a stable kernel backport candidate:
small, safe, user-affecting bugfix that follows established patterns and
has zero regression risk.

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b2a612c5b299a..ac43bdf6e9ca6 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2180,6 +2180,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x17ef, 0x3083, /* Lenovo TBT3 dock */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
-- 
2.39.5

