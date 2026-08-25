Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BC5481230;
	Tue, 25 Aug 2026 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665349; cv=none; b=Y5/mgCjT3yRW913nBZ0A13FYGO9GceAYoOtp6dM49O7AP9jLC0qhH5dwCPhEL/7JVu4kaOAlOMlEZ0ey0RtUFiSHTYEZIv/FlqFLh2pbA6/nyvIAt7Jz0387zzhAzebhHtpWOlzkAlefpA1fKrfnPZk3S9EJ9156XPEguztX6so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665349; c=relaxed/simple;
	bh=a3/E7KKFlm4MM69h3dthA7VrlXSAPBN18e2dFEFgfKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsJkAkUor3AmRsvaXbZ5IAcaBCf/m+FNTPIjxA7HPw+iXoGArNzOgGd/AN9P6o9eJRYM+2jejgfsXs36hlIS7rENIQSwL//VQUjauMrr5xNMFpby74YcUBeheAiOpr8YcLxtAwZS4XOZeFc9pjPJ0FhOqtcPTj2khxOrgOkmenU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoZ+Smpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoZ+Smpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4231F000E9;
	Tue, 25 Aug 2026 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665346;
	bh=Hsdi8LjLwDtdX+oCAUGVkqwu+s+GyPKLpvNBWOe5ujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoZ+SmpwSY5Bm6fXcXDj6hGDNaCMWlSkGntlUubF8663YI6nmFBuClHXAW22TVc1u
	 wVjtUj+4wVIwAsrjp3FtkvTp5genCk89lH9gg64J/j3ghfCY5ohvZdrq7HHJ9mIo74
	 HvhGUy+x/DNKqL/hC3pOwXYyby6yxJt4VzOtUwrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikura Kyouka <mikurakyouka@aosc.io>,
	"foad.elkhattabi" <foad.elkhattabi@gmail.com>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Hans de Goede <hansg@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 73/94] Input: atkbd - skip deactivate for HONOR FMB-Ps internal keyboard
Date: Tue, 25 Aug 2026 15:26:09 +0200
Message-ID: <20260825132544.735116826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

[ Upstream commit 2aaf33c6e1e82561d7dce2345298a985a2483266 ]

After commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd -
do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID"), HONOR
FMB-P, aka HONOR MagicBook Pro 14 2025's internal keyboard stops
working. Adding the atkbd_deactivate_fixup quirk fixes it.

DMI: HONOR FMB-P/FMB-P-PCB, BIOS 1.13 05/08/2025

Fixes: 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Reported-by: Mikura Kyouka <mikurakyouka@aosc.io>
Reported-by: foad.elkhattabi <foad.elkhattabi@gmail.com>
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20251022-honor-v1-1-ff894ed271a9@linux.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 410c44b10967 ("Input: atkbd - skip deactivate for HONOR ZQC-P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1938,6 +1938,13 @@ static const struct dmi_system_id atkbd_
 		.callback = atkbd_deactivate_fixup,
 	},
 	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMB-P"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
+	{
 		/* Lenovo Yoga Air 14 (83QK) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),


