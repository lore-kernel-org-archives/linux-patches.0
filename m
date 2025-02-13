Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB455684;
	Thu, 13 Feb 2025 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460545; cv=none; b=aByyUXIOCjbOdhZBaqQNIv30+iIoPaS9PdEPM51Z7wdcM0XGzp8E4q5hOb7SR8qDdnXolezEQdtKLHFQyNwYJhzT4iHG3bVKtZ3Hk30m/byfvVNqcTx9CB3refpWCP7Gaqlzz2LQM11bpq/5UXw33WN8J97tDzg5+cnKVjDUFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460545; c=relaxed/simple;
	bh=6lyKoWFL+kbQTuB07OwgCOwOsgyVKahG7XJ6x+0rhSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSBfQFNwoMdkgwDWxy5kz8PX3h8rNPQHhH/YLjYrfngNa4sMYNbHnO09idiHvMgMoMebQ1Np4+79el6jRydO1M+LB3IIK+HXZ9aL6o3w5c27jkpg5OiK1is1k7vDdzUHnoTF4jgrEFJ9LgITDsIJlKYA3yqaW7etG2zDmXviB8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK/DI03c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK/DI03c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A4EC4CED1;
	Thu, 13 Feb 2025 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460545;
	bh=6lyKoWFL+kbQTuB07OwgCOwOsgyVKahG7XJ6x+0rhSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yK/DI03cErq9yLPyPlrZHLQyibOV1WIyRgEHB6mdYnNdvWQjSpeNoOX0TVJFwHUdS
	 OuRENnxiojHjXCLVcYXorG4x1vn3PSMXSeN9sS9hdMHeB81PfSN3zL8UkjJ1CaHJS8
	 GuUDMRfQCPIbUvCupk37NhfqJEg2/yqeZzMBI0cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nijs1@lenovo.com,
	pgriffais@valvesoftware.com,
	mpearson-lenovo@squebb.ca,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 143/273] ASoC: acp: Support microphone from Lenovo Go S
Date: Thu, 13 Feb 2025 15:28:35 +0100
Message-ID: <20250213142412.986648257@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


