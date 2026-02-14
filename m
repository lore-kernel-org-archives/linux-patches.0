Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ECF3EBF2C;
	Sat, 14 Feb 2026 01:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030995; cv=none; b=UFGsnFHaKn4T4ja0NQP5O+QfeXdiC/JRXPI5FQNVUmVVHw+oX/JSvOXU6UDu2dNpsx22rh0s4yNBNcVAHDHzhjICUE0CK3rnGkn4YhFHcd8iiVxFCIyb89fgiFaakegzCBL/cLBuoabhpaMccdr61cjrj4Zh7tn/0ZS1cvJUeWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030995; c=relaxed/simple;
	bh=RhXjg4zDobOMLNOMmuAqdHXzgxH7E7RKn3tniYRXLis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ+R6Qmu4+4TMFCCgBfgoMJUzD7uQgJ00srqsw375rQ7E6Eiu/gtVgy6P06zRgFa5Web2oGailHcndpLSBjfkXpnob5QY0tEeVZphvyZi5oH9A4l+Z0m3ajJN0i8RYfxlJeTXe+Kpbx8jvztybT97w3gB7dkOZ6/uhHcqnDP1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2WB94f6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2WB94f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF2AC19424;
	Sat, 14 Feb 2026 01:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030995;
	bh=RhXjg4zDobOMLNOMmuAqdHXzgxH7E7RKn3tniYRXLis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2WB94f6tg4S4JaySUk/cUmKX82/gpKoydG7fIMdkyT069hJL/FN3snBHNagEfoix
	 RixH7lEZQPOl9u07WXDya3v1dwKRjlD1Up3BZKv6JZoe685/2B6wXinvV9jAVlfdAe
	 uPlmfVB80DyvPj4MO9RHLtD+LReVQQvZVLwYx49UFV0QVgfctOJrcZ8SzCUS9go/A1
	 rOhF11rpJ7AqUpEYK+hswWbm7qxd1OtxwH5AmRGZOuAL8o8r28eo8xEpR5KAfwpTED
	 bke0wVXN+Y710WdYvZFBJenXxvR4XMGeUF6mVBMBxD/2dFp3yIOQzdqzvxlxcKSpzD
	 H7OirnTPRMqQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Val Packett <val@packett.cool>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/panel-edp: Add AUO B140QAX01.H panel
Date: Fri, 13 Feb 2026 19:58:17 -0500
Message-ID: <20260214010245.3671907-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Val Packett <val@packett.cool>

[ Upstream commit bcd752c706c357229185a330ab450b86236d9031 ]

A 14-inch 2560x1600 60Hz matte touch panel, found on a Dell Latitude 7455
laptop (second-source with BOE NE14QDM), according to online sources it's
also found on the Latitude 7440 and some ASUS models.

Raw EDID dump:

00 ff ff ff ff ff ff 00 06 af a4 0b 00 00 00 00
00 20 01 04 a5 1e 13 78 03 ad f5 a8 54 47 9c 24
0e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 f0 68 00 a0 a0 40 2e 60 30 20
35 00 2d bc 10 00 00 1a f3 53 00 a0 a0 40 2e 60
30 20 35 00 2d bc 10 00 00 1a 00 00 00 fe 00 36
39 52 31 57 80 42 31 34 30 51 41 58 00 00 00 00
00 02 41 21 a8 00 01 00 00 1a 41 0a 20 20 00 a1

Don't have datasheet access, but the same timing as for other panels from
the same manufacturer works fine.

Signed-off-by: Val Packett <val@packett.cool>
[dianders: Moved to the right location in the table]
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251206173739.2222940-1-val@packett.cool
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is the same author (Val Packett), same laptop (Dell Latitude 7455),
and a second-source panel for it. Let me verify this is a pure one-line
panel ID addition and check the exact diff once more.

The commit message itself says this AUO B140QAX01.H is a "second-source
with BOE NE14QDM" -- meaning the Dell Latitude 7455 can come with either
panel, and the BOE variant was already added.

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit adds a new eDP panel entry for the **AUO B140QAX01.H** panel.
Key details:
- 14-inch 2560x1600 60Hz matte touch panel
- Found on real shipping hardware: **Dell Latitude 7455**, Dell Latitude
  7440, and some ASUS models
- It's a second-source panel alongside the already-listed BOE NE14QDM
- Author has the actual hardware and tested it
- Reviewed by Douglas Anderson (the `panel-edp` subsystem maintainer)

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** to the `edp_panels[]` table:

```c
EDP_PANEL_ENTRY('A', 'U', 'O', 0x0ba4, &delay_200_500_e50,
"B140QAX01.H"),
```

This uses:
- The existing `EDP_PANEL_ENTRY` macro
- An existing delay structure `delay_200_500_e50` (used by nearly all
  other AUO panels in the table)
- Placed in the correct sorted position (after 0x04a4, before 0x105c)

There is **zero new logic, zero new delay structures, zero new
functions** -- it is purely a data table entry.

### 3. CLASSIFICATION: Device ID / Hardware Enablement

This falls squarely under the **"NEW DEVICE IDs"** exception category
for stable backports:
- Adding a panel ID to an existing driver (`panel-edp.c`)
- The driver infrastructure already exists in all stable trees where
  `panel-edp.c` exists
- The `delay_200_500_e50` delay structure already exists
- The `EDP_PANEL_ENTRY` macro already exists

### 4. USER IMPACT: What happens without this entry?

Looking at the code in `generic_edp_panel_probe()` (lines 805-825):

```809:825:drivers/gpu/drm/panel/panel-edp.c
        /*
  - We're using non-optimized timings and want it really obvious that
  - someone needs to add an entry to the table, so we'll do a WARN_ON
  - splat.
         */
        if (WARN_ON(!panel->detected_panel)) {
                dev_warn(dev,
                         "Unknown panel %s %#06x, using conservative
timings\n",
                         vend, product_id);
                panel_edp_set_conservative_timings(panel, desc);
        } else {
                dev_info(dev, "Detected %s %s (%#06x)\n",
                         vend, panel->detected_panel->ident.name,
product_id);
                /* Update the delay; everything else comes from EDID */
                desc->delay = *panel->detected_panel->delay;
        }
```

Without this entry:
1. A **WARN_ON** fires in the kernel log (a kernel warning/splat) every
   boot on affected Dell/ASUS laptops
2. The panel falls back to **conservative timings** (`unprepare=2000ms`,
   `enable=200ms`) instead of the proper timings (`hpd_absent=200ms`,
   `unprepare=500ms`, `enable=50ms`), meaning **noticeably slower
   display initialization** with unnecessary delays
3. The WARN_ON trace in dmesg can confuse users and show up in automated
   bug reporting tools

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 line added
- **Files changed**: 1 file
- **Risk**: Essentially zero. This is a pure data addition to a lookup
  table. It cannot affect any other panel or any other code path. The
  entry only matches when the EDID panel ID is exactly `AUO 0x0ba4`.
- **Dependencies**: None. Uses only existing macros and delay
  structures.

### 6. STABILITY INDICATORS

- **Reviewed-by**: Douglas Anderson (the panel-edp maintainer for
  ChromeOS/DRM)
- **Tested**: Author has the actual Dell Latitude 7455 hardware
- **Pattern**: Identical to dozens of other panel additions in this file
  (e.g., BOE NE14QDM for the same laptop was added similarly)

### 7. DEPENDENCY CHECK

No dependencies. The `EDP_PANEL_ENTRY` macro and `delay_200_500_e50`
structure have existed in the kernel for years, well before any current
stable tree branch points. This will apply cleanly to any stable tree
that has the panel-edp driver.

## Conclusion

This is a textbook example of a **device ID addition to an existing
driver** -- one of the explicitly allowed exception categories for
stable backports. It:

- Is a single-line data table entry with zero risk of regression
- Fixes a real user-visible issue (WARN_ON splat + degraded display
  timing on Dell Latitude 7455/7440 and some ASUS laptops)
- Uses only existing infrastructure (macro, delay structure)
- Has been reviewed by the subsystem maintainer
- Has been tested on real hardware
- Will apply cleanly to stable trees

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 2c35970377431..85dd3f4cb8e1c 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1880,6 +1880,7 @@ static const struct panel_delay delay_80_500_e50_d50 = {
  */
 static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x04a4, &delay_200_500_e50, "B122UAN01.0"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0ba4, &delay_200_500_e50, "B140QAX01.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x105c, &delay_200_500_e50, "B116XTN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1062, &delay_200_500_e50, "B120XAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x125c, &delay_200_500_e50, "Unknown"),
-- 
2.51.0

