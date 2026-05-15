Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7353F6C33;
	Fri, 15 May 2026 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861353; cv=none; b=A/njJafZ1HE06bn+0DlXHP0C+r04Xg+Qja8X8YC8hXjMyA+XATAwbLaySIzJYthggZppYyxKgPw/BNp4wx1EGjw7b8e/BOsGjq7NVwJ7/SaLVrP1E4VHAbsPtQyWD6JGl4Rv+s5b7hfW087XPqqr386KkQWMMdxhbDbEmAAbF3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861353; c=relaxed/simple;
	bh=ZBFxfRKuQzR6gvIh39l5x7+PlEdT8dGJMDkC0sVWMvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm7X/RXlau4cw1kNPsdQk3xINY08GpE1ZYTATKiQ4yzUvaaRQVVJ/OXl7utoCXYI3mY5Megfdz3jvnW7BqmL2G5sD6jszttOOolfTRQ4qOkHE3jmKe636EvLDuV+0E/ZG4h35ZH2KFMr0Knvv6ZmmYdYDYjp6pp11bJ97h0BCzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVKaNO2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVKaNO2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2607AC2BCB0;
	Fri, 15 May 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861353;
	bh=ZBFxfRKuQzR6gvIh39l5x7+PlEdT8dGJMDkC0sVWMvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVKaNO2TDJvf50bOJD7EaCPcSm0ysanaJTY14Z2k15r3H+CneVgv5wwGaE3/U2IDY
	 wrIZjzk/zsP8ww4HC9DEw1hsen16aDwGHo1m4nzu45rd2ZS6RTluUQxWbZHE39imM+
	 mb8TaknRO4vvmDMrUm1WuZc5/4xIPWSpsusNFRJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Soncin <soncintommaso@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 244/474] ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table
Date: Fri, 15 May 2026 17:45:53 +0200
Message-ID: <20260515154720.280683174@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


