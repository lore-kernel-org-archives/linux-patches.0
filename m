Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061590;
	b=5BnGXXU1pKk/ESxTTlr7KbJ58sTJNan3AIw/1sceaLgo1x4D0J480wGjhIfR2hDjrl9B
	 os1KdYObHEbzQPmmpAbANxhkA/AsppqkZMnbMFDWOkH3p9HLYXeo/7WGdPriUKXSJiOh+
	 2ASBQr+w61Iey0lUIk6KdPVdiFH0U5QdxJnleftx03EnwM2uuyb1a8Pzo4TL1E/PGCJLf
	 bmc+rM4ztrTmJrljxzq5HQ/PTphAG3PtOsuktfw4NFvlSbvG06awa4qEySsMmWxGpTaJo
	 EwBwXo6vqwQkDGmsp6qQFOVf0b9bqI+UqOdwRsJdb1eCkOxLXyvFhHNntAgTR0kOCCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KteRYZQsNKbpw3a/G+cm5MUP/SMOIPLizQsxdK5wsiU=;
	b=zYQruXxptCJAUhL6Arqy+lazo86NVRGtWdgAS7uhzqrZzzHCro0QeTzSxVuxF2QJy15m
	 8sq6DlQWIDaJMtNcKwy1OT3vhJUnhfMcGEF+IobVHxA9BEM46YZpwNfZef99BNCYaNX21
	 8n540OnUt81kIETtTvoa6ZHNgOCGIJjfUMNVybT4j2mZ+NIBqWvVMr4ZhwIUYaAuSo5yY
	 e/OSHsJ5Fhuzb+ExR9rhafEI5mU46B6Y3805yTOeZkNFnHc4oQgjBxLr7MkfzDMWwzK2q
	 Zelq005Kp31kTSiiTxyz7EGmdwl0P/Myp5tjBdOtTpagBYPGYhGJ9bXCyWmo+5Bp2OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkyUSqTW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B20606A326;
	Sat,  7 Nov 2026 14:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkyUSqTW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F21F0089F;
	Sat,  7 Nov 2026 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061589;
	bh=KteRYZQsNKbpw3a/G+cm5MUP/SMOIPLizQsxdK5wsiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkyUSqTWWcBOaWnKx/B0MzRISoqoNMKAYpcWniHmTykh69bieuPfrNtO72Z702VDN
	 Ur5YQ55/dqS7kOFew7HKs6Bgn7YS6hUm0NoOB3oP/nuAcP78FTCacpt10VsNgkWdHv
	 MNC8M5nKQPzNP0/+YuVPmFjjWPDqlNwfZtJnKQxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0626/1536] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Sat,  7 Nov 2026 08:44:02 -0500
Message-ID: <20261107135015.115916789@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <ping.cheng@wacom.com>

commit 97ce491bcef2d231b8d51cee8e579183319a5ba4 upstream.

The refactored SW_MUTE_DEVICE code assumed that stylus will be
the first regiestered input. In reality, touch can be registered
before stylus, such as the Wacom Cintiq Pro 13 and 16.

This patch covers both touch-first and stylus-first cases.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3972,10 +3972,18 @@ int wacom_setup_touch_input_capabilities
 
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
@@ -4398,7 +4406,26 @@ int wacom_setup_pad_input_capabilities(s
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


