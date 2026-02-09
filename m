Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE4428312F;
	Mon,  9 Feb 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648852; cv=none; b=b3fYNSysx/4qLbka+CSU6vlAgAiOs97VUbG3J4NRc6AtOD9WyPfOILJZrzrxD7BzH1Ndvg866em+SfCsdP0HPSQ0lNRElud7XKKulnsFcXE5LAhQaPxs3WfJFES8JC2bbDsGpUPTusyIWJ+piITtDZharRcqqu1DQd451Qf5Avc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648852; c=relaxed/simple;
	bh=KwzY0MyMH2q8q30Ov7V1n0LpmFdpIaeUq2HIIpg1ue8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPjDaL00Vhaq05CG2OC29yVaofjII6pYa7kqQo4k/uURKAtlcmMlFljBudprtC9b8KMIeu406cUwOTaPvQaJrHTbnF0bZoZZeeb78Jo4Nm5JN8KGlc2wAa/NZ4SmN4f3FE5Sa/4iboe2IELmim2ZxmAufeQyoX4sCDh26jEt9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCCt8KM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCCt8KM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0295C116C6;
	Mon,  9 Feb 2026 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648852;
	bh=KwzY0MyMH2q8q30Ov7V1n0LpmFdpIaeUq2HIIpg1ue8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCCt8KM3Hz5NM/Tg0dn4FyNt3sCArROIjKQFTg4SzTp3HxsmuSPQ5IgLAW3feRG0G
	 gvTDV+HBDWE+HyfnYHeZ3alDYaRFGL0S1zjkdPBt5ONRtOcrms+MQoZ88/ljhXS/Dk
	 HyDw03+zqkkhqdBoHliVHTStYjX7CRE0FU5KNC/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/75] HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)
Date: Mon,  9 Feb 2026 15:24:32 +0100
Message-ID: <20260209142303.112641607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>

[ Upstream commit 85a866809333cd2bf8ddac93d9a3e3ba8e4f807d ]

The USB speaker has a bug that causes it to reboot when changing the
brightness using the physical knob.

Add a new vendor and product ID entry in hid-ids.h, and register
the corresponding device in hid-quirks.c with the required quirk.

Signed-off-by: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
Reviewed-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index de62855d89f14..1dc28cabd71d5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -401,6 +401,9 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002	0xc002
 
+#define USB_VENDOR_ID_EDIFIER		0x2d99
+#define USB_DEVICE_ID_EDIFIER_QR30	0xa101	/* EDIFIER Hal0 2.0 SE */
+
 #define USB_VENDOR_ID_ELAN		0x04f3
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 445132b6f8c88..b4f4f6823c5f6 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -81,6 +81,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_PS3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_WIIU), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER), HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EDIFIER, USB_DEVICE_ID_EDIFIER_QR30), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, HID_ANY_ID), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II), HID_QUIRK_MULTI_INPUT },
-- 
2.51.0



