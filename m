Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3D3F9F2A;
	Wed, 20 May 2026 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302144; cv=none; b=UyJoG3fdUkj/NZppHZexueJT0X4dZlOYbZywQ1CIAePtTj1KIwzl46/Ljg1DYuKJo6ZuylJBArjjQqr/fGhPG2fBA6Zn++4KkWdIClnAlNwR9Ay6GBB8AqTyxPtp+0C/fGg6xXuiYXKZpj0x0WQ+KsmuF9MPyh6a4I5wWiN3t64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302144; c=relaxed/simple;
	bh=C4COkLT9IcDlHS/K/L3z3G9rD1tOB7pDqUGdo+q8dIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMDiA/fBN5yHa6Rj2duk3CErbHkdxh3K/kMhgLtn5z9kgBHPuU93LiCzJeKhHKlUgMLmT4erC3N3BIUsZqh6Oj5KGj89+KZsAW54mdTBf3+AcAqw2k6DoP0KJ0srWCiV47iKWbFrF4KyWf0x3OdI2X1bvxeqWNDMTtPVpWfwVjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIziVw5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIziVw5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74541F000E9;
	Wed, 20 May 2026 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302143;
	bh=wAdF4ThUFNP2cmkKrhFX7s0EDS1WIkK8BBx1BlWv1Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIziVw5V9ZIpGGAw+29wsK0vyy1MX/HVHY3R15msnbnDIAPreoA0E1sOV1okY6vIt
	 ow5uL/5z1xIdnkqouyuCvX3E++6vR7/Y5ws4bUbgra2XhaY82IpS8dMQrlTuVkfcX8
	 +ENGAWy0wOjCJczMwO4GilFUZ4iyqfv/RsAxuvxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/508] ALSA: scarlett2: Add missing sentinel initializer field
Date: Wed, 20 May 2026 18:19:37 +0200
Message-ID: <20260520162101.973903374@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

[ Upstream commit 2428cd6e8b6fa80c36db4652702ca0acd2ce3f08 ]

A "-Wmissing-field-initializers" warning was emitted when compiling the
module using the W=2 option. There is a sentinel initializer field
missing in the end of scarlett2_devices[]. Tested using a
Scarlett Solo 4th gen.

Fixes: d98cc489029d ("ALSA: scarlett2: Move USB IDs out from device_info struct")
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Link: https://patch.msgid.link/20260405222548.8903-1-npetrakopoulos2003@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index c4b29b3670cd4..8aa7414d0b2fa 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1011,7 +1011,7 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info, "Clarett+" },
 
 	/* End of list */
-	{ 0, NULL },
+	{ 0, NULL, NULL },
 };
 
 /* get the starting port index number for a given port type/direction */
-- 
2.53.0



