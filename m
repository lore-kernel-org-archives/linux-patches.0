Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062312;
	b=hxihQwxM/SGMpQ3f6AyzMSjrtJ96haQ3kCYBNLOwwRN1EGMVv0KOCPcrFmuyCo4jt4q9
	 gI55oQOIMceFEYDD2/BwN3Y8SJFZqpJW6Xnu4GgKCgvb6RLmpdL/Fqw9kHCSU0cBNGqNz
	 B/ZEASS29D/rrSEMundPIWvdEgk7rG6vqu/9lishMwLg98XzY4aupI69o2mFIVALfEqOg
	 d6EHESVwP88bCZjo2S7Eop4iuhOx/q+XGVAXxadwfVFrkeybuujEAf8gYupmkyxwITvp4
	 O+Ct8wV90suIurQHqcQbYuwYdWZbfWBSqdtWSj/arr6W219fGd0E8XHdeWHna98IVIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NgMjlBk80pE1Le2fachQGto/6CKovjbvQbnC+GHDQMU=;
	b=UIgic9yGA78Q0gb8zlhytND5c3waKgEnPEX8OGH2u7/iKAxOSHk4g3UtRPo1cwbXzSV9
	 saJ5xGJtm6LwuXl1RlZeN4m4r3UGikmNyPDIGaqVXXRJakJjujVDzwAjSN2Ae+SZHn5B4
	 DKOO3Du2rpdhg9hbTVkkVF+ntS6CsSHMtCC5wK6prApiZiVN45pNUwS41sdwoiNccz7qE
	 NuBtvFOYzP8aaxFuhTlKFiltadyET2Me1SdF/eFhZbtlILc/i6VDsYxCnqj/pztaKIbRU
	 uh3YrDFIYU0dGQAFAOsLAALm0vWBtxCKn2mSdjwLVcATBxysFQz981hHGPivEQMVJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeIr4sXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACD606A643;
	Sat,  7 Nov 2026 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeIr4sXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF01C1F0089F;
	Sat,  7 Nov 2026 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062312;
	bh=NgMjlBk80pE1Le2fachQGto/6CKovjbvQbnC+GHDQMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeIr4sXimzs2eKtaZ3YfWx1jODJmIS5/i4YMpvfPmTJT96VVY560iSnpipeqoVA3K
	 x1fETiICNZd9kDOADqV8YJgDKjCSIkFuFW1iTZTvm6x/l3X859ec1oZrTSo9fyGS2v
	 tavRG69Onaw49NWV9AtgiwOZtTTt2HUvZvXJ9GDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Ponali <ponali2k@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1247/1536] platform/x86: asus-wmi: fix unclear usage of bd->props.power
Date: Sat,  7 Nov 2026 08:54:23 -0500
Message-ID: <20261107135032.792353463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit fd83d81ddf058d487e6d6489b18094f068e66a59 ]

The bd->props.power is checked in parts of the driver correctly
comparing with BACKLIGHT_POWER_ON, while in others with a raw usage
of bd->props.power and !bd->props.power, moreover in certain checks
the logic has been inverted due to BACKLIGHT_POWER_ON being defined
as 0: fix both the wrong usage and the inconsistencies by using
proper comparisons.

Fixes: 130d29c5627c ("platform/x86: asus-wmi: adjust screenpad power/brightness handling")
Closes: https://lore.kernel.org/all/178362762638.911488.8564892548331679884@eldamar.lan/
Closes: https://lore.kernel.org/all/ea9c63d1-4776-49d5-9dc4-6c09498f99c9@linux.dev/
Tested-by: Hugo Baigue <hugobaigue2004@gmail.com>
Tested-by: Ponali <ponali2k@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: zcode:glm-5.3-flash
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260916143838.170950-2-denis.benato@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c8a8e30f8d736..07d14fa33c034 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4132,7 +4132,8 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
 	u32 ctrl_param = bd->props.brightness;
 	int err = 0;
 
-	if (bd->props.power) {
+	switch (bd->props.power) {
+	case BACKLIGHT_POWER_ON:
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 1, NULL);
 		if (err < 0)
 			return err;
@@ -4140,12 +4141,17 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT, ctrl_param, NULL);
 		if (err < 0)
 			return err;
-	}
+		break;
 
-	if (!bd->props.power) {
+	case BACKLIGHT_POWER_OFF:
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
 		if (err < 0)
 			return err;
+		break;
+
+	default:
+		pr_warn("Invalid screenpad backlight power state: %d\n", bd->props.power);
+		return -EINVAL;
 	}
 
 	return err;
-- 
2.53.0



