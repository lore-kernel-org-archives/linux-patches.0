Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A936BCE3;
	Mon,  9 Feb 2026 12:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640045; cv=none; b=Te0+rTG1DlRyQUsy69h8uXvfJpmjCbXP1dViMxtUJT9Wu1RlV6bjaZC5XRpxJFOK5FKI17zlSJfE4g3RrPMLdYaCCMZGWIQ3SOyI4JRwA1nPy6lkQNtoDMpgQZCqnIEz8fkRUTYgPKt/dwKIAy8/nvK3/zerd2U1vvjEEdiFkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640045; c=relaxed/simple;
	bh=638MVGxwchqEQPFUy6gSw2ttX15kbRZBSaH1y73JEX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGVsERw0Ej0p86f/6DRaBbcWQQwZIkOcqYriW5pdGeKqgLBr1ZPdRNNufDwJ88cPr9xNqRz4LeSMoVs++HgfBUgYrUMW7uMYEw21XmUQl+97f6Lerz+mJ2chcn1GlU4JMDEie4lrROX8UZMCDkyTH+ZcSoxs4c2qjI/AYnTFNnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJ83jZ9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJ83jZ9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7DEC16AAE;
	Mon,  9 Feb 2026 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640044;
	bh=638MVGxwchqEQPFUy6gSw2ttX15kbRZBSaH1y73JEX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJ83jZ9DtDYWbaBQa2JXTv6SolW3l/s04WDEdqyWYA6GlTubH0YDFZD+bmdGxeeLQ
	 cwEwXPaJ0RRpkKTJK6sv7uaTMrcfo5l+c7EmYQ5C8g3T6o+HSK0jLLiNPyXmxNEY+o
	 jsHNrE3Gumt9S0vzv36WkQvXFHtra5arLG3p8+h7A/P900enegyhMUzjVh3FiT7M02
	 PdCEPW4i/jxLSsUPCu0GdXiTquQO+drbFrqm9AI62ivX+beLsokhZx6pUdUYqLBOMd
	 Z0keimdtrRnmbj5paWnINttJeAgFLW4JuwgApU2hS9q8MRc0CV803pcJ2B1qcyhU4N
	 W4EYL0zIOCf7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: gongqi <550230171hxy@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro
Date: Mon,  9 Feb 2026 07:26:44 -0500
Message-ID: <20260209122714.1037915-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

From: gongqi <550230171hxy@gmail.com>

[ Upstream commit 2b4e00d8e70ca8736fda82447be6a4e323c6d1f5 ]

The MECHREVO Wujie 15X Pro suffers from spurious IRQ issues related to
the AMD PMC. Add it to the quirk list to use the spurious_8042 fix.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-4-550230171hxy@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds a DMI-based hardware quirk for the MECHREVO Wujie 15X
Pro laptop to the AMD PMC quirk list. The laptop suffers from **spurious
IRQ issues** related to the AMD PMC, and the fix applies the existing
`quirk_spurious_8042` workaround.

### Code Change Analysis

The change is a simple addition of a new DMI match entry to the
`fwbug_list[]` array:

```c
{
    .ident = "MECHREVO Wujie 15X Pro",
    .driver_data = &quirk_spurious_8042,
    .matches = {
        DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
    }
},
```

This is **7 lines of new code** added to an existing quirk table. It
follows the exact same pattern as all the other entries in the table
(e.g., TUXEDO Stellaris, TUXEDO InfinityBook Pro, etc.). The quirk
mechanism (`quirk_spurious_8042`) already exists and is well-tested —
this commit simply adds another machine to the list of affected devices.

### Classification: Hardware Quirk

This falls squarely into the **"QUIRKS and WORKAROUNDS"** exception
category for stable backports:
- It's a hardware-specific quirk for a device with broken/buggy behavior
- It uses an existing, well-tested quirk mechanism
- It only affects the specific laptop model matched by DMI
- Without this quirk, the laptop experiences spurious IRQ issues which
  can cause problems during suspend/resume (a real user-facing bug)

### Scope and Risk Assessment

- **Lines changed**: 7 (addition only)
- **Files touched**: 1 (`pmc-quirks.c`)
- **Risk**: Essentially zero. The DMI match ensures this code only
  activates on the specific MECHREVO Wujie 15X Pro laptop. No other
  hardware is affected.
- **Dependencies**: None — the `quirk_spurious_8042` data structure and
  the quirk application mechanism already exist in stable trees.

### User Impact

- Users of the MECHREVO Wujie 15X Pro laptop experience spurious 8042
  IRQ issues related to the AMD PMC
- Without this quirk, the laptop likely has problems with suspend/resume
  functionality
- This is a real hardware issue affecting real users of this specific
  laptop model

### Stability Indicators

- The commit was reviewed and accepted by Ilpo Järvinen (Intel platform
  maintainer)
- It follows an established pattern with many identical entries in the
  same table
- The quirk mechanism is proven and used by multiple other laptops

### Conclusion

This is a textbook example of a hardware quirk addition that is
appropriate for stable backport. It's small, contained, zero-risk to
other hardware, fixes a real user-facing issue (spurious IRQs), and uses
an already-existing mechanism. The pattern is identical to dozens of
other quirk entries that regularly get backported.

**YES**

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 404e62ad293a9..ed285afaf9b0d 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -302,6 +302,13 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
 		}
 	},
+	{
+		.ident = "MECHREVO Wujie 15X Pro",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0

