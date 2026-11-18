Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052058;
	b=LPpdiW5CbQosNtFzeV+PrJMd/p+4yFC5vMUor3PN0vDLCKLCU8eWfCvWysGfP7WxKR9t
	 hWtEa/2bYs9Ecw2QJm6Hf0aPjLrGZE6BJWvQg3mfD9mxh35cGHZ1LXO4L0jDArDZJrNy/
	 kNKg1Uq6jzWRy3hb7187zgMFThU7nTLgwDbC3Kg5G95AIw9oOHz/loaCV0p13DW9XeanX
	 uPMP1k09FGCUrz8sJR2OaXqAK5/0ktEZs5cAlnoUqCpGNVt1R1ZxYt9pVDK1uJiH52uVl
	 vgyOzyBz8H1YlLelZJlKE7Q/j+6GKEiGBD2DZSzJWcvJu0HHJS2zfdjxx05GcZhF8rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wmAXOM1MTLWwHIjNGhWBm+OV0kPGjGXrlxBJg/SrrLg=;
	b=foBPLquNXT1OSKd7enF8fW+9aIGM/i1hrmgvOklx53iLz1CcOq/ET6wBCuK0Da98c6b5
	 QTzIMbxyWpcL+buO6UYY+GaJgS586mVmGPwZKPZwlQOLyYeQD4yQW7XpHunXKJttCs6Kz
	 IlbPZ1V5tNB7uhOqfU1IVgqfLVa0hCicitIEwKEvqbBMAjkUYrDiuodOkslaR1ZagTZYd
	 xwxHsDG/VgFZnfhUOKeAeiJHRRnLkOT0/uwQj/bdVIZqvsO/fV9fYmMSw4k5nrgLYd0/a
	 OMixNNbDEWB3jMJgpjtGXcNpZv0CXlHqY1WcallPmiD8d7quAqY0msR0LkUASmmWJWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkr6D0mO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C2606A320;
	Thu, 19 Nov 2026 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkr6D0mO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCAB1F000C4;
	Thu, 19 Nov 2026 01:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052058;
	bh=wmAXOM1MTLWwHIjNGhWBm+OV0kPGjGXrlxBJg/SrrLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkr6D0mOQN4kK1rbeIEo+yB59/zND8BIOW6OQKH4nFMiphfCyewnhrQ73WXtbV0AC
	 iBjAzhInuHddVbiGV1YiwXGR//yfi7YXOx/Hr2IO+HP1ipVv8YKAFKH5JqjClqQlMF
	 nvRK23Mab1f4EeEQzgC80Y449bj8CSXfKBhTxrCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0430/2214] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Wed, 18 Nov 2026 15:35:06 +0100
Message-ID: <20261118150028.084678302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index b1fd91aa5e370..78d7fda68f207 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3912,10 +3912,18 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 
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
@@ -4338,7 +4346,26 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
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



