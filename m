Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8DD15FA91;
	Mon, 27 May 2024 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837879; cv=none; b=O9jP1djbcP3dJrISHGd/Ho0FS+92PB/+VHCqT9wKASsD3Xwtl67RWvU+1/+Rz4SuSP109SlVhDTNRYhB8oiRvnwmKIq8sG44aTUB2noFS9sFQgetDCvQQD1x+z0ATAbvbJ+K2GCoIooo4DIDnthkDPfCT6D7rDmU3BQUEHoQoi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837879; c=relaxed/simple;
	bh=2iMmCpAJ1W4XpS/8gNg3jx2GSvv9tbPHEAwfLK6wO/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoVv+h/bKpsF84UBYuu0OGIBjLHsYyVT3Vk/tL6G2XiJqxBFKPY68FLrq2jyCZkqpwTKx9dJTOsz01WG1L0hsY66rcM3k6f7iAJejQAHwBh3MA6mHxP7NRGHeQ7RWE3KbXmzO3Qom+0boxChV1eoIGBcDhylVrWpSBgG8Vk6V38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLW8yUsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLW8yUsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EF4C32781;
	Mon, 27 May 2024 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837878;
	bh=2iMmCpAJ1W4XpS/8gNg3jx2GSvv9tbPHEAwfLK6wO/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLW8yUsVv1blEDgnthZjV0IE2joKVLbkzPqvbcH8sQLBtfT6umCFWNqu+ntTrhUEg
	 dzb1Tba4/gwVLOfxVow22xFECTO6al1rc/7ZKoO0yzl/mUdZmRnAKijwmItHay7xuW
	 msZsZtzfu8+Z4N4wDeWhepKd9krHO0+9PCBueRyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 181/493] ACPI: bus: Indicate support for the Generic Event Device thru _OSC
Date: Mon, 27 May 2024 20:53:03 +0200
Message-ID: <20240527185636.272107657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit a8a967a243d71dd635ede076020f665a4df51c63 ]

A device driver for the Generic Event Device (ACPI0013) already
exists for quite some time, but support for it was never reported
thru _OSC.

Fix this by setting bit 11 ("Generic Event Device support") when
evaluating _OSC.

Fixes: 3db80c230da1 ("ACPI: implement Generic Event Device")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c   | 1 +
 include/linux/acpi.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index aee91fa2a4596..9486c1be7258e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -322,6 +322,7 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_HOTPLUG_OST_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PCLPI_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_OVER_16_PSTATES_SUPPORT;
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_GED_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_PRMT))
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PRM_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_FFH))
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7658d06b5bccf..60517f4650a3b 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -575,6 +575,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
 #define OSC_SB_FAST_THERMAL_SAMPLING_SUPPORT	0x00000200
 #define OSC_SB_OVER_16_PSTATES_SUPPORT		0x00000400
+#define OSC_SB_GED_SUPPORT			0x00000800
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
 #define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
-- 
2.43.0



