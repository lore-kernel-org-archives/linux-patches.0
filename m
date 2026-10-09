Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3DB44CF44;
	Fri,  9 Oct 2026 14:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556236; cv=none; b=IVWGjibHfRte+YbaaVyWvz+4+3ifhSM7Bc2Y7uKO4w84LTKqfqH3cuNL0dC5f+P6OMlfkFQT0zDhOjJ2UM7w1R8GVrbhGXPXDZ8iEfUhR9K0+aSiN6huYR8Hua5sSKzgJBMDjI5196JaRWX+gs9CHf06V8Cp6nxVR939YAj8KaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556236; c=relaxed/simple;
	bh=WuvKAzD3SYVJ9xtdv8VDsAVnTMkL4gbMvpnxm3BaXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1wlCqfXcx6z1M430w8Dj3tRdRCEI7tjBG0H0DJ82csdUJT07QGavscBXUyf6EI3p0LKsNIaXzyivGM4AwFYfOjwKTPOdDcWSq1aagm6lcoajMHw/DNbrBGTv1tgsj5N4kOKKFWBrIzWrgH27vQL5Hz+a+iGGnIImZHGshJEC/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY97+EoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY97+EoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC8E1F000FF;
	Fri,  9 Oct 2026 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556235;
	bh=uUOD1d8k63p0BXfBiiywxlhWeGLzwTn/ewdE6cdxssk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY97+EoQuwBPuHT8v/dA5A/6dheaDbiL5sEDmDeHwKS8EUwZrJnkas+g63oPJjS0q
	 Zu6SG22qf1f+gS2fw5nobnKrzbNwOqrE23qEb7n5wTqKzeb60cy/vKQG0BB2z6hp4P
	 ZZZmPg+iYYSVn+dwJPZthNcfHz9ylV5h/fmDo17Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 151/403] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Fri,  9 Oct 2026 16:08:32 +0200
Message-ID: <20261009140955.603313119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1968,6 +1968,14 @@ static const struct dmi_system_id atkbd_
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


