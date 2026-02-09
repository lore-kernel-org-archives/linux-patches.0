Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4834E37A496;
	Mon,  9 Feb 2026 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647395; cv=none; b=kQOmEmA0nnJEvvFH6KpsHIF4zQamuKnKAXWOqYEjK78Jk7GKco9jQIcAcGGpzyKbOpsmUcBuogGI+pQ9DChK5+0TYhPuB2C4DHi2vkwqKYlTr8ZcWMb3Ql+2Q4OWhVEjObz2eZIJ4/RPHbCprM8XncRTZmKQ2PT3y00W7pWgnJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647395; c=relaxed/simple;
	bh=FWpjQDHZ3sAsjBpJAE7cH7riZ+vVMqW+3f4jZmyfs9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THA71ItFxz+E/1AjBqzMtKXAKKCjq7PjshpAvyILiMRYiYaOddRxGd7PJr0jTadNRK9e9AMACB6nN4TAorv51uwySFR3gXrikil4Rb7j08vzO2vEWHLvNsEZDoI2XcoutMEp2vSoJsv9y1PJsDS0rrsg8oK+4bIGPQpRCY0YDeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjnoueHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjnoueHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42BBC116C6;
	Mon,  9 Feb 2026 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647395;
	bh=FWpjQDHZ3sAsjBpJAE7cH7riZ+vVMqW+3f4jZmyfs9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjnoueHEmlq88dsDpMGlv7OquySzyK6iJyvhxJfYkewcrGKVY5/tFGMfdKmRqAtlP
	 jj8c9VUv7CwLakze+Xi6mnsKDp3DexxbP9rRa8the4K3Atv1vt/r6VX7uvipbcs6cw
	 agdgI4vzYnNJqdvtEC8zRCZgjkCEoRfYurVhb8PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Bagrii <dimich.dmb@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/175] platform/x86: dell-lis3lv02d: Add Latitude 5400
Date: Mon,  9 Feb 2026 15:22:06 +0100
Message-ID: <20260209142322.377285760@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/platform/x86/dell/dell-lis3lv02d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-lis3lv02d.c b/drivers/platform/x86/dell/dell-lis3lv02d.c
index 77905a9ddde9d..fe52bcd896f78 100644
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



