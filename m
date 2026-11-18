Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057466;
	b=sV/I2pKToaNZ4Ul5/RGwNtgkv8cACGW86Lkv7N6ktgFwJR/NDMXlUtYZFqCOZgnhdoM8
	 duVJhFa24ansoE8HFBW12R40Cdvaj80VYHm0YHpmjjkfFpb7ttM8SAODTJaG2FA41UYIP
	 nTIxmB5f7Je7Ex7KizNbiQeIwzNIbVVVb/wWrfGIue+S2DfSzmg/z2+Xpf5i9CigWmp/+
	 ENHPbVdy2LLP+cyS9fHwC6WIrIgrN50FOCW+cYGMtzkAJweoTntnR7RrJdVqNnmrzlghW
	 yqvwez6TRAIHiV/7iIJ/WZL/lYOR+z5Zlt7maUqYhfOIv1w+HDvo5rjczPD2D3Tn5XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9Qze8FdpohC3v++mOhk5jIuID6NFEuF2M0c9c5GO5o4=;
	b=xIjA/jgq18fBZrvcPDQGeXfoAPSm1ZaL7C+9rvatW/xmtIo5Nwn2xc11+DbMI1iGJaPW
	 cs2T/H8pUwa2JmzdkC2FKBB2gidj1S/od9ETnrM2g3jyfHuqav8YpQKOhiq7fN7nG6Q7o
	 At+1sS8pN9OrOTMXvYNtYSAb5yqEhTqEcGV6QTDkhseWu0fTLSpYmWhKFR150GPctrHa4
	 l5aMtpJhWvv2KUYFhQXCNeO5Mgn3sAM5vAntASPiDa6iW/OuGMtW73gCO2Tcq87j05P3C
	 0j4KldjDCrpp9BbkN9vAKHdETJ0/cWVNcGIg9MzTOwjcRmAHzaodtqJR9U2lM1YjrMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SXzlLRp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2A260A2621;
	Thu, 19 Nov 2026 03:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXzlLRp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE731F000C6;
	Thu, 19 Nov 2026 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057466;
	bh=9Qze8FdpohC3v++mOhk5jIuID6NFEuF2M0c9c5GO5o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXzlLRp/02IKoCRC+QrtVNg1VJCEL6q9ANfQ2sFSvGDiLAgIrVFNu4ShcBtVwD5W/
	 zv/KncuZt4knmaNIUi9eMVMdzOVnuwGtxABWFn5pE9YWKpQ/OfCJiNTDILbeXFGuUn
	 mUZXYREMCerI9BI0XNdZxhiP0ynXbSf8ioL+2IKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0099/1848] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118145915.222292753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>

[ Upstream commit 6303451189a6d8f304221065c44ccd597e0acbe5 ]

The dedicated "ProArt" key on the ASUS ProArt PX13 (HN7306) emits ASUS
WMI event code 0x8b. This code is absent from the asus-nb-wmi sparse
keymap, so pressing the key only produces a "Unknown key code 0x8b"
message and does nothing in userspace.

On this model the key is exposed solely through the WMI interface and has
no HID scancode, so it can only be handled inside asus-nb-wmi. Map 0x8b
to KEY_PROG3 so the key emits a bindable event, consistent with the
existing KEY_PROG3 mapping used for the ASUS programmable/Armoury key.

Signed-off-by: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260719090843.66777-1-nizar.m.kabbani@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 224c1f1c271bc..e843546f33851 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -551,6 +551,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



