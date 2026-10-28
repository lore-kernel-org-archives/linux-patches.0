Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210911;
	b=bxbwSqrfLmidW7j0GDVIgTGqfXfRNw+6b8T7GnUNlf3rovIsAroFgS8fXiA0nRGFbzh4
	 uogqpKyQrFlaZcayvTzv1YbXo5hA7S/m3yFZCia9ZkTBre9KTA9t/twfOtSG/kjn4V1hz
	 E6pYpmTDQZwp/7BKt2BmcghWJim3O6YEU8WPbOQyvUUqVVYu1DZEaPBSXKHQeBcBCGWFJ
	 1Bn9amEAUOEJ6ZDzcZK0QDlrGb8NjJghyoEQixH24yD/AjtgoCLr6BIrHUkfqlV+1uvpl
	 zPQwqZlELPeTtM2ehT3dOMoAC+yBKC09UB4hqV2+X+rziBNy7SIxIlBwsdtcFTd3gCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUY9PmGSy1+IgRlx+UhUgwDrrLwLImaB85xpVB1wedI=;
	b=dFNCT58z3EzI9iLmlJ6YdqXc/e/5gu+Q8ybv+RxJr9UjENZ33DhQBtrx6IPhlNZdaSOr
	 sPvqjXYLMYOdXhIjZqmiEAyuSSMx8mW3HPG02OAu0NZaNYn5uVkjBzURyrK6Axc1HKvoj
	 iFElxMJ6wheIOIEl4Y2SdQpHqd6f9GUwBuVfVDZHd7Ve95wbxH7Uxpz4We8N9EzAM1yv7
	 fcA0WhmCY/tvBbKV0Fur0kagGgxTuLixHUi83By3S+PqgCTkp37WyxNe3fUbYqX1n7Ip4
	 NAVrrpdlP8oqRnalP0G686BGea7CnJTF2y55fw8YdIL7tADnZ5hHgmq4rsHl6uQCDWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdvxvT+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D22606A31C;
	Wed, 28 Oct 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdvxvT+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065ED1F01828;
	Wed, 28 Oct 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210910;
	bh=nUY9PmGSy1+IgRlx+UhUgwDrrLwLImaB85xpVB1wedI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdvxvT+tI/FzHK3rB3/avqDy+Wwuj2Gj5bPx8JQkHjlzPkD/NMnILvXkiaRljaLO5
	 bf9k/qPz5L2GkJIs8VdSJ8hYdA6fP9qg+0SEoghRpu2u8XrksaOfP/+ZbTidvoKbki
	 VZYjUE7aoILWYWKSiQTLNc7cWTAmBh1z0YFay1jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 193/571] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Wed, 28 Oct 2026 17:55:40 +0100
Message-ID: <20261028170012.588449232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1970,6 +1970,14 @@ static const struct dmi_system_id atkbd_
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


