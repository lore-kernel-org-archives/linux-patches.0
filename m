Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A133955C1;
	Tue, 12 May 2026 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608090; cv=none; b=CeO5iDNul6KLpJqCDQF0+0KG36UhJlvvOO1cC1UWOOuRqTqVD35H7oHWHATQGRrHstFL0pUxnVxM+/MhwLrsOVZgPh/csVeBVSoslHcIHtASiYVpYj0rv4xb7OCVtUXg0C/9Uy/xWRnldgpdP6/Nc1nQpSvrFqTTs9FRdK66DFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608090; c=relaxed/simple;
	bh=IiJR58ZDvjSfhU/wqJ/v0tUloY4Q9N3tUDFLOAR4qdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN2vh7M7I3Fq123q+IolVdPpGphGwuwjsLHSQCer/1CZtHcYPCR3BChReB15YuYgfXZpYqkDH/bETeUvE+LBiu9/+bgm98bzkHKAo/3LkrRSFzF1awr5/ihi2X5Z4A6+dYeXxY/Xphh6wuaH0SqdJiW1q5WwBppr+BG6x+69AXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoB0lgF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoB0lgF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B192EC2BCB0;
	Tue, 12 May 2026 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608090;
	bh=IiJR58ZDvjSfhU/wqJ/v0tUloY4Q9N3tUDFLOAR4qdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoB0lgF5SG78VrlSmbg7lxpKP2WksIeSsDoVVlJw80kNS9n66bgJAdC+2zULz7ezn
	 VyjrONYDdA5RwK54XA0jxz8LDtpabQl8HqltgDWwuKDyOcEPtb6kaY1jMod/Cp9NV6
	 7ZoQ2IW5UCglwIc4kwqEC+7oBzzLY46w9nXWxiaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Soncin <soncintommaso@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 108/206] ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table
Date: Tue, 12 May 2026 19:39:20 +0200
Message-ID: <20260512173935.143608831@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Tommaso Soncin <soncintommaso@gmail.com>

commit d63c219b7ff39f897da10c160a2edef76320f16c upstream.

Add a DMI quirk for the HP OMEN Gaming Laptop 16-ap0xxx line fixing the
issue where the internal microphone was not detected.

Cc: stable@vger.kernel.org
Signed-off-by: Tommaso Soncin <soncintommaso@gmail.com>
Link: https://patch.msgid.link/20260429160858.538986-1-soncintommaso@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -55,6 +55,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN Gaming Laptop 16-ap0xxx"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5525"),
 		}
@@ -648,6 +655,13 @@ static const struct dmi_system_id yc_acp
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
+		}
+	},
+	{
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MECHREVO"),


