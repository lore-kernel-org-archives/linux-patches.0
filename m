Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208622;
	b=wfKuoxhxymd/4D7JwNkzWz5FNx7AFH9GI5v5R5g11PTBWzVNy846678GgN3mL1qj196n
	 lTDTRgG1guwhWh6TuL3Lzt4hbozb1TQgfo0C/ayWOlrbjm/+I6NOMOzWHzS6j9RbAtmGA
	 8OLnyAHD2Nfyg07KbvYrSPJAN8JSOp+1T89oODZhz8oFZ3tFExjBbF1A12AWDTXppZuzh
	 B5cL6NLJ4uloLXFpzAzwvcn6ja5NYqyQ+8oEzwiPh1JabM7yGmYrnuliuXgczJ2myOSpY
	 Dtqc9UjnATouD1YRaDyPRfobXAHVqvI8wAlDGHEVfp7oFoykXEFRurPsrGfO0MyRQiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9UZWZ0h0BM203KFqzjxFkI82acLvZuX6J9fTMrugcI8=;
	b=cHrX+DkokJ1tWv0FwhFBEwaSqViW9jsbmO8PXwB1zslR1lTpjVyfRnSa6BbEbVDg+YIt
	 IK4FVUQbflhI7hm2aa0DikSVpTWZ/4dPwOIKWS5dk/Pyf/Z7ZP312ea+Qa/izdJ66Ubk3
	 dzWRexWHLeJe1wnOJwa84IgzZHHHYjXhxcsSBwGWLSrbBBgfT3BYbqriSJKNrDYxdfVsl
	 UDEuFex/fXZSrveMaxwDb4n8ymz7avToStVKZSp8fg/3FtaaKmZziAP0ARnh+Ig/3JZtg
	 zHwKp27pTy8aC0qAZEGonD46QyUMr/t8KNUNf//0Vk/9xBy50GYCdJTv0BTUyOPQmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cgbn5G/I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D3606A31A;
	Wed, 28 Oct 2026 17:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cgbn5G/I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682FF1F01825;
	Wed, 28 Oct 2026 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208622;
	bh=9UZWZ0h0BM203KFqzjxFkI82acLvZuX6J9fTMrugcI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cgbn5G/IEwYZ9UF1YCvFukCZa3TribyjnfWM665O7HbEGGHI4yI54oE0+Alfp7yHa
	 UlWsuAim53M8YLTyAQlWwTtWlo23ZxuB8xUAU34rDPngJisiGK2k3iNTPB65WO2o7X
	 IeS/IUKGChuJ3kNowsnwJnNx5Yb8qTNPsuugB8Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Papero <martino.papero@lcb.to.it>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 182/516] Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11
Date: Wed, 28 Oct 2026 17:55:34 +0100
Message-ID: <20261028170007.816681307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


