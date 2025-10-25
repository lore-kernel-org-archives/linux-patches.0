Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98615302756;
	Sat, 25 Oct 2025 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408607; cv=none; b=S7J0Wbxsa6vuvzraS6d87SpIcVquDYyZcvavLzWuf1gL43jncpEF5RF8lurBHJDiPgyNxm3n/uiKEo+jS+iK1+fbmZctrmYYQcum1ORrzg18sqFAow3iNaqZHjqMlzuHHYs3JnHJ2V74mY8ZA754XaIxZtEAkoR628x1J2d1beY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408607; c=relaxed/simple;
	bh=MD1B1K5MUsN2t9RtNARWWCjlCwNLG0jKesxjy5IjSwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tje4m6DHxuM4CcZPs/V9Ifa6zIjTUW2NHPS8YvhekZ7bZMwEhinkKdmhZYt0ypQpguMmIdDzzgC0edYdDe1lJ0FczMC8ZI9mu50B50IxZtON65KgOw/60nnLmuK83Jd9zg5xGE8rcNM0C2pa0SKZlnlngS7nkHLCYtDdQejKrro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5cXVOpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5cXVOpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4416AC4CEFB;
	Sat, 25 Oct 2025 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408607;
	bh=MD1B1K5MUsN2t9RtNARWWCjlCwNLG0jKesxjy5IjSwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5cXVOpPLspRqRIUYO96TNQJTFoQd3/BiXquhlTljbGnTP84qJElgGdIRWOEiXOkY
	 ex2zGsbGGsYphR60AL8/bcf9adDvkGi4fD4Mb2A9z9MFHYbS2zKi3+sNzApS0DCIMq
	 d4vXJtGrQr3kpK1TzeWOxX8VXVV47rXBhVhsOLYvuJirWjpRXrHZBciTOyWQzHS56+
	 tBDxN4sKY1Orx5rM9Za8CnrVNd6s01mia0JA45c+zVos3/MRbPt9ipWzua9nFW75+j
	 f4n6R6RPfeE/mVh9jkHUXean7P4Qs7mtkhtH5XrLAxymdtgpVKjk8RnT7oSWOflxoH
	 GPLd0dFgewikA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cryolitia PukNgae <cryolitia@uniontech.com>,
	Guoli An <anguoli@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia.pukngae@linux.dev,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	kuninori.morimoto.gx@renesas.com,
	pav@iki.fi
Subject: [PATCH AUTOSEL 6.17-5.4] ALSA: usb-audio: apply quirk for MOONDROP Quark2
Date: Sat, 25 Oct 2025 11:54:11 -0400
Message-ID: <20251025160905.3857885-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cryolitia PukNgae <cryolitia@uniontech.com>

[ Upstream commit a73349c5dd27bc544b048e2e2c8ef6394f05b793 ]

It reports a MIN value -15360 for volume control, but will mute when
setting it less than -14208

Tested-by: Guoli An <anguoli@uniontech.com>
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250903-sound-v1-4-d4ca777b8512@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The device reports a minimum volume of -15360 (in 1/256 dB units),
    but actually hard-mutes for values below -14208. The quirk clamps
    the minimum to -14208 so users can’t set into the “mute” region by
    mistake. This is a clear, user-visible bugfix for a specific device.

- Change scope and exact code
  - Adds a device-specific case in `volume_control_quirks()` for
    MOONDROP Quark2 that adjusts only the minimum volume:
    - `sound/usb/mixer.c:1185` adds `case USB_ID(0x3302, 0x12db): /*
      MOONDROP Quark2 */`
    - `sound/usb/mixer.c:1186` matches only the “PCM Playback Volume”
      control name
    - `sound/usb/mixer.c:1189` sets `cval->min = -14208; /* Mute under
      it */`
  - The quirk function is the standard place for device-specific mixer
    adjustments:
    - Function definition: `sound/usb/mixer.c:1074`
    - It’s invoked during control initialization so the bounds are fixed
      before dB TLVs are computed and exposed:
      - Call site: `sound/usb/mixer.c:1303`
      - dB computation follows immediately and will reflect the
        corrected range: `sound/usb/mixer.c:1308`
  - If reading the current value fails, ALSA initializes to `cval->min`;
    this change therefore also makes the default safe for this device:
    - Default fallback to min: `sound/usb/mixer.c:1210`

- Precedent and pattern consistency
  - This is consistent with existing per-device volume quirks in the
    same function, e.g.:
    - CM102-A+/102S+ sets only `min`: `sound/usb/mixer.c:1142` and
      `sound/usb/mixer.c:1146`
    - QuickCam E3500 adjusts min/max/res:
      `sound/usb/mixer.c:1167`–`sound/usb/mixer.c:1173`
    - UDA1321/N101 adjusts only `max` under a condition:
      `sound/usb/mixer.c:1150`–`sound/usb/mixer.c:1165`
    - ESS Asus DAC adjusts min/max/res for certain control names:
      `sound/usb/mixer.c:1177`–`sound/usb/mixer.c:1183`
  - Using control-name matching (“PCM Playback Volume”) plus a USB
    VID:PID gate is a well-established, low-risk approach for usb-audio
    quirks.

- Risk assessment
  - Minimal footprint: a few lines, isolated to `sound/usb/mixer.c` and
    gated by exact USB ID and control name.
  - No architectural changes; affects only mixer bounds for this one
    device.
  - Does not alter `cval->max` or `cval->res`, limiting behavioral
    change solely to the lower bound.
  - Ensures users cannot select values that lead to unexpected hard
    mute. Improves UX and correctness.

- Stable backport criteria
  - Fixes a real-world, user-visible malfunction on a shipping device.
  - Small, contained, and consistent with existing quirk patterns.
  - Very low regression risk due to strict USB ID and control-name
    filtering.
  - While there’s no explicit “Cc: stable” tag, usb-audio quirk fixes of
    this form are routinely backported.

Conclusion: This is a textbook stable-worthy quirk fix. It should be
backported to supported stable trees that contain
`volume_control_quirks()` in `sound/usb/mixer.c`.

 sound/usb/mixer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 63b300bc67ba9..cf296decefefc 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1191,6 +1191,13 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 			cval->res = 1;
 		}
 		break;
+	case USB_ID(0x3302, 0x12db): /* MOONDROP Quark2 */
+		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
+			usb_audio_info(chip,
+				"set volume quirk for MOONDROP Quark2\n");
+			cval->min = -14208; /* Mute under it */
+		}
+		break;
 	}
 }
 
-- 
2.51.0

