Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3FD44BC9A;
	Tue, 10 Mar 2026 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133332; cv=none; b=XoJ7Om8q2xLUP+jxEeDS4awVNvVEeAIc1DxyDZgPUZ0nSj7K7Ha2/2EBi1K7wlBKbf7qgUUcRcTNcwnGzGdWXx7hdmbvu5Pl/pYYz2JSoa9QRcmFvfAaDS/MKjGi0HwvWTLtph+taUCreMf18LZRWbGAEqk/CPTM69E9iiK8zls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133332; c=relaxed/simple;
	bh=uhnDnD5YsuKlqmWINLzsD9zKQLO/mP4iC+uOFUQP+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YN3uAW0vMXZpkyVxNtWLNaMh0xCjnGvKpMAm5r4OAg6JiaAGRGuGDGQ0CnRbX6QVgi4lYkNZP3G8dPqN46vwcFbO9/89vTusIgTqK+HgD3/5IODnQ3cg3nUwL7tb+6HdxaL/+zPKFNJc7DGPQflcUCnI39n9rw4ZMCxNke1gaZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nErRSjng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nErRSjng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0AEC19423;
	Tue, 10 Mar 2026 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133332;
	bh=uhnDnD5YsuKlqmWINLzsD9zKQLO/mP4iC+uOFUQP+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nErRSjngIgvwJwC2G3VDbuoa42aln00JnAEwV7DJuKudLaRhtT+VM/8Nhtr7p2DbW
	 NRBNhTyNGx+KyeeLyqqN8UczNnq1pEM3IP7PbU4yu3UVQ1V4JqrcNHOaNPQmIDm9oZ
	 v2pxVyy9ylIfL/pAzR10qYSLrSNEyUaq0spTzpDcpF2LQYyxs/mpdEaAqna7wSRGRs
	 AFnWpzNAK88TbYnW1cih1l9XkgIFg3QE840YC2DFNJki0dwrzpfuVfY9SoybtR+K9X
	 L2VwJmLFZDpI7ewV3m59lUMwcKsNyBAr+LhuPXi4Kez3CXegBWmCqoWsJkC6Zh3QdS
	 TrkFWV0bbUH2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Metz <peter.metz@unarin.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list
Date: Tue, 10 Mar 2026 05:01:17 -0400
Message-ID: <20260310090145.2709021-17-sashal@kernel.org>
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

From: Peter Metz <peter.metz@unarin.com>

[ Upstream commit 6b3fa0615cd8432148581de62a52f83847af3d70 ]

The Dell 14 Plus 2-in-1 (model DB04250) requires the VGBS allow list
entry to correctly enable the tablet mode switch. Without this, the
chassis state is not reported, and the hinge rotation only emits
unknown scancodes.

Verified on Dell 14 Plus 2-in-1 DB04250.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221090
Signed-off-by: Peter Metz <peter.metz@unarin.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260213044627.203638-1-peter.metz@unarin.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does

This commit adds a single DMI entry for the "Dell 14 Plus 2-in-1
DB04250" to the `dmi_vgbs_allow_list` in
`drivers/platform/x86/intel/hid.c`. This allow list controls which
devices can use the VGBS (Virtual GPIO Button Status) ACPI method to
report chassis/tablet mode state.

### Problem it solves

Without this entry, the Dell 14 Plus 2-in-1 cannot correctly report
tablet mode switch state. The hinge rotation only emits unknown
scancodes, meaning the device doesn't properly switch between laptop and
tablet modes. This is a real usability issue for owners of this specific
2-in-1 device.

### Classification: Hardware Quirk / Device Allow List Entry

This falls squarely into the **"QUIRKS and WORKAROUNDS"** exception
category for stable backports:
- It adds a device-specific DMI match to an existing allow list
- It fixes a real hardware issue (tablet mode not working)
- The pattern is identical to existing entries in the same list
  (multiple Dell, HP entries already present)

### Code change analysis

The diff is trivial — 6 lines added to insert a new `dmi_system_id`
struct into the `dmi_vgbs_allow_list` array, matching `DMI_SYS_VENDOR =
"Dell Inc."` and `DMI_PRODUCT_NAME = "Dell 14 Plus 2-in-1 DB04250"`. The
change follows the exact same pattern as the surrounding entries.

### Risk assessment

- **Risk: Extremely low.** The DMI match is specific to one device
  model. It cannot affect any other hardware.
- **Scope: Minimal.** 6 lines of declarative data, no logic changes.
- **Testing: Verified.** The commit message states "Verified on Dell 14
  Plus 2-in-1 DB04250."
- **Review: Thorough.** Reviewed by both Hans de Goede (platform/x86
  maintainer) and Ilpo Järvinen (Intel platform maintainer).

### Stable criteria check

1. **Obviously correct and tested**: Yes — verified on the hardware,
   reviewed by two maintainers
2. **Fixes a real bug**: Yes — tablet mode doesn't work without it
   (bugzilla #221090)
3. **Important issue**: Yes — core functionality of a 2-in-1 device is
   broken
4. **Small and contained**: Yes — 6 lines, single file, data-only change
5. **No new features**: Correct — enables existing functionality on
   specific hardware
6. **Applies cleanly**: Should apply cleanly as long as the surrounding
   entries exist

### Verification

- Verified the diff is a pure data addition to an existing DMI allow
  list array — no logic changes
- Confirmed the pattern matches existing entries in the same list (Dell
  Pro Rugged 10/12 Tablet entries directly above)
- The commit references bugzilla.kernel.org bug #221090, confirming a
  user-reported issue
- Reviewed-by tags from Hans de Goede and Ilpo Järvinen confirm
  maintainer approval
- The `dmi_vgbs_allow_list` structure is used in the existing
  `intel_hid_probe()` path — this is well-established code

### Conclusion

This is a textbook stable backport candidate: a tiny, zero-risk hardware
quirk addition that fixes real functionality for a specific device
model, with user bug report, hardware verification, and maintainer
review.

**YES**

 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 560cc063198e1..5b475a09645a3 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -189,6 +189,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell 14 Plus 2-in-1 DB04250"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0

