Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BDB441021;
	Tue, 10 Mar 2026 09:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133360; cv=none; b=WAzqr0uzeF1Efd5M1Pvm/KE0YC+s+PqE0RKUKkHlt6lS0kIp9n5yKonQZMl0nUIXlFLQGDH/+0KCP70UaVB7cBx/8HJI3FRnZQDpioBifjbwfk2x0sxclRu/iPpOwFVWgsgtY1j3ZEoQTLSAqclo2EArODQwjg/7qaVvdm0vZfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133360; c=relaxed/simple;
	bh=fw9kOo8vM9mKBGJG56Xvnt9LPfBT+5AFD83nBuUKDrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH3crycVIUoTWj/5OMi/fpNAsadZLTI64g9J0J7mPUJIPY1A3plas4X7pqZkw0OiLlmn1PehLMnUfR20biHjyPTaV7HKwy0HQxanMIoWRlAigwOKp69MRisLlTMde+EV1DwFx9eDxZzqaVaWDTYi6PK8KrriHt7LMAM7s4Dc/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+XryIQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+XryIQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B2FC19423;
	Tue, 10 Mar 2026 09:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133360;
	bh=fw9kOo8vM9mKBGJG56Xvnt9LPfBT+5AFD83nBuUKDrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+XryIQhAMFNExLfRRSO1vkqOr9K7ZxwigjQ3x0c5w5YCjJysJxB22j1BCNW48Pj1
	 c4z6EuJ2WAQzU5PiBV2XBjCKc0tPbGriAI0+zMk/UwNQSvqaSHOezXmkX77j1YRCLj
	 fihBOOKqGUWTXZCh5VPgWHrfqb80zj1HXh1aZmG4R2jE/lpJ1KLef3UgqhcsifOQQv
	 oxyfMbP1X/jiyjzAfoTEk1pcSFo+fGb2NlW0aKd7mBCWgL0EDuv2X+H0bJGjl3dJ/Z
	 OXFfdyZUp/jwjkuUkG2IvEJMrdeUXMYtjXvf9ZdYMfFsIxgbB+3WrSKW/nMxrY6err
	 66REj7djtZgxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Lixu <lixu.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] HID: intel-ish-hid: ipc: Add Nova Lake-H/S PCI device IDs
Date: Tue, 10 Mar 2026 05:01:37 -0400
Message-ID: <20260310090145.2709021-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 22f8bcec5aeb05104b3eaa950cb5a345e95f0aa8 ]

Add device IDs of Nova Lake-H and Nova Lake-S into ishtp support list.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: HID: intel-ish-hid: ipc: Add Nova Lake-H/S PCI device IDs

### What the commit does

This commit adds PCI device IDs for two new Intel platforms (Nova Lake-H
and Nova Lake-S) to the existing `intel-ish-hid` driver. The changes
are:

1. Two new `#define` entries for PCI device IDs (`0xD354` for NVL_H,
   `0x6E78` for NVL_S) in `hw-ish.h`
2. Two new enum values, firmware generation string macros, driver data
   entries, and PCI ID table entries in `pci-ish.c`

### Classification: New Device IDs to Existing Driver

This falls squarely into the **"NEW DEVICE IDs"** exception category,
which is explicitly listed as appropriate for stable backports:

> Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers. These are
trivial additions that enable hardware support. The driver must already
exist in stable; only the ID is new.

The `intel-ish-hid` driver has been in the kernel for many years, with a
long list of existing Intel platform IDs (CHV, BXT, APL, SPT, CNL, GLK,
ICL, CML, CMP, EHL, TGL, ADL, RPL, MTL, ARL, LNL, PTL, WCL).

### Stable Criteria Assessment

- **Obviously correct**: Yes - follows the exact same pattern as all
  prior device ID additions (PTL, WCL, LNL, etc.)
- **Fixes a real bug**: Enables hardware that would otherwise be non-
  functional on Nova Lake platforms
- **Small and contained**: Yes - only touches two files, adds ~12 lines
  following an established pattern
- **No new features/APIs**: Correct - just enables existing driver on
  new hardware
- **Risk**: Extremely low - the new IDs only match new hardware;
  existing hardware is completely unaffected

### Review Quality

- **Reviewed-by**: Andy Shevchenko (Intel, prolific kernel reviewer)
- **Acked-by**: Srinivas Pandruvada (Intel ISH subsystem maintainer)
- **Signed-off-by**: Jiri Kosina (HID maintainer)

This has full maintainer sign-off chain.

### Risk Assessment

The risk is essentially zero. The new PCI device IDs (`0xD354`,
`0x6E78`) will only match on Nova Lake hardware. No existing systems are
affected. The code pattern is identical to the most recent additions
(WCL, PTL) which themselves followed the same pattern.

### Verification

- Verified the diff adds only PCI device ID definitions, enum values,
  firmware generation strings, driver data entries, and PCI table
  entries - no behavioral changes to existing code
- Verified the pattern matches prior additions (e.g., WCL added in the
  same manner with `ISHTP_DRIVER_DATA_WCL`, `ISH_FW_GEN_WCL`, etc.)
- Verified the driver (`intel-ish-hid`) has existed in the kernel for
  many years with 20+ existing platform IDs
- Verified no code logic changes - purely data additions
- The commit has proper review chain (Reviewed-by, Acked-by from
  subsystem maintainer, Signed-off-by from HID maintainer)

### Conclusion

This is a textbook device ID addition to an existing, well-established
driver. It enables Intel ISH (sensor hub) functionality on Nova Lake-H
and Nova Lake-S platforms. Without this, users with Nova Lake hardware
would have non-functional sensor hubs. The change is trivially safe,
well-reviewed, and follows an established pattern.

**YES**

 drivers/hid/intel-ish-hid/ipc/hw-ish.h  |  2 ++
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index fa5d68c363134..27389971b96cc 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -39,6 +39,8 @@
 #define PCI_DEVICE_ID_INTEL_ISH_PTL_H		0xE345
 #define PCI_DEVICE_ID_INTEL_ISH_PTL_P		0xE445
 #define PCI_DEVICE_ID_INTEL_ISH_WCL		0x4D45
+#define PCI_DEVICE_ID_INTEL_ISH_NVL_H		0xD354
+#define PCI_DEVICE_ID_INTEL_ISH_NVL_S		0x6E78
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 1612e8cb23f0c..ed3405c05e73c 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -28,11 +28,15 @@ enum ishtp_driver_data_index {
 	ISHTP_DRIVER_DATA_LNL_M,
 	ISHTP_DRIVER_DATA_PTL,
 	ISHTP_DRIVER_DATA_WCL,
+	ISHTP_DRIVER_DATA_NVL_H,
+	ISHTP_DRIVER_DATA_NVL_S,
 };
 
 #define ISH_FW_GEN_LNL_M "lnlm"
 #define ISH_FW_GEN_PTL "ptl"
 #define ISH_FW_GEN_WCL "wcl"
+#define ISH_FW_GEN_NVL_H "nvlh"
+#define ISH_FW_GEN_NVL_S "nvls"
 
 #define ISH_FIRMWARE_PATH(gen) "intel/ish/ish_" gen ".bin"
 #define ISH_FIRMWARE_PATH_ALL "intel/ish/ish_*.bin"
@@ -47,6 +51,12 @@ static struct ishtp_driver_data ishtp_driver_data[] = {
 	[ISHTP_DRIVER_DATA_WCL] = {
 		.fw_generation = ISH_FW_GEN_WCL,
 	},
+	[ISHTP_DRIVER_DATA_NVL_H] = {
+		.fw_generation = ISH_FW_GEN_NVL_H,
+	},
+	[ISHTP_DRIVER_DATA_NVL_S] = {
+		.fw_generation = ISH_FW_GEN_NVL_S,
+	},
 };
 
 static const struct pci_device_id ish_pci_tbl[] = {
@@ -76,6 +86,8 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, ISH_PTL_H, ISHTP_DRIVER_DATA_PTL)},
 	{PCI_DEVICE_DATA(INTEL, ISH_PTL_P, ISHTP_DRIVER_DATA_PTL)},
 	{PCI_DEVICE_DATA(INTEL, ISH_WCL, ISHTP_DRIVER_DATA_WCL)},
+	{PCI_DEVICE_DATA(INTEL, ISH_NVL_H, ISHTP_DRIVER_DATA_NVL_H)},
+	{PCI_DEVICE_DATA(INTEL, ISH_NVL_S, ISHTP_DRIVER_DATA_NVL_S)},
 	{}
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.51.0

