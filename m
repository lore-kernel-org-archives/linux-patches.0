Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2BB1DD0EF;
	Wed, 10 Dec 2025 07:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351934; cv=none; b=aVV8M3kwSvJufXzZGWFvKVo59tDFGmtdJ4ftbk1+BPlukvoRtk6bJrRJS41wDY9KSvCfZFBrb0eQ9UcSCAYILpO8aZEgq5zF20XNqpTxcOeEAopYtOV4hB40IGVJ7xa10MNOxrzPJukBXvVV26EhYPyl8X+q4gq6vc4aIppStG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351934; c=relaxed/simple;
	bh=pAzztpPNS8jucRURTcamD3jqsKvv3EJDrr3kai1FDv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIM67sUurndvy1AifzeTExipnppbW6gOsT9K9JR3tXfElr427+iTfZtBnwgFqGiERXHWzB1xDUkYELvVd4QWW61mViNeGxj1/CY2oQdY4YMpHTKYSkwXDjOzjaebULbe2qwLhLcPEkfTVccKKUCDRmDfyz3TF4kKGdLgE8x6qGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOYE2d88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOYE2d88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44362C4CEF1;
	Wed, 10 Dec 2025 07:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351933;
	bh=pAzztpPNS8jucRURTcamD3jqsKvv3EJDrr3kai1FDv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOYE2d88CMjsS+7HBwh8227E3KCZ9e7smOXrTECrOZ/ELvZQ0Gqjy8kRBXHQ/goAH
	 LE8HnFMGw/PdCI2GaCzLc451NFyor0u5fHzTb/5rHYIXT3CPJVBaY9tjNxEKvj4qPv
	 gPGLha8+bEBXYI0/+GyOP27a6ceX6ETJEYt6e4Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 35/49] platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list
Date: Wed, 10 Dec 2025 16:30:05 +0900
Message-ID: <20251210072949.038004651@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



