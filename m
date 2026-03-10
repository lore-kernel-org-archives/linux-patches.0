Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DAB4657E2;
	Tue, 10 Mar 2026 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133347; cv=none; b=sCPN6eCo3aKTZEutKMXn1j3qXTBv0WKF9E5CrmDgPI6imMlVNsmQIJS2S+wpa8Dov47CkEzrXOPBGl0ucLjGUk+7p2WkmICLVcMP8UWL+c6875UwGTHANNrt3C3+5POsrXOWk3JWhtaIfagBxzYSEqgv4PXoR1li9g8rnhi7wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133347; c=relaxed/simple;
	bh=0MgA2icHUBbmT/KIBx7rZLbF7ERnRCvPbEcb/ZFRZwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLWd3kfqgkseNPODhLVodHjQypAS7xA3Vp2e0m3nU3qADZSjSxqZup5svmdMHkNmpAA/u5A+yQWynox+o7OewcND/1/R1FARYrhadq6b3BP7my/Bo0JPPvtXDJcUEIXIyNoCkU61Q7QYL7oMOVlI+WiM3OFNvaY2tW29FwBOOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAKdLaZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAKdLaZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5FEC2BC87;
	Tue, 10 Mar 2026 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133347;
	bh=0MgA2icHUBbmT/KIBx7rZLbF7ERnRCvPbEcb/ZFRZwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAKdLaZP8B+K7/YxPvtxIOoNvRcfUog7I8MVBURmmuLn2uHumQzrCWm/ArMyP2T3S
	 3dsGb034atUKQzaKFlUwamNus6f7BUSnp2pD9xtXD4XNV0HjhknoegJ+xQM6tgV7oI
	 t7CCMfO3fUqYTLeeBUdbAGjILHqKGXkeR3zsOFJwiNcIy5l6JLPsnFc57fGZcoNdMy
	 cWI7KHoXtm+SCs8AABp1j2w2DvawEG4gRpu25DIQcvmBysPgIk+WFKnoxLTrkFh7nj
	 qmzk/CCh2hdaFDr4Z3oqod3PT7a8610bI7oh93+11Lwd08rDuB9p3fx2z3mM7qFulE
	 i3YKwo9uLOmtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chomal <krishna.chomal108@gmail.com>,
	Noah Provenzano <noahpro@gmail.com>,
	Juan Martin Morales <juanm4morales@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] platform/x86: hp-wmi: Add Omen 16-wf0xxx fan and thermal support
Date: Tue, 10 Mar 2026 05:01:28 -0400
Message-ID: <20260310090145.2709021-28-sashal@kernel.org>
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

[ Upstream commit 13fa3aaf02edaad9b41fc61d7f6326d2b6a4bf80 ]

The HP Omen 16-wf0xxx (board ID: 8BAB) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to HP Omen 16-wf1xxx, board ID: 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on HP Omen 16-wf0xxx confirmed that platform profile is
registered successfully and fan RPMs are readable and controllable.

Suggested-by: Noah Provenzano <noahpro@gmail.com>
Tested-by: Juan Martin Morales <juanm4morales@gmail.com>
Reported-by: Juan Martin Morales <juanm4morales@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220639
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260216072003.90151-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Summary
This commit adds a single DMI board name entry ("8BAB" for HP Omen
16-wf0xxx) to the `victus_s_thermal_profile_boards[]` table in the HP
WMI driver, mapping it to existing `omen_v1_thermal_params`. This
enables fan RPM reading/control and thermal profile switching on this
specific laptop model.

### Classification: Hardware Quirk / Device ID Addition

This falls squarely into the **"QUIRKS and WORKAROUNDS"** and **"NEW
DEVICE IDs"** exception categories for stable:

- **Change scope**: Adding 4 lines — a single new DMI match entry to an
  existing quirk table
- **Pattern**: Identical to how other board IDs (8BBE, 8BCD, 8BD4, 8BD5,
  8C78) are already registered in the same table
- **Risk**: Zero risk to other hardware — the DMI_MATCH on "8BAB" only
  affects that specific board
- **No new code paths**: Uses existing `omen_v1_thermal_params` (same as
  the 8BCD and 8C78 entries already in the table)

### User Impact
- Without this entry, the HP Omen 16-wf0xxx laptop lacks proper thermal
  profile management and fan control via the platform profile interface
- Real users reported this issue (bugzilla #220639)
- Tested on actual hardware by the reporter

### Stable Criteria Assessment
- **Obviously correct**: Yes — trivial table entry addition following
  exact pattern of existing entries
- **Fixes a real issue**: Yes — enables hardware support for a specific
  laptop (hardware quirk)
- **Small and contained**: Yes — 4 lines, single file, single table
- **No new features/APIs**: Correct — just extends existing mechanism to
  new hardware
- **Tested**: Yes — `Tested-by` tag from the reporter confirms it works
- **Reviewed**: Yes — by subsystem maintainer Ilpo Järvinen

### Risk Assessment
- **Risk**: Essentially zero. The DMI match is board-specific and cannot
  affect any other system.
- **Benefit**: Enables thermal/fan control for HP Omen 16-wf0xxx users
  on stable kernels.
- **Dependencies**: None — `omen_v1_thermal_params` and the
  `victus_s_thermal_profile_boards[]` table infrastructure already exist
  in any kernel version that has the other entries.

### Verification
- Verified the diff is a trivial 4-line addition to an existing DMI
  match table — confirmed by reading the patch
- Verified it reuses existing `omen_v1_thermal_params` (same as 8BCD and
  8C78 entries in the same table) — confirmed in the diff context
- Verified the commit has Tested-by, Reported-by, and Reviewed-by tags —
  confirmed in commit message
- Verified bugzilla link exists (bug #220639) — present in commit
  message
- Verified this matches the "device ID / hardware quirk" exception
  pattern — it's structurally identical to adding a PCI/USB device ID to
  a driver's ID table

This is a textbook example of a hardware quirk addition that is
appropriate for stable trees: trivially small, zero risk, tested on real
hardware, and enables functionality for real users.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 24d065ddfc6ae..9fcc18635e4e7 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -160,6 +160,10 @@ static const char * const victus_thermal_profile_boards[] = {
 
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst = {
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BAB") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.51.0

