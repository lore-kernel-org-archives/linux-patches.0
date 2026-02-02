Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD95B2D8DD1;
	Mon,  2 Feb 2026 21:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068819; cv=none; b=gER4561Vv2xcViEur0QE//BcDWNH4by3D38wIe4TdsvxouYDRgzyBr50ikfvxxta0aPq9JADbaZAhJBCTlFktM+svtpSUzRwOnlVU2qhAXNenztLW1sGYpKiKnfdmoeQKMz0WjbK0Z5A4SbQkEBvCe3jonXsYoaIAM2miFA2X4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068819; c=relaxed/simple;
	bh=NknloM3UgmhQbzEKuWRyPxaQBCzv3bw270ZuTX7nBb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=th5TAnEbLgzRXlPMrQtapqIvh4lzFCXWt015kSBzs2+ZFF0VJU3M9Ujm4VutD5Dfl3zcoQVJNvu4AOzLmYyYsoY35beJ95YDgI9fGT+93piH3kNrw6EucTnvrommG6aoqWuouR+xRs/FR+j6OL7UQJjXRSgYgvi/PfQTcrQMEWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEta8zrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEta8zrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641F1C2BC9E;
	Mon,  2 Feb 2026 21:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068819;
	bh=NknloM3UgmhQbzEKuWRyPxaQBCzv3bw270ZuTX7nBb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEta8zrQNnoFVjlRhn8g30g9K/sOKPkWd8oyPpoTTY1blGYhWlwd8L9t5/N/teEsm
	 +JSFWP3m/18jeVbxOSdljpE1PO7o9eFHkNajMycc2I3STG47/eccbTzBu/GxJCgg42
	 cO7B5Ctv8IrSegAyGCStgX2N6xBEbR8NwaWGuxUCeErlsuYJChwp4ABwUZVkJAB2Oa
	 jyY4UqQeLg2l2ZIEaQYppD88N01s7z1TLTKCfIeujbjcGpqL6rvAEQHF8LqOwz9pwe
	 1FXDL0pUwb8gZF5UJWPSEyQ2mlUVUA86oQi42rZc+tp8mG+wFrNXpiLb9XZAhnrHxj
	 AYUXSrKHkOtnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anatolii Shirykalov <pipocavsobake@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	keenplify@gmail.com,
	yuzuru_10@proton.me,
	oliver.schramm97@gmail.com,
	santesegabriel@gmail.com,
	talhah.peerbhai@gmail.com,
	alex.andries.aa@gmail.com,
	queler@gmail.com,
	bajahawradhi@gmail.com,
	zhangheng@kylinos.cn
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list
Date: Mon,  2 Feb 2026 16:46:01 -0500
Message-ID: <20260202214643.212290-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anatolii Shirykalov <pipocavsobake@gmail.com>

[ Upstream commit 018b211b1d321a52ed8d8de74ce83ce52a2e1224 ]

Add ASUS ExpertBook PM1503CDA to the DMI quirks table to enable
internal DMIC support via the ACP6x machine driver.

Signed-off-by: Anatolii Shirykalov <pipocavsobake@gmail.com>
Link: https://patch.msgid.link/20260119145618.3171435-1-pipocavsobake@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks
list

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and straightforward:
- **Purpose**: Add a new device (ASUS ExpertBook PM1503CDA) to the DMI
  quirks table
- **Goal**: Enable internal DMIC (Digital Microphone) support via the
  ACP6x machine driver
- **Tags present**: Signed-off-by (author and maintainer), Link to patch
  submission
- **No Fixes: or Cc: stable tags**: As expected for commits requiring
  manual review

The commit is submitted by an external contributor and accepted by Mark
Brown (the ASoC maintainer), indicating it has been reviewed.

### 2. CODE CHANGE ANALYSIS

The diff shows:
- **Single file changed**: `sound/soc/amd/yc/acp6x-mach.c`
- **Lines added**: 7 lines (one new DMI table entry)
- **Lines removed**: 0

The change adds a new entry to the `yc_acp_quirk_table[]` array:
```c
{
    .driver_data = &acp6x_card,
    .matches = {
        DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
        DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK PM1503CDA"),
    }
},
```

This is a **boilerplate DMI quirk entry** identical in structure to all
surrounding entries in the table. It simply associates this specific
ASUS laptop model with the `acp6x_card` driver data.

### 3. CLASSIFICATION

This commit falls squarely into the **"QUIRKS and WORKAROUNDS"**
exception category for stable backports:

- It adds a hardware-specific quirk for a device that needs special
  handling
- The driver already exists in stable trees (ACP6x AMD audio driver)
- Without this entry, the internal microphone on this laptop model does
  not work
- This is a **real hardware enablement fix** - users of this ASUS laptop
  cannot use their built-in microphone without it

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: Minimal - 7 lines of trivial, templated code
- **Complexity**: None - exact copy of existing patterns in the same
  file
- **Files touched**: 1
- **Subsystem**: ASoC AMD audio driver (mature, stable)
- **Risk of regression**: **Extremely low**
  - The DMI matching only triggers on this specific laptop model
  - It cannot affect any other system
  - The `acp6x_card` driver data is already used by dozens of other
    entries

### 5. USER IMPACT

- **Who is affected**: Users of ASUS ExpertBook PM1503CDA laptops
  running Linux
- **Impact without the fix**: Internal microphone does not work
- **Impact with the fix**: Internal microphone works correctly
- **Severity**: Medium-high for affected users (audio input is a core
  feature)

This is a real-world hardware enablement issue. Users of this specific
laptop model cannot use their built-in microphone for video calls, voice
recording, etc. without this quirk entry.

### 6. STABILITY INDICATORS

- **Maintainer sign-off**: Mark Brown (ASoC subsystem maintainer)
  accepted the patch
- **Pattern**: This exact pattern has been used hundreds of times in
  this file and across the kernel
- **Testing**: Presumably tested by the submitter on their hardware
  (standard for device quirk submissions)

### 7. DEPENDENCY CHECK

- **Dependencies**: None - this is a self-contained table entry
- **Code existence in stable**: The ACP6x driver and this quirks table
  exist in all recent stable trees (6.1+, 6.6+, etc.)
- **Backport adjustments**: None needed - the code will apply cleanly as
  the table structure is identical

### SUMMARY

This commit is a textbook example of a **stable-appropriate DMI quirk
addition**:

1. ✅ **Obviously correct**: Follows exact pattern of 80+ other entries
   in the same table
2. ✅ **Fixes a real bug**: Enables non-functional hardware (internal
   microphone)
3. ✅ **Small and contained**: 7 lines, single file, no logic changes
4. ✅ **No new features**: Just enables existing driver for new hardware
5. ✅ **No new APIs**: Pure data addition
6. ✅ **Zero regression risk**: Only affects one specific laptop model
7. ✅ **Falls under documented exception**: Hardware quirks are
   explicitly allowed in stable

The benefit to users of this ASUS laptop model is significant (working
microphone), while the risk to all other systems is essentially zero
(the DMI match ensures no other system is affected).

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index bf4d9d3365617..fe6cc3c74991f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -535,6 +535,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK PM1503CDA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0

