Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36156281369;
	Thu, 13 Feb 2025 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457839; cv=none; b=BgWQJ17w1BwN7H+2ShWtuCR2ebzTqIaCtdEomJepqXsOkwyVyfVQYcQwbaxtZIWL3Ouo+KMqv3W7uMqR9U+lM0rbKT83JGjby6jMSnvoqM4HLJX7cQ1q9WYYMyClt7jvPiMTvIvD5Ods9xQ8o9rAxymuFJBrMNbqw0mqL0NVN7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457839; c=relaxed/simple;
	bh=Oqc1+uuBUJ+/h/lQFeOroSlPOdFEh71RnuoMQSCHftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEhcXX17jtxN9gslu7rrF7qyzDmyfNm9BK5wVzKqEHjFF98HA66wde7L1VB4OZQsuVhNmdqJ09YLhZCyU1AsGn+tK7dp8RWW3NzznHAYLuGSw9n+CKXMrBZFA7+Y1GTFvcefuGz29+l5Vm84za+gXbxFT6H6lRcmihSAzszRAsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xV+DF5UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xV+DF5UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96094C4CEE2;
	Thu, 13 Feb 2025 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457839;
	bh=Oqc1+uuBUJ+/h/lQFeOroSlPOdFEh71RnuoMQSCHftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xV+DF5UMlseOzuUepTJEUIkncw9z0zAB2Iklx6PRyIu/gaimo/n04yZ+ucIqDNwK9
	 sa/tRJJ+U6CZAYEZF+ZDzl1SmUZHViW7jNJfYQe66k7FbJy8USpe7tRrlz5fADMc0v
	 ZBHUzPOuPeZqh8AHTbjTeqNlN0DkvEdOM6heTB+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nijs1@lenovo.com,
	pgriffais@valvesoftware.com,
	mpearson-lenovo@squebb.ca,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 226/422] ASoC: acp: Support microphone from Lenovo Go S
Date: Thu, 13 Feb 2025 15:26:15 +0100
Message-ID: <20250213142445.258738296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit b9a8ea185f3f8024619b2e74b74375493c87df8c upstream.

On Lenovo Go S there is a DMIC connected to the ACP but the firmware
has no `AcpDmicConnected` ACPI _DSD.

Add a DMI entry for all possible Lenovo Go S SKUs to enable DMIC.

Cc: nijs1@lenovo.com
Cc: pgriffais@valvesoftware.com
Cc: mpearson-lenovo@squebb.ca
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250123024915.2457115-1-superm1@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -307,6 +307,34 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83L3"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N6"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83Q2"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}


