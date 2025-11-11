Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96001FDA92;
	Tue, 11 Nov 2025 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822176; cv=none; b=UMzLU/m9P+KlpMVjEy3daFaW6ixYzCASZk6A75iFoH787XCRNHv9UaIcFfJbE3zuThMgpF36eet6HX3jzqFK671f0A7tSLSdEbc08rQQlYixMSQb6Gjfy7T7FlANV/6D7I71dfyAlnGnWTEYIEhDaskved010YcoBvvLXnEsmsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822176; c=relaxed/simple;
	bh=x58jP0bkrwh5WWnHBEZbfImz0ubB4+GCXBOcsZdjBbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYxLJvIOsy4ckgK7Zo21mO5foScoKPwKWZRK7YgdQ2dnOfnvfyr8UXyrgxB7QCcAiQFr+HYNmeZaSgIEbmuTJdMYSObjXa9zstm8RB5KG/mGhdCL+yUnOrah1X9n9xUadC+kReA+Vfyp7Tz9tlkX/H5g9X/cAd4zpRlIMl4/9O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNjgD2+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNjgD2+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697DCC16AAE;
	Tue, 11 Nov 2025 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822176;
	bh=x58jP0bkrwh5WWnHBEZbfImz0ubB4+GCXBOcsZdjBbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNjgD2+xlm/jMl0snj06VTEZi/6cAEFv+sqZcBgqs3qjz/68quaaH5vatxhFvDCEW
	 0r5DY1s6eVfUJZrCFusuqlvhwnRGi/hq8CtYON6PwBaNYNyg9mVRhwXZsoD4XbkqhG
	 KPD2x7ZXitQ+G0N5ihX26e8R30QTzHu00sX3hSj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/849] wifi: ath11k: Add missing platform IDs for quirk table
Date: Tue, 11 Nov 2025 09:33:20 +0900
Message-ID: <20251111004537.176041182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2810752260f2f..812686173ac8a 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -912,42 +912,84 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
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



