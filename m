Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D6833D511;
	Fri,  9 Jan 2026 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959411; cv=none; b=koA+gfnuMWsHkJVrXTuDagaUTTaDPrK1+4AItz0lAx+7tcLz7Mj0wL130n4lCOVORWYUiSF7SBH0EcxQ/E+mj6Xl+Lep6pH6d9HckhFjQ8HolTvoZHK2Q1D+JIVaroiHnLgkRlZoCcEZGmEMg+ng4gs8DzFOSRy3tSD82Ni9OSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959411; c=relaxed/simple;
	bh=Y+ussgODB7NPn93HN+d58FvlD/kqSlrwOJgFYSoQxlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FVnh1hnaJx1czS28XS04W6e+wy8fqMtRWeJ7RL3UqS7NNQCrCjt7Gqw8zK30+okKdgfr6LYNhfSB7kusWrGe3qxSUjsT5G+6v99RVBPOXVTb3yMMQOOUOzcnaZJR07LSd3a66/ar0Pi01iwWR+1aayU1bBeYKJ+xi5ILZR0dfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOxfrprl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOxfrprl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD10C4CEF1;
	Fri,  9 Jan 2026 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959411;
	bh=Y+ussgODB7NPn93HN+d58FvlD/kqSlrwOJgFYSoQxlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOxfrprll6iq3QpRkLuFY9QWM+A/cqzeu7PWC51+wTaLGwwawNuZZXSNYWZSZBmEP
	 fIBPsp9Q2f9KEhvDgYyNCm8hh0amF+gERFG45EY/RqDCVNUO4KcgdV5dHG/RBlJv8y
	 vW0W/UZbmfsFKSeHfloK03ShaYEy9ZkkiPMn0Fa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/737] platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list
Date: Fri,  9 Jan 2026 12:32:54 +0100
Message-ID: <20260109112135.317490563@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit f945afe01c6768dcfed7868c671a26e1164c2284 ]

The Lenovo Legion Go 2 takes a long time to resume from suspend.
This is due to it having an nvme resume handler that interferes
with IOMMU mappings. It is a common issue with older Lenovo
laptops. Adding it to that quirk list fixes this issue.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4618
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20251008135057.731928-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 9fd2829ee2ab4..271cbeaa59af3 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -198,6 +198,23 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
 		}
 	},
+	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4618 */
+	{
+		.ident = "Lenovo Legion Go 2",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N0"),
+		}
+	},
+	{
+		.ident = "Lenovo Legion Go 2",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N1"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",
-- 
2.51.0



