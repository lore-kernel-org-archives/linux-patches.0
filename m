Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D43F2BEC2B;
	Wed, 23 Apr 2025 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421763; cv=none; b=gS8N9l9GR0l18xR7erdaojp0274i6KqubkJg7gBlMUGVWS+M4p0X0HLR0B8ezyCWYW/B0JP0IXV8dzBwWBPVvergTvdK05COQoMTgzoDkT0TkkSLI9wJTuKpZ2klX99zjoR+wkO82fh8dCIUaxfFm1kjCtc+NGvK6gERE17OUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421763; c=relaxed/simple;
	bh=CIX90scMHVYfxSSQW5S89Wrg+KealoOtjX4qaodKK7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcBgut8f585jHBBHGwB3tY5J45fctRJgggpzeSM7eeeK7VSC4uFEEF3n3RzcIorzbWElO2U/jJ5s5WwV7ENiiGWqjjtPCeKS6bvmC7//2tTyP7cMHTfHezm5wDZCLqe6nFulTOqugu1nGc0P2oXTnnrpBP2cqkvRU2q7T/iV9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRasxaEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRasxaEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318D0C4CEE8;
	Wed, 23 Apr 2025 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421760;
	bh=CIX90scMHVYfxSSQW5S89Wrg+KealoOtjX4qaodKK7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRasxaENd4EquAtKetrQP5vjzdO6AavQqZJanU8und9LKuv94U/euOqitzqZ44ckS
	 DzC7BE54VgLUbyDNW1goinjb7KH0Cj1mMcHC/5xIlFCQXRmpI2ZQbf5U8UDgkVJ6VC
	 f7ard5SwEwnu1aZQIcEyHQ/c380+eM+HeWRcIfkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.14 230/241] platform/x86: alienware-wmi-wmax: Add G-Mode support to Alienware m16 R1
Date: Wed, 23 Apr 2025 16:44:54 +0200
Message-ID: <20250423142629.971188916@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 5ff79cabb23a2f14d2ed29e9596aec908905a0e6 upstream.

Some users report the Alienware m16 R1 models, support G-Mode. This was
manually verified by inspecting their ACPI tables.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250411-awcc-support-v1-1-09a130ec4560@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/dell/alienware-wmi.c
+++ b/drivers/platform/x86/dell/alienware-wmi.c
@@ -248,7 +248,7 @@ static const struct dmi_system_id alienw
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1 AMD"),
 		},
-		.driver_data = &quirk_x_series,
+		.driver_data = &quirk_g_series,
 	},
 	{
 		.callback = dmi_matched,


