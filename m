Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E245C613;
	Wed, 10 Dec 2025 07:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352124; cv=none; b=dGFmnG517IkxBaW439tij8zPR7hW0a5evEfIXsHR3AJw4DmsIJtesNf1mEUilOZ6DtDwpnNDSf2X1VBwkE3XOHuyb41P7bG7033KIWTD0FjPBGz09n9QiFxaZNvmdEjO1IdM0pQ7fhBzLokGxFdj3KwsOHqPAcvn8nU47YPB0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352124; c=relaxed/simple;
	bh=jsBFkMDlBh8o8/OESQPOmc9Epn3KmyLAHeV8BrPQFoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCeOMY1peyeUatPQI7w3O1t039Jgx4z3YKnzs9wRJ9MBosvu3CYheWUx0ev9lOYpgnIoytqX54T1K/L3LFp2GiInSbyp3hH3piSLR4hmw52VWPivVe8hhmTUp9ZUNC9Dq5aJT5Fm/+XrHY6eVDiVWGU4uLC5Cmi9fy0/Fqp0dfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSnf9qeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSnf9qeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA57C4CEF1;
	Wed, 10 Dec 2025 07:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352124;
	bh=jsBFkMDlBh8o8/OESQPOmc9Epn3KmyLAHeV8BrPQFoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSnf9qeSg6UKwxsmvaupzr+yJq2naE4e1MBVG8aymkop1rDf1mL0Q18+u6Tk0la1I
	 14QNKNAPIk9vM8wNta6Pu5cMJSPBFWybL2CWnDxzy/mQ139fI4MuNVqv9IuUzA1cFk
	 VT1HDELa1fy9iMhAOkehITyfr480Nd/zRkycHo/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 42/60] platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list
Date: Wed, 10 Dec 2025 16:30:12 +0900
Message-ID: <20251210072948.910954949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d63aaad7ef599..0fadcf5f288ac 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -204,6 +204,23 @@ static const struct dmi_system_id fwbug_list[] = {
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



