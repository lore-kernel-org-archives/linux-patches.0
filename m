Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063298;
	b=bNAsSpRZECPDJJeAW/o/YRE7bY7UFHVnYp+I6QS35j51Qsz7sWtCaIezWwoW55hjnajX
	 /jxurLopmB6WGtcpBvc1UE9AcUWIARxMgo3Lu7TjozJ2XSwz3csBp8SAM1YWolTNWpmSW
	 yDHsnyoA3EFyV4Hxfq9O9uOX2IXBkEh7360EthlzbpkXltD0ETCQNT5qgAnIzSYQiRdrG
	 +J3rwSZc2PwXEHoXMRdw2pqBtivSNS8Y1FXA93d8N5lYCI6KWB+KiaI5sDdMcOztYtNoq
	 swT7KOd8sp8LqPnCmAMqnL9xnIEoDiHhQSPGCGsxbvg1v5aP3o86c9/4hUtEhLoy0/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IUc88kpyZd7VpPD757hRo0kqf4NsVy9OPNJ5l9WCvTY=;
	b=edjXbTvKW66CKELsmKfBJchtDVzDgkwsrOQkAhe5J+OzJ/zLV5vX1Kqnrk6iZJhNYZq+
	 dJfDQpuNTMKLieC9KtBnWEUseJT0SckupeFCLoH5yqHg9UOxNlra3C1apOr48AoV8ABcA
	 cZhZviweApcLGgkdqTHUoPMIySGonShobjl8xR8gk9ZaKB8cvlrmbRrRXUMLAzu1IS4gR
	 sNsOvojE0/KbqzQ/2jAhBnExad3aoGvU+EgG66P9OEJOLciVVzToIFwvij9QSOLThI/kW
	 XNiW+IouD0MKUQV8A9x/pXRqzBSfI7Gm57TfBUKTrEc5mDL3RPHXYX+KO4AhoMQIVRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0Z4ZTBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C23606D824;
	Sat,  7 Nov 2026 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0Z4ZTBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4D81F008A2;
	Sat,  7 Nov 2026 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063298;
	bh=IUc88kpyZd7VpPD757hRo0kqf4NsVy9OPNJ5l9WCvTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0Z4ZTBuCtVjCMVfsfoE+e7NCpxT+eAbSrqGriF65B75DquX6MaXto02jEmRqJhe7
	 6UaQxBZzXJP7i92nlCWUzmej5wIVcd04PBVVptCggnZSfJgVf447lhHMn+c98wIms0
	 I1b7cIWENhoagnlRmyIIJWOmaAS5d+7BR8cLO7Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Ponali <ponali2k@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 490/869] platform/x86: asus-wmi: fix unclear usage of bd->props.power
Date: Sat,  7 Nov 2026 08:52:52 -0500
Message-ID: <20261107134910.174327946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9f0f79030b5b8..adff9f49b5677 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4156,7 +4156,8 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
 	u32 ctrl_param = bd->props.brightness;
 	int err = 0;
 
-	if (bd->props.power) {
+	switch (bd->props.power) {
+	case BACKLIGHT_POWER_ON:
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 1, NULL);
 		if (err < 0)
 			return err;
@@ -4164,12 +4165,17 @@ static int update_screenpad_bl_status(struct backlight_device *bd)
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



