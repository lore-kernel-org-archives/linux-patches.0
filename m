Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212738;
	b=5iRNHFiIda1dO+AanmnTKWnZoMoUReGiLFDkheyoQ5XhmoNxeOTvYKky+YB7+SNYtv+6
	 G/jXvcTqKX0k9so5PUBItqkJU08EIOVtUCrMBR84GD8i/6/M5+Gy9U448P1KFJUdp5xY+
	 +oWRyRQAOdw15/24pkqfs6y89FfYhVUwOTwrHJon8PPOMCj0t8QXUBWKXC96xSOUeJb7c
	 OBZIjMDDxD6TPUc+ij9RNLOUebW0KdfkbBFVzcf0KV7aOlnL2WpbLsMYBodR12AyvE9cz
	 KVtk+vBDq3XsbF3v5utl/Bn3KClJbWKUvGn+B2FHsLUsnORFOmDRw3qEH9Kprc2VEPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ddnDZyKcoW/HqJE/IbpklA1tlxtKqUX+q9JstMBBchw=;
	b=hMYPCKhv1nOMHKQwxXBb/cvqupjyucsaUNV3W5uoGZKcATSj/KMQwIGZPBhilF9boOIw
	 bHgXu2+tc3qsYRW76qLloffmfEc/fJt1cYthJOCigbBH3SmzZ3Lqc5MykCpPb/4NQplhp
	 jJW2BzuehnV7NcxWgMzKhCqBI0BF/3ZSRQdnXFQXZYmhKFx8HVh6HEEdLW1P7/QSbnH22
	 0PxphLrs4f/6M5b5zaRP1CzmVIkF8dyJG2+KGMWo/B8hbzr5TYR1WBjjP2aO4I0RQmLEh
	 D8WwB3OLEnNFyV1jkt6ed/DLfQEbGL2ERJRcoqY+vGwsCNtOtkpau0cccuh7EVLOQvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r33dwXNw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA175606A33E;
	Wed, 28 Oct 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r33dwXNw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DFE1F01828;
	Wed, 28 Oct 2026 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212737;
	bh=ddnDZyKcoW/HqJE/IbpklA1tlxtKqUX+q9JstMBBchw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r33dwXNwZxwHToABNMK17klao4jILPLsEtJ3VUCoFKS8yC+0XyOSFdyF9pOjglm9I
	 N1EA03ZQN4E9RZXzowHLB3xvMAL3fWEMSGZe3vXHvWcCwLmZUfHpQ7HcOZg5No25II
	 Jh36MgrMEenmt5nKYNrHJBTrabpfM1Vg4O3TqFhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0260/1887] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Wed, 28 Oct 2026 17:39:16 +0100
Message-ID: <20261028170505.146745373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1955,6 +1955,14 @@ static const struct dmi_system_id atkbd_
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


