Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A933EDE5C;
	Tue, 12 May 2026 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609365; cv=none; b=ZfBHvxUn85BbnpUhG/aV8s5PMUCpWcC3J4hd1sA1nHkAOi+l7iYPBA63iBtu/8RtQ+ZKzh1lqWkDR9+S6a7e59M1yRE6p5Mv1EXaPdEPCriz5EYg4iXarMHLgXUJ3zTveP+H08m7BD5JK8cWhE7e/Gx9AmUXUnYwldYUI7LmDpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609365; c=relaxed/simple;
	bh=ieaotEgSebU5EFDV5uEpgx7WsoYDxk+OkU34M+6ax8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZbYm3F5z2WhYo7/qSnzJSQFHKaLc2woWzYwFfBvR7aZt8WCt/M7WABSolvIm9cOneiSer6S55PlVzu+VZNbzVou5lasg1SOVyFDURWkrIPZDB3TYknZ2+dXL5t3CZFfkfVpvsHNpj/bInvyq6PoNSAUqlg3hPb8gpJfKXg0F5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFtuaeWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFtuaeWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E8DC2BCF6;
	Tue, 12 May 2026 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609365;
	bh=ieaotEgSebU5EFDV5uEpgx7WsoYDxk+OkU34M+6ax8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFtuaeWv5mWPIRKWJnGWdyyau9cIXYialFVZbDSjpOjv2rJXmesQs3K2Vk2TmMtFa
	 IgQZUY9mTVGOPXMJAgfVpxYWdueyqJSCeaRJTTuhyoaxETD9npK4kW0qRbpkYMwJUa
	 QLQOye5G5Ycs8roUSDUnqAmtG/qB2/jzEy9ZG1Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Soncin <soncintommaso@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 168/307] ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table
Date: Tue, 12 May 2026 19:39:23 +0200
Message-ID: <20260512173943.666123291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -655,6 +662,13 @@ static const struct dmi_system_id yc_acp
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


