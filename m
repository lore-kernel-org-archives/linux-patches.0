Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BAB12DDA1;
	Tue, 11 Nov 2025 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822294; cv=none; b=FNCmBRAPdq1zZmY7Qy9qm+qcRqjTQDWgqBx4FpyoWON+caDPzzBTob7W9YRn+6OSzH5lqy8u+b6Zd60WYdRkjlIL8eNYKRv0tEHWvuRQqvD0ehwfna61RVtf3WaHgGI683XoHgw0rbglxBjR1Bx9kmExbZgT7PE1W/ZfZdLwGuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822294; c=relaxed/simple;
	bh=vKSoNeer2cw3zHSSRrrS2StK2b0ObShHLFz57fRERoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1ZhvPcCOtHdvzNKom3k1vN5a+47okbJkJu9H6kTIe27UBYlRN0guDEIhw31Xl4/8vzhr8LQb4772H9W/ZnlfWDY1v2KtLZh/PI+m8Lm59Z1Jz7ibDUgx6QpohkUiA0SWJTi9grMgrLtwDykgpgHhRelDd0uVgiEWLA+r7kJbyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMgczzDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMgczzDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22769C4CEF5;
	Tue, 11 Nov 2025 00:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822294;
	bh=vKSoNeer2cw3zHSSRrrS2StK2b0ObShHLFz57fRERoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMgczzDw/tUXVFV9sipgUszVOxQaewLg5LlUqboorwrV65f50GyQDlTfzccCYrdSM
	 CPhaunfcdg35sNEX2E7lZpnwho1Hwd355Q6+slOh77m2y7Tt0tVcTzroXjLdCedlCp
	 C/tHrVPoxu0Zl5fcHyja72WNAPjj2GdZ4AhbRCKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/565] wifi: ath11k: Add missing platform IDs for quirk table
Date: Tue, 11 Nov 2025 09:37:56 +0900
Message-ID: <20251111004527.326010628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 0eb002c93c3b47f88244cecb1e356eaeab61a6bf ]

Lenovo platforms can come with one of two different IDs.
The pm_quirk table was missing the second ID for each platform.

Add missing ID and some extra platform identification comments.
Reported on https://bugzilla.kernel.org/show_bug.cgi?id=219196

Tested-on: P14s G4 AMD.

Fixes: ce8669a27016 ("wifi: ath11k: determine PM policy based on machine model")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219196
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250929192146.1789648-1-mpearson-lenovo@squebb.ca
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 54 +++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index afac4a1e9a1db..735032c353b2d 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -814,42 +814,84 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 static const struct dmi_system_id ath11k_pm_quirk_table[] = {
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* X13 G4 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21J3"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* X13 G4 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J4"),
 		},
 	},
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* T14 G4 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K3"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* T14 G4 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21K4"),
 		},
 	},
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* P14s G4 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K5"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* P14s G4 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21K6"),
 		},
 	},
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* T16 G2 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K7"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* T16 G2 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21K8"),
 		},
 	},
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* P16s G2 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K9"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* P16s G2 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21KA"),
 		},
 	},
 	{
 		.driver_data = (void *)ATH11K_PM_WOW,
-		.matches = {
+		.matches = { /* T14s G4 AMD #1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21F8"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* T14s G4 AMD #2 */
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21F9"),
 		},
-- 
2.51.0



