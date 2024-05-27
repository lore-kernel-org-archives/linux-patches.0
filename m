Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0C81607BC;
	Mon, 27 May 2024 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836587; cv=none; b=FlIDZxsqPaVeOw/hDvzGwBrRGfQeDzcHIpc398jMMdkiHiDSPDAbgH6etABf5g7lwCljmJXcOn2ds2XIdifiPp2d89FhRPktcVPX7HWN4FsCiN950i6NfRzmxUjWPM2JlOO0Ift7MlPM+aQiSB92GNWOrH8DPijEvFyuo1o0NJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836587; c=relaxed/simple;
	bh=+SXBtHwz/jwQ0qSWBwk/yWruhQyyi8jVxos92t2oqvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGDNIGfg4nVbneTChAfl0aiXgAb+RIh4jj7p5B5zHPy1FIyOn9Gmqt6EaNfAFbFZyDGRbU4i/ng/YMCo+BYpSTcaqwY3p3z6iH5nl2tL6e3hmFc8DhqKcJ0pssJx2FeJeI6a5KW6DgVfrhi3LqFI+B1+gcmPZ/pytSdtbS91QyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7GoLcKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7GoLcKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC15C2BBFC;
	Mon, 27 May 2024 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836587;
	bh=+SXBtHwz/jwQ0qSWBwk/yWruhQyyi8jVxos92t2oqvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7GoLcKKB/XldP6xKkZ9GdH1LMPuJyMeczBSK3gtoaCm4/2RD6ZCuzLDRRuySPsja
	 fIvnF5364NftU9XDoYjVbxMi6YDx9uq6sd2A7KTcH0CjCBZhEBCH2r/Ues5FJERxeo
	 7nbK3H/g+4Y4Ua0bFKs3Hjtx3OcJ/kP99a5osnIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/427] ACPI: bus: Indicate support for the Generic Event Device thru _OSC
Date: Mon, 27 May 2024 20:52:39 +0200
Message-ID: <20240527185612.236441067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d5b0e80dc48e4..0c48b603098a8 100644
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
index 0e0b027e27e21..b0d909d1f5fc3 100644
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



