Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD12F4D37A2;
	Fri,  9 Oct 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556533; cv=none; b=qYWTt1NchiRCpYI5YncaEeY6FjLnO7CsCef0KjPKQczftlxOG3Y0GmMgKcjCSjal2mWGjuRtTWo+QwF65eOw6c7gInmG1dGXdgV6sD2xnj0B9epc+0yWPJLFHtA94Izd824Ac/0gXwH5J6GuV80vM/cvPOnkNOhl6h3FuLWTORI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556533; c=relaxed/simple;
	bh=6GNd4UD7ugtw9I8qcTAmoD9PQRjmsFLU7IcL7YKp1yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRoxToMkOx/3rSwh0LaebWKZeapLnuDalZGuGvr32OeReXu8spQRpUl8m/6RT7wlDP4pSiLofAt5odrtofVjfdpwTHkbi/ASP4bQ9mVzmGhWswCDOnkmxo9Xo6ai+Vcg9TZDogZmSisPNQ8UQUuB1C2Rqki8qofKbeMP9k/BQJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkr0EJ+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkr0EJ+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488F51F000FF;
	Fri,  9 Oct 2026 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556530;
	bh=HFio+LYX/mOf2t33Rlw6Gt/ZopXyczGYEBAgvDa3PCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkr0EJ+HoNCqdBF8qzWaGlDTiUcTBn0KVBi4MGiL90Hy12QXhJU2362ca9VU65Zcb
	 cKNzYtVK7VW7bONEWxzprZPU7+7pwU508p1tdcVYL21WpXJ/V0fznihaDoFtwtgJSG
	 2BXtZ8E/iQ0TGo6MuEVPi/eBSC4tLAq3HwyjclNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 196/428] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Fri,  9 Oct 2026 16:08:53 +0200
Message-ID: <20261009140950.443530481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martino Papero <martino.papero@lcb.to.it>

commit 3bf8d603fd45649c106cae6290a10f20b1bbb569 upstream.

The internal keyboard on the Lenovo IdeaPad Slim 3 15IWC11 (83RR)
does not work correctly with the default i8042 settings. Using
i8042.nopnp=1 and i8042.dumbkbd=1 restores keyboard input, but prevents
the Caps Lock LED from working. Using i8042.nopnp=1 alone does not fix
the keyboard.

The laptop works correctly when atkbd_deactivate_fixup is used instead.
Add a DMI quirk for the 83RR to enable it.

This was tested without any i8042 command-line parameters. Keyboard
input and the Caps Lock LED work correctly, including after suspend
and resume and after a cold boot.

Link: https://lore.kernel.org/all/4f43465f-98ba-4722-8e29-03df20315369@kernel.org/
Signed-off-by: Martino Papero <martino.papero@lcb.to.it>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/c0b597b8-e7ad-4fba-a2bb-5d252e3dfbd3@lcb.to.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1947,6 +1947,14 @@ static const struct dmi_system_id atkbd_
 		.callback = atkbd_deactivate_fixup,
 	},
 	{
+		/* Lenovo IdeaPad Slim 3 15IWC11 (83RR) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83RR"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
+	{
 		/* Xiaomi Book Pro 14 (TM2424) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "XIAOMI"),


