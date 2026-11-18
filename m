Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059242;
	b=vdMfSHu59xxC/nMgjYPL/N7lSAPxK6kX5injjF3Kaseb6uFgUxbk+SaDRwjMgGdqN2MV
	 WjIwRzH1fBCQu8C/pyhvHfdmAuS+HBYr1xGrwBsMUA8OWvCzJYZqNwbipmQHNBORsDjk4
	 zaxTBmDvq2z03PyfRIIWKgdIBYAgNeANzd6BsvV2Q3w2gsord0+wUfXw9uFanSLRDjTE8
	 FTvkY3ZesSurMfxzU6LoRKwJqmFjllr11lY9sZEPDxALEXR1b0Kjix1tw4vk0p5r7zTW0
	 cQDZU55+Y8lh3MEfRmwnI4i7fapqd9D5fdbwGZ/OtOs3PskVth5bzHBYk7Xlgmw0SNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGEpcs/nFa+YtvpapYd5A6cgUkoEg0TQWZMO9EEzR0c=;
	b=PiyZcdC+2OtiVtmtL8RSzMK7baoDJTjdxf3/p+DriGbc0ja0IeSCN764EEwktglm5PO6
	 LRRBWdAsl67C0/3nvhMaNvFGHFxr32azeujy3SxeIcSl3XipQ4lETaRDkYlr/3ibzpNLR
	 ACH6aYnsr9oWiOx6CkvvtIf5w0J+eHkpakIdwP0fLnTzz8N1wGf7okLtF7CAx9CG1hijR
	 sDU7QIe5Z3J5gA0EsQS0ZMjtntdevLSd9bC2PGoLmQ4bxEdHYlzh3TyA5K6AMAs7dytqb
	 y27Et1RXiRoX5tGVyrV5ZrAxxwuBQEeVBexdpoaEVVJWPewBof3WLXprzXiDzRIn+9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQsa7zBn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35800606A32A;
	Thu, 19 Nov 2026 03:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQsa7zBn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E4B1F000C4;
	Thu, 19 Nov 2026 03:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059242;
	bh=CGEpcs/nFa+YtvpapYd5A6cgUkoEg0TQWZMO9EEzR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQsa7zBnQWwy0HSvdus4zTyRV9CqD+f53rgfsi89R1Ns0DOzNa99r5QNgToGB11BM
	 aAyYKJAzH7NVYITuCsgMKtTCdwPOfysCbfc1ThvBMNBnNWpAjlouXmDFkvg3R9OXhP
	 8yQdhvzAwYor7WHIDb91wdP0x7uNU1jZhuIGxiC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0772/1848] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118145948.692939540@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <ping.cheng@wacom.com>

[ Upstream commit 97ce491bcef2d231b8d51cee8e579183319a5ba4 ]

The refactored SW_MUTE_DEVICE code assumed that stylus will be
the first regiestered input. In reality, touch can be registered
before stylus, such as the Wacom Cintiq Pro 13 and 16.

This patch covers both touch-first and stylus-first cases.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 4c7ad9dc543e5..0301f345a0242 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3882,10 +3882,18 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 
 	if (features->type == HID_GENERIC) {
 		hid_dbg(hdev, "generic touch setup\n");
-		if (wacom_wac->has_mute_touch_switch ||
-		    (wacom_wac->shared && READ_ONCE(wacom_wac->shared->has_mute_touch_switch))) {
+
+		/*
+		 * This is to setup the touch switch for those devices that report
+		 * pen interface first. The setup can only be done here since this
+		 * routine is only called once. When we are here, the shared
+		 * has_mute_touch_switch has been set by the pad.
+
+		 * There are two ways of reporting inputs from firmware: stylus first
+		 * or touch first. This path covers the stylus input first case.
+		 */
+		if (wacom_wac->shared && READ_ONCE(wacom_wac->shared->has_mute_touch_switch)) {
 			input_set_capability(input_dev, EV_SW, SW_MUTE_DEVICE);
-			wacom_wac->has_mute_touch_switch = true;
 		}
 		/* setup has already been done */
 		return 0;
@@ -4307,7 +4315,26 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case INTUOSHT3_BT:
+		break;
+
 	case HID_GENERIC:
+		if (wacom_wac->shared) {
+			/*
+			 * The setup of touch switch capability can only be done
+			 * here for those devices, such as Cintiq Pro 13 and 16,
+			 * that have touch input registered before stylus and pad
+			 * inputs.
+			 *
+			 * There are two ways of reporting inputs from firmware:
+			 * stylus first or touch first. This path covers the touch
+			 * input first case.
+			 */
+			if (wacom_wac->has_mute_touch_switch &&
+			    wacom_wac->shared->touch_input) {
+				input_set_capability(wacom_wac->shared->touch_input,
+				    EV_SW, SW_MUTE_DEVICE);
+			}
+		}
 		break;
 
 	default:
-- 
2.53.0



