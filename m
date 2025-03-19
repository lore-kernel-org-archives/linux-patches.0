Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5FF20A5D3;
	Wed, 19 Mar 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395238; cv=none; b=Zkrzv5I5PaE8ispUsExsXLWIk7jTfn+QGTnaOs6+RuXDW/kfkLsjRE1PX3Yv71txihtC1zvILBXsF8bn9ccdKEOmE604IvXnbqLeVy9ZUHffjw9vRHKooy0LS0GrWUdpPX/tAi41XC8yudjSmRh/983viQ6l5QAvo0lUt6nd7i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395238; c=relaxed/simple;
	bh=r7WuiPcAbS7OwFC76SNeas56+MOrt455vFrXulxdXAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iltfbDMc4sDl/3KXHG4YRx0An93uFajhPOhCxWekIG6JtX9CQg2IV3s2ARhyG6fzvck2Z6YWUNXm/lxvGKm99xILxoIuAbK25hAMhiobBweQrVVSXg2Wxw6r0Z60TErjCfax0r6YoendNWwQMDqibjSWzuFtiGzJMq3zSXpwxyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj9uVAe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj9uVAe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FFCC4CEE4;
	Wed, 19 Mar 2025 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395237;
	bh=r7WuiPcAbS7OwFC76SNeas56+MOrt455vFrXulxdXAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj9uVAe5q0NBP6G+71459WhSIhFvt6rqf+Ph5EZMd66//MUgQ6/RVgmws+ShLG1Zi
	 L8glhFGAbzk4ZCov1Nxj4cUSOoHsLCOM6Zl/W1gUvMynm6D5V/ox8+6pMTVXH/2nh7
	 Nf6lxNnP1Nz4vmHiaXcrMB+FhOHn5ziO6VcuHC04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 111/166] Input: i8042 - swap old quirk combination with new quirk for NHxxRZQ
Date: Wed, 19 Mar 2025 07:31:22 -0700
Message-ID: <20250319143023.022313861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 729d163232971672d0f41b93c02092fb91f0e758 upstream.

Some older Clevo barebones have problems like no or laggy keyboard after
resume or boot which can be fixed with the SERIO_QUIRK_FORCENORESTORE
quirk.

With the old i8042 quirks this devices keyboard is sometimes laggy after
resume. With the new quirk this issue doesn't happen.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20250221230137.70292-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1209,18 +1209,10 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/*
-		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
-		 * the keyboard very laggy for ~5 seconds after boot and
-		 * sometimes also after resume.
-		 * However both are required for the keyboard to not fail
-		 * completely sometimes after boot or resume.
-		 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NHxxRZQ"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {


