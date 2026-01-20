Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECF647CC8C;
	Tue, 20 Jan 2026 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937713; cv=none; b=s4slKv3b832oKcsjenVQjP7zjh0pAee6Fx0d0+FlZ15F6+WgYshNQc6nSUaqykbtMBGWrjNtiezUFLmD/T8iPEqD5zFDAKEI1eovVXy36J4wJg8tDELtaqSmULgG0/E10UXXI97lgkVUtKBH1T0BfxI4uOT0hlBPpT+Gv4EZpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937713; c=relaxed/simple;
	bh=3+RktV/VUeFhM+qWVy8bhJ59/5W85MFskK5fyREosDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOoX43YdUrOn5X4qAZF7d5P3MRPy7oKsmIoYbXJ6dtWfq+4/ZCmn9lxqtGJB+dKOEvOL/r2jYiNb+37EOhC5Uc/++Ir+jU7xZeOS5M2GLDZiRX4qUQfNZpt0XptKdZssj7TK/XKoiL1qRhgDrg8L4CvGW+AEIOWDbTDymRJUi5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shnvgnac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shnvgnac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8B1C16AAE;
	Tue, 20 Jan 2026 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937712;
	bh=3+RktV/VUeFhM+qWVy8bhJ59/5W85MFskK5fyREosDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shnvgnacZ7ufRERKhkaK0eKVgigMFdw8HHGc/LpMjxq4qt77FNLPeNOOs8SPrM4mw
	 Awj4iV6cuW66urt8aNB/c118aZKLS+7U8m33mKMF9Rcp3vh4yMZSsfBdG/0wb+pXY7
	 tGO+s64Ett8b3WMz/RNIFEElw6S2zTgDNAREF2zt9PeNZxqmbPsCHoQHoWwWc1pa34
	 yXTohXMaa/CpnlUSJqTCbW0GpB5qqtLAnviy6qCTtgWUwVE+Wn3h2+bt54eaeiYu8c
	 a1lVFzohUrv4NdDzxshQNL7GaxLwIzZ7ygJcjRZcP7D+gUTeuX8SjjeQOndWDB16y1
	 FUwwm6c1WxLag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/tas2781: Add newly-released HP laptop
Date: Tue, 20 Jan 2026 14:34:53 -0500
Message-ID: <20260120193456.865383-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 46b8d0888f01f250fbd24d00ff80b755c3c42cd4 ]

HP released the new laptop with the subid 0x103C.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20260115124907.629-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me summarize the analysis:

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS

The commit is titled "ALSA: hda/tas2781: Add newly-released HP laptop"
with subsystem ID 0x103C. This is a straightforward hardware enablement
commit.

- No "Fixes:" tag (expected for commits requiring manual review)
- No "Cc: stable" tag (expected)
- The commit enables audio hardware for HP laptops with TAS2781 codec

### 2. CODE CHANGE ANALYSIS

The actual code change is extremely minimal:
1. **Copyright year update**: `2023 - 2025` → `2023 - 2026` (cosmetic,
   harmless)
2. **Addition of HP case in switch statement**: 3 lines added to
   recognize HP vendor ID 0x103C and set `catlog_id = HP`

The switch statement determines which EFI GUID to use for reading
calibration data from UEFI. Without this case:
- HP laptops (subid 0x103C) fall into the `default` case and get
  `catlog_id = LENOVO`
- This means they use the LENOVO EFI GUID instead of the correct HP EFI
  GUID
- Calibration data wouldn't be found or would be incorrect

**Root cause**: Missing vendor ID case means the driver uses the wrong
EFI GUID for calibration data, leading to audio calibration failures on
HP laptops.

### 3. CLASSIFICATION

This is a **device ID/vendor ID addition** to an existing driver - one
of the explicit exceptions listed in the stable kernel rules. This falls
squarely into the "NEW DEVICE IDs" category:
- Adding a vendor/subsystem ID (0x103C for HP)
- The driver already exists and supports the TAS2781 codec
- HP support infrastructure (enum value, EFI GUID) already exists
- Only the vendor ID recognition is missing

### 4. SCOPE AND RISK ASSESSMENT

**Lines changed**: 4 (3 functional lines + 1 cosmetic copyright update)
**Files touched**: 1 (tas2781_hda_i2c.c)
**Complexity**: Extremely low - simple switch case addition
**Risk**: Minimal - only affects HP laptops (subid 0x103C); other
laptops unaffected

### 5. USER IMPACT

- **Who is affected**: Users with HP laptops containing TAS2781 audio
  codecs
- **Severity**: Without this fix, HP laptop audio may not work properly
  due to incorrect calibration data retrieval
- **Impact of change**: Enables proper audio on new HP hardware

### 6. STABILITY INDICATORS

- Signed off by the original driver author (Shenghao Ding)
- Accepted by ALSA maintainer (Takashi Iwai)
- Simple, obvious change with clear purpose

### 7. DEPENDENCY CHECK

**Critical consideration**: The commit applies to file
`sound/hda/codecs/side-codecs/tas2781_hda_i2c.c` which is a NEW location
- the file was moved in commit `6014e9021b28e` ("ALSA: hda: Move codec
drivers into sound/hda/codecs directory").

Checking stable trees:
- **6.16.y**: Has all infrastructure (HP enum, HP EFI GUID, file in old
  location `sound/pci/hda/`). The patch could apply with path
  adjustment.
- **6.15.y and older**: Do NOT have HP support infrastructure - the
  `device_catlog_id` enum only has `LENOVO=0` and `OTHERS`. No HP enum
  value, no HP EFI GUID. **Backporting is NOT possible without
  significant additional commits.**

### 8. BACKPORT FEASIBILITY

For **6.16.y stable**: The commit should be backported, but requires
path adjustment (`sound/hda/codecs/side-codecs/` → `sound/pci/hda/`).
All necessary infrastructure exists.

For **6.15.y and older**: NOT suitable for backport. Would require
backporting the entire HP infrastructure:
- The HP enum value
- The HP EFI GUID
- Possibly other architectural changes

The commit itself is clearly stable-worthy (device ID addition to
existing driver), but its applicability is limited to kernels that
already have the HP support infrastructure.

### Conclusion

This commit is a textbook example of a stable-appropriate change: a
simple vendor ID addition to an existing driver that enables hardware
support. It's small (3 functional lines), obviously correct, low risk,
and addresses a real user issue (HP laptops not working properly with
TAS2781 audio).

However, the backport is only applicable to kernels 6.16+ where the HP
infrastructure already exists. For older kernels, this would require
additional prerequisite commits.

**YES**

 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index f7a7f216d5865..3da1f138a191c 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -2,7 +2,7 @@
 //
 // TAS2781 HDA I2C driver
 //
-// Copyright 2023 - 2025 Texas Instruments, Inc.
+// Copyright 2023 - 2026 Texas Instruments, Inc.
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
 // Current maintainer: Baojun Xu <baojun.xu@ti.com>
@@ -568,6 +568,9 @@ static int tas2781_hda_bind(struct device *dev, struct device *master,
 	case 0x1028:
 		tas_hda->catlog_id = DELL;
 		break;
+	case 0x103C:
+		tas_hda->catlog_id = HP;
+		break;
 	default:
 		tas_hda->catlog_id = LENOVO;
 		break;
-- 
2.51.0

