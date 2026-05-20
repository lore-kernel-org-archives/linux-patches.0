Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714EA370AE5;
	Wed, 20 May 2026 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295404; cv=none; b=enitNjS5yKFbZPifGFZ7GbTmfOQe34UpVIg42pYPOE03VVcEXYQdXEdClmGNQbbZOMDHkZBi/37xs6a1SRB1IXbzoazFQyXByUNasryeFdMgPyGf9z2Ic2NmOMI9UCFPublcnK2fbF3cfxMGwGV8/SfoRgrjEAqHglUCXICT+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295404; c=relaxed/simple;
	bh=uIwXe8eha1eYq62U7bbjvvbEvKRK+6ZXJA+0gPofRnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5hq1zY881ZSKfBEUJUTXecxebEELHJOqI3eQrlBjiggQCPf7ZpFY3Nm7lQwz2BzityPh30gkXn4dOqUrUBd00ywpyZ9duqv6lLmB8oUXIdsUv25ATKpcz9SiVDG6rtgpopDSSel+e0KiC4zPaJes82rb22jmRGHPWWuNXAETr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VrySV3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VrySV3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73621F000E9;
	Wed, 20 May 2026 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295403;
	bh=+l1ilbhMeT+s+uIOs4dZPfNaN/yESa7OHULVPSGCxSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VrySV3HIvJpc9YnVnqKYb5xHIPT5ylhO0NEOcMRcfBJ2bV/zS5v+fgSrj/oxYqmR
	 LGBS6Js7e4sxifn7e/pGGQUyZyETJof6yNOzCcRrSk8h8OT7ejf+jdtwY4+NUKAw94
	 ubebg0gP1Q0yVYQ3F1WRpf3SvB6xRjMD7GMQu5NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0406/1146] ALSA: scarlett2: Add missing sentinel initializer field
Date: Wed, 20 May 2026 18:10:56 +0200
Message-ID: <20260520162157.388193773@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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
index fd1fb668929a2..8eaa962227596 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -2262,7 +2262,7 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info, "Clarett+" },
 
 	/* End of list */
-	{ 0, NULL },
+	{ 0, NULL, NULL },
 };
 
 /* get the starting port index number for a given port type/direction */
-- 
2.53.0



