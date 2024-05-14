Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74863139CFC;
	Tue, 14 May 2024 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683025; cv=none; b=aF/jp6fR86YD6RpP6nCBZYMhvDw/R+gDILUGm1rTxUEgMY+ZDJLXoeuIKxNjFjj9UFYlPCX2/2i0nqPe+rUOLqi1DN5oDK635V7Ib79joURf+nO1YDCtmYYWtlgOqW+vhsWEI+U//rvb5++UXrSX0k9nXZC9+eVXQGzKo2dEboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683025; c=relaxed/simple;
	bh=Dh8JsJ1nilNJHHF5QGoigul+7fhcvcdfQMIspKdY3hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KX2Bz37CNvZmUARabEZTPbId5dJacSujQ797l89UAMyo0ZtbDpHVQ40Q1qEnfcVoohPIpwP5r3/782XLhN40u868XeXlXqFeFmsaNDwkawcp9fBe+9VkP3AHnXNS2i/TrGG/y23MaBEhV2NgvwyMpRiC+8a5bNK4cr0i103cAYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL1u/o0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL1u/o0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A6FC2BD10;
	Tue, 14 May 2024 10:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683025;
	bh=Dh8JsJ1nilNJHHF5QGoigul+7fhcvcdfQMIspKdY3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL1u/o0/czuto5dl13cW2qMe+bxrYc7a/OqzzLN8GWPGfKTzz1y2oEXlFooBl18nH
	 pHIiFztjuOAm3majpoP3OfWMRmswYaWqjwpcwEgdyrP7R8aYde7Sud48Qy1pcb7D1l
	 mZz9V6ugxAO1VZ14bqyBCHpkVuFLmv37IqP0D5pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bernhard=20Rosenkr=C3=A4nzer?= <bero@baylibre.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 153/336] platform/x86: acer-wmi: Add support for Acer PH18-71
Date: Tue, 14 May 2024 12:15:57 +0200
Message-ID: <20240514101044.379254973@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernhard Rosenkränzer <bero@baylibre.com>

[ Upstream commit b45d0d01da542be280d935d87b71465028cdcb1f ]

Add Acer Predator PH18-71 to acer_quirks with predator_v4
to support mode button and fan speed sensor.

Signed-off-by: Bernhard Rosenkränzer <bero@baylibre.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240329152800.29393-1-bero@baylibre.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index ee2e164f86b9c..38c932df6446a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -597,6 +597,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_predator_v4,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Predator PH18-71",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Predator PH18-71"),
+		},
+		.driver_data = &quirk_acer_predator_v4,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer Aspire Switch 10E SW3-016",
-- 
2.43.0



