Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BE94508F2;
	Tue, 10 Mar 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133345; cv=none; b=iNhkBV7SGmlmuguVnX7k4ApQNWM7um3q5FupWI0CfxlNR5FS1Q8swRzt5wfgDNh1xsyFn+Pemod4m7qota5g5ifktUXbNHNE4rkeO8mnsK/HrW19Ur0FcIpMBLH+4+onrHQWAgcdlCW5E5vX9JGNvyTW9Iv7E1WZ7lPt5CibZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133345; c=relaxed/simple;
	bh=LR8yxGsfAO5JGNEsZtgdYEhWHG34ymOAfWN9E2eLdfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOMQ9BMaGKKZPk6iO9AqebLLe97molWl2ib8m1LbkKJEFXq/GNuFkMkHQ/DTTPAbDSGtzGHqaCn/ERYabIA2URmFYvAshbvSVLQxsrOyOOfvXMZ5gaOM8ITV9z2ollA3YJPCCmdIBsvkJULImNDokLlhm4lSKyAsrJ9kEHbBpFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sznofwif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sznofwif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D9C19423;
	Tue, 10 Mar 2026 09:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133344;
	bh=LR8yxGsfAO5JGNEsZtgdYEhWHG34ymOAfWN9E2eLdfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sznofwifwPyQTC1ssSDdDpojKbSxmKl2OVlyf2K8/L2U71ukNW4hJtS37Y0ywsj5b
	 MJMLORHPq4U07vUXKagfiQUnHFhidq9JAqXq91A9qD3dlvh2xNHndSeAr5xyDBZv0p
	 oKdriK3XA3FoBvRJS/aseIS3JRUX5tZnOHqmBZrasQdTnOANnU/5y7amQhq7Qn8Fbk
	 P2Cb9N1G42FtwY0VUReLkmwXSiPMBJgiaTgvzAbAGuiLpwuy8nu1XQ656PHxSen0FY
	 hruYAAjDjKeo/7y9aedSG3BucSO2FDGTcbkyngDS6ONgledMTDl8NMAjFt4J9n0/n9
	 zhOWURrV27koQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chomal <krishna.chomal108@gmail.com>,
	Varad Amol Pisale <varadpisale.work@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] platform/x86: hp-wmi: Add Omen 16-xd0xxx fan and thermal support
Date: Tue, 10 Mar 2026 05:01:26 -0400
Message-ID: <20260310090145.2709021-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 3c99a545b372c77b5d39715968a141f523eccbf2 ]

The HP Omen 16-xd0xxx (board ID: 8BCD) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to HP Omen 16-wf1xxx, board ID: 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on HP Omen 16-xd0xxx confirmed that platform profile is
registered successfully and fan RPMs are readable and controllable.

Tested-by: Varad Amol Pisale <varadpisale.work@gmail.com>
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260218050235.94687-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

This commit adds a DMI board name entry ("8BCD") for the HP Omen
16-xd0xxx laptop to the `victus_s_thermal_profile_boards[]` table,
mapping it to `omen_v1_thermal_params`. This is a hardware quirk/device
ID addition to an existing driver.

### Change Classification

This is a **hardware quirk addition** — one of the explicitly allowed
exception categories for stable backports. The change:
- Adds exactly 4 lines to an existing DMI matching table
- Uses an already-existing parameter set (`omen_v1_thermal_params`)
- Only affects the specific board ID "8BCD" (HP Omen 16-xd0xxx)
- Follows the exact same pattern as other entries in the table (e.g.,
  board "8C78" also uses `omen_v1_thermal_params`)

### Risk Assessment

**Extremely low risk:**
- The change is confined to a single DMI match table — it cannot affect
  any other hardware
- It uses existing infrastructure (`omen_v1_thermal_params`) that is
  already tested with board "8C78"
- The commit has both `Tested-by` and `Reviewed-by` tags from the
  subsystem maintainer (Ilpo Järvinen)
- No code logic changes, no new functions, no new data structures

### User Impact

Without this entry, HP Omen 16-xd0xxx users cannot:
- Control fan speeds through the platform profile interface
- Switch thermal profiles (performance/balanced/quiet)

This is real hardware enablement for real users — the "Tested-by" from a
different person than the author confirms at least two users need this.

### Stable Criteria Check

- **Obviously correct**: Yes — trivial table entry addition matching
  existing patterns
- **Fixes real issue**: Yes — enables hardware control on specific
  laptop (quirk category)
- **Small and contained**: Yes — 4 lines in one file
- **No new features/APIs**: Correct — uses existing driver
  infrastructure
- **Tested**: Yes — explicitly tested on the hardware

### Verification

- Verified the diff is purely a table entry addition to
  `victus_s_thermal_profile_boards[]` — no code logic changes
- Verified `omen_v1_thermal_params` is already used by board "8C78" in
  the same table, confirming it's an existing, tested parameter set
- Verified the commit has `Tested-by: Varad Amol Pisale` and `Reviewed-
  by: Ilpo Järvinen` (subsystem maintainer)
- Verified the change follows the exact DMI_MATCH pattern used by all
  other entries in the table
- The commit message explicitly states "Testing on HP Omen 16-xd0xxx
  confirmed that platform profile is registered successfully and fan
  RPMs are readable and controllable"

This is a textbook hardware quirk addition — small, safe, tested, and
enables real hardware for real users. It matches the stable exception
for device quirks/IDs perfectly.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 9fcc18635e4e7..bc550da031fa1 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -168,6 +168,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BCD") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD4") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.51.0

