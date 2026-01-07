Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3E379964;
	Wed,  7 Jan 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801224; cv=none; b=qPli+UCFgHBMBzlJNFXmdMRDyP2zeRJo4prjam8SynID8exQQIxExayKW5xJiykWlenYHnIE46Neb9mmJTD5XCjegXcFgtm3m4eX/Cug6tHiX8+h3LheFwm4qou06HI0sVWxy6uYNQcZhQ2rm8fyBfpY8GeKal7wnsF/Lfo4gjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801224; c=relaxed/simple;
	bh=kiB2gOT8X8qjTaO897jfEtwY7RIgIUHodFtaqLh0MkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6bZb3o44OoKGL1EccougiBk/3gEtYx1H7Vmm598KFdX1/a13oZHLbqyXItTuZoBaCVtQ1OcvLod+mk67FdyNIsOjY7+KN5mbYFqDasnil46HMoG1UJgaSdDEjgvMI9qp6LgL94agQqaSBVPRp91MUpaVCoTfAACS4JhxGapviE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yrk2GE4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yrk2GE4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7922EC4CEF1;
	Wed,  7 Jan 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801223;
	bh=kiB2gOT8X8qjTaO897jfEtwY7RIgIUHodFtaqLh0MkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yrk2GE4SvXEPWCiXJGPJSpRVmh/LnXn0fN/pRgnoPW2syYkYjLgB6DVwZ5h3HknPj
	 C34wBkVI8GuRDHQz23mkKc2azM3MmILfc6HwGePREMpWA3pZSxvPLO3YguXOaxRN3g
	 3YiZr1EkjEj9uyRnUgkiev9O4pdYWgZJ8g/K60K9dmfdF5dKKbxYeyihFXOBDXyX3H
	 FPk/FgRZ7GO5opraC+zYx+CgIKYcHH9uL3Wm8HyAyyQ+4GkeT0wjYImY6gvMCieqJr
	 kMT4oVEFU9a0MUldry/ciGrrnU/JgnrLp6Psl+uPy4yMIRDKrTIX5YSdRaQOzwaS37
	 +uuwlP8c8aaSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmytro Bagrii <dimich.dmb@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	pmenzel@molgen.mpg.de,
	setotau@mainlining.org,
	kernel@aiyionpri.me
Subject: [PATCH AUTOSEL 6.18] platform/x86: dell-lis3lv02d: Add Latitude 5400
Date: Wed,  7 Jan 2026 10:53:10 -0500
Message-ID: <20260107155329.4063936-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260107155329.4063936-1-sashal@kernel.org>
References: <20260107155329.4063936-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Transfer-Encoding: 8bit

From: Dmytro Bagrii <dimich.dmb@gmail.com>

[ Upstream commit a5b9fdd33c59a964a26d12c39b636ef85a25b074 ]

Add accelerometer address 0x29 for Dell Latitude 5400.

The address is verified as below:

    $ cat /sys/class/dmi/id/product_name
    Latitude 5400

    $ grep -H '' /sys/bus/pci/drivers/i801_smbus/0000\:00*/i2c-*/name
    /sys/bus/pci/drivers/i801_smbus/0000:00:1f.4/i2c-10/name:SMBus I801 adapter at 0000:00:1f.4

    $ i2cdetect 10
    WARNING! This program can confuse your I2C bus, cause data loss and worse!
    I will probe file /dev/i2c-10.
    I will probe address range 0x08-0x77.
    Continue? [Y/n] Y
         0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
    00:                         08 -- -- -- -- -- -- --
    10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    20: -- -- -- -- -- -- -- -- -- UU -- -- -- -- -- --
    30: 30 -- -- -- -- 35 UU UU -- -- -- -- -- -- -- --
    40: -- -- -- -- 44 -- -- -- -- -- -- -- -- -- -- --
    50: UU -- 52 -- -- -- -- -- -- -- -- -- -- -- -- --
    60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    70: -- -- -- -- -- -- -- --

    $ xargs -n1 -a /proc/cmdline | grep ^dell_lis3lv02d
    dell_lis3lv02d.probe_i2c_addr=1

    $ dmesg | grep lis3lv02d
    ...
    [  206.012411] i2c i2c-10: Probing for lis3lv02d on address 0x29
    [  206.013727] i2c i2c-10: Detected lis3lv02d on address 0x29, please report this upstream to platform-driver-x86@vger.kernel.org so that a quirk can be added
    [  206.240841] lis3lv02d_i2c 10-0029: supply Vdd not found, using dummy regulator
    [  206.240868] lis3lv02d_i2c 10-0029: supply Vdd_IO not found, using dummy regulator
    [  206.261258] lis3lv02d: 8 bits 3DC sensor found
    [  206.346722] input: ST LIS3LV02DL Accelerometer as /devices/faux/lis3lv02d/input/input17

    $ cat /sys/class/input/input17/name
    ST LIS3LV02DL Accelerometer

Signed-off-by: Dmytro Bagrii <dimich.dmb@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20251128161523.6224-1-dimich.dmb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: platform/x86: dell-lis3lv02d: Add Latitude 5400

### 1. COMMIT MESSAGE ANALYSIS

The commit adds DMI-based accelerometer support for Dell Latitude 5400
laptops. The commit message is exemplary:
- Shows detailed hardware verification using i2cdetect
- Demonstrates the driver itself detected the hardware and prompted the
  user to report it upstream
- Has proper Reviewed-by tags from experienced maintainers (Hans de
  Goede, Ilpo Järvinen)

### 2. CODE CHANGE ANALYSIS

The change is minimal:
```c
+       DELL_LIS3LV02D_DMI_ENTRY("Latitude 5400",      0x29),
```

This adds a single entry to an existing DMI table, mapping the product
name "Latitude 5400" to I2C address 0x29. The macro
`DELL_LIS3LV02D_DMI_ENTRY` is already defined and used extensively for
other Dell models. The I2C address 0x29 is consistent with other
Latitude models in the list.

### 3. CLASSIFICATION

This falls squarely into the **NEW DEVICE IDs** exception category that
IS appropriate for stable:
- Adds a DMI entry to an existing, working driver
- Analogous to adding PCI IDs or USB IDs
- The driver infrastructure already exists; only the hardware
  identification is new
- This is NOT a new feature - it enables existing functionality on
  additional hardware

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1
- **Files touched**: 1
- **Complexity**: Trivial - adding an entry to a static const table
- **Risk**: Extremely low
  - Only affects Dell Latitude 5400 systems
  - Uses identical mechanism as all other supported models
  - Even if wrong, impact is isolated to one hardware model
  - Hardware verified by submitter with actual device

### 5. USER IMPACT

- Users with Dell Latitude 5400 laptops get accelerometer support
- The dmesg output shows the driver detected the hardware and explicitly
  asked for an upstream quirk to be added
- Without this entry, the accelerometer is non-functional on this laptop
  model

### 6. STABILITY INDICATORS

- **Reviewed-by**: Hans de Goede (prominent x86 platform maintainer)
- **Reviewed-by**: Ilpo Järvinen (Intel kernel maintainer)
- Follows established pattern used by 15+ other entries in the same
  table
- Hardware verified on actual Dell Latitude 5400

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The driver, macro, and infrastructure all exist in stable trees
- Self-contained, atomic change

### CONCLUSION

This is a textbook example of a commit that **should** be backported to
stable:

1. **Obviously correct**: Single-line addition following an established
   pattern
2. **Tested**: Verified on actual hardware
3. **Fixes a real issue**: Enables accelerometer on hardware that has
   one
4. **Small and contained**: One line, minimal risk
5. **Exception category**: This is exactly the type of device ID/DMI
   entry addition that stable rules explicitly allow

The risk is near-zero (only affects one specific laptop model), and the
benefit is real (enables hardware functionality for Latitude 5400
users). This type of trivial hardware enablement is routinely and
appropriately backported to stable trees.

**YES**

 drivers/platform/x86/dell/dell-lis3lv02d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-lis3lv02d.c b/drivers/platform/x86/dell/dell-lis3lv02d.c
index 77905a9ddde9..fe52bcd896f7 100644
--- a/drivers/platform/x86/dell/dell-lis3lv02d.c
+++ b/drivers/platform/x86/dell/dell-lis3lv02d.c
@@ -44,6 +44,7 @@ static const struct dmi_system_id lis3lv02d_devices[] __initconst = {
 	/*
 	 * Additional individual entries were added after verification.
 	 */
+	DELL_LIS3LV02D_DMI_ENTRY("Latitude 5400",      0x29),
 	DELL_LIS3LV02D_DMI_ENTRY("Latitude 5480",      0x29),
 	DELL_LIS3LV02D_DMI_ENTRY("Latitude 5500",      0x29),
 	DELL_LIS3LV02D_DMI_ENTRY("Latitude E6330",     0x29),
-- 
2.51.0

