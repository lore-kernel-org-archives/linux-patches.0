Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD033B8D7B;
	Sat, 17 Oct 2026 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256480; cv=none; b=nejyAk4V22UNGW+eacjoL+Y9XK97/8fFKqqbjOtsODzSjna8LP+NvoHvgE5cgi3ZeIKeuqhSbvGsQlqUe7yEmr7Ome/nezpFvBzIuaaunjgmKgnr5zsSXbw2zkaVP5qwERtFScilYowfVKshC+RpJkgNgavPLfh/2WU96kBG5+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256480; c=relaxed/simple;
	bh=JYwPTzOvTtlmJPE4zIBOv7PJeknvNP974JSs+/6R8Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2rb6hYcGc6ZsAHqKTTgmnkYVoZNQCO90DtlupRCwwEgOj64dbOGH+xNZrYOblgoQZbyT/GjeSAwPaUeT7mLLxn0Cl8quskwp+SR7TvGKlDNrN0GAcswt/MruVRdPqMXkTmbr/98dSYE9qVaVgsoEBkVkF/rUReuG17pbevdNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysqONyI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysqONyI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E241F000C4;
	Sat, 17 Oct 2026 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256479;
	bh=/6w8of6Yu59qKlGJ9omwNXkvg1CrxvKdUSMcZaxz6b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysqONyI9qVJ2h3EQFbbXcyfOlxZl51SqVfQ1+1Vvf7jlW4joIU7uHDztbX0hgh9LG
	 tZpjNH8iCDKu3Rwhe3Dt240pl13CK3xWzHS55MkK09O2/WekaiIRsoPP7PPnWWwN78
	 aF7GgJ0B8B4Xm0thkFRTdgo5fbF30v7/Lk9pRD9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0248/1674] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Sat, 17 Oct 2026 17:42:00 +0200
Message-ID: <20261017160437.494098906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -1975,6 +1975,14 @@ static const struct dmi_system_id atkbd_
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


