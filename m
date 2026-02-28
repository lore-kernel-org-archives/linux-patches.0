Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0D834164B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301195; cv=none; b=cI55AEhx5PmkOVWrxZ4rqixxfCCDZOs8RZ6D9/oEU47q5AAsNt7xA8GDKj1mqREFQjI8InwQrbfTtkGrDBvXwlFGjKab4akmNQMOcY+XxY9bjq1+Ws1oSqzzmv+NfVEsxDVOXBsRzdvq1ZSWCgQbN16v9nGPl//7CXwjRC2O3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301195; c=relaxed/simple;
	bh=LRvyp1T7495ebwokwEb5xk3tnpAB4BOXNi8MmubQZjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O78I5cw0oEieYSP1gkDTMzduuASIqAfK8EMbA37RXetJRD5E/hKQyAOwGlHvcfLgZpscvTtnKLw/dzIxqLWuQIPfOhcnsWrlOmbshwW9PLdxW2pSfOCWS1jC57tZecheMzMQrYf/jX4dRVUiorHgrTttiz+16SN5tuODIv3m1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IibtM14T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IibtM14T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E27DC19423;
	Sat, 28 Feb 2026 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301195;
	bh=LRvyp1T7495ebwokwEb5xk3tnpAB4BOXNi8MmubQZjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IibtM14TziYYbHZTjY1rcpuQE6o9rymITqwawGaLJwr+XkU2Gn0VWAyiPmEr2Avp8
	 5PopYyIObLPwtutE4R+R+b1kzO80gl6oO9yJZFZlXa3YmfoAsUcdOk6ImoNYExnZXh
	 SBR+DKVcpmx0CyAAZcBrm3TqGeIGDfZQLd1DPGIg9S/rjqF8+LWFbarZGIoIZdwsAx
	 ZG1dIhairp8H3RKQvf7q47Vc7xWQN1q658RL397wvVJzYTRojLieRrcIusoCPcimg/
	 AgzrvfKqFTsJO4QeOuQCLywX6RNPrdRUrhER44HwX16fd9+53rWM+kaP0JbZsq//9n
	 NZ9ACftW25O5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yauhen Kharuzhy <jekhor@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/752] ACPI: x86: Force enabling of PWM2 on the Yogabook YB1-X90
Date: Sat, 28 Feb 2026 12:41:18 -0500
Message-ID: <20260228174750.1542406-367-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yauhen Kharuzhy <jekhor@gmail.com>

[ Upstream commit a8c975302868c716afef0f50467bebbd069a35b8 ]

The PWM2 on YB1-X90 tablets is used for keyboard backlight control but
it is disabled in the ACPI DSDT table. Add it to the override_status_ids
list to allow keyboard function control driver
(drivers/platform/x86/lenovo/yogabook.c) to use it.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Link: https://patch.msgid.link/20260211222242.4101162-1-jekhor@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 4ee30c2897a2b..418951639f511 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -81,6 +81,18 @@ static const struct override_status_id override_status_ids[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Mipad2"),
 	      }),
 
+	/*
+	 * Lenovo Yoga Book uses PWM2 for touch keyboard backlight control.
+	 * It needs to be enabled only for the Android device version (YB1-X90*
+	 * aka YETI-11); the Windows version (YB1-X91*) uses ACPI control
+	 * methods.
+	 */
+	PRESENT_ENTRY_HID("80862289", "2", INTEL_ATOM_AIRMONT, {
+		DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+	      }),
+
 	/*
 	 * The INT0002 device is necessary to clear wakeup interrupt sources
 	 * on Cherry Trail devices, without it we get nobody cared IRQ msgs.
-- 
2.51.0

