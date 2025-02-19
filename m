Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8B61EA7E4;
	Wed, 19 Feb 2025 09:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957008; cv=none; b=KfT5LSe13bPuit6wkVPDfPo7NrsfOaeyCN/IYeAz2hX5YBSUljXt6S4RAqMJE7IoN5+7k32j+XUw+2kQMVojlcelUeIy2WXRz/6oCcLlKNcOFoIA4Yh9s+1DbAgam4gPkR2pbOS8IJsLuIxzR78ogGPCdOwc0ovdBCvTX98pbpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957008; c=relaxed/simple;
	bh=jJCjdAL6Y2FFwv0RRnNFMkk1WoK/OqsNMbRTkTKBVCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB0nZ8DjlAYA5CDeyHtPa52rQG/WF+z+F6aPZTa6PCGuo9pCfDbhKntPcXuOkW8OQmIIpeu+YP6+oXux0vFdLOW2qsq0qdN0fJJTHYXPVKTHynsf6+GlgV2P/eHNE2zrDxhcTfEWil+jO4x6GLG9GgI2qrTZ71u8/GenrPYvnE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcGViTaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcGViTaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA99AC4CED1;
	Wed, 19 Feb 2025 09:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957008;
	bh=jJCjdAL6Y2FFwv0RRnNFMkk1WoK/OqsNMbRTkTKBVCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcGViTaFG7AQR8jj1lipMB6+rA+hSh799tARfm/IUJdvzcGqJhU55VQoh5YmTL6ys
	 za/lP1U8VS/jducs5rgrLjYRs0OUA3q41NBBsKtja1Ke6YlGvNdXyYH9aFAtwYLTAy
	 ja0kz02hDdz4AH/4uxejN/NK5fR1mGTYFSvSpjEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nijs1@lenovo.com,
	pgriffais@valvesoftware.com,
	mpearson-lenovo@squebb.ca,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 376/578] ASoC: acp: Support microphone from Lenovo Go S
Date: Wed, 19 Feb 2025 09:26:20 +0100
Message-ID: <20250219082707.808735051@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -301,6 +301,34 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
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
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82UG"),
 		}
 	},


