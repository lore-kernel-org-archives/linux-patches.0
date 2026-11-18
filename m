Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044392;
	b=F7S3Yp22iGeNxOzl12t40CuG5NZ0V8fZfAU7P5y2/T184rDEfZtFFBJChSmTVVPX75W8
	 BEbIb3yh+iqyZB1SSJ74pCFb3s390+gtMZSKBkptfWRPCW/nqTWsh5NrlDTJ2AZZDeF8g
	 ovypKXbLd8bNfsTb5OZ06i34X3AcbWi84gceXMJVVOSnh+rgNCBpFjxTbJWz8Rab2z8Ny
	 caUlMgCVHvhT81FGedxizXtqNa73Zv7DZbDatJUuIpYzmG5dzHXVm7TW6uW/xSDFXc322
	 sOAMIH9G1RaZKw+PPEFVSTzwLVmOrQW//5AbuzK9KJ7nEGFYD+hUGT4T7298ziccZ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uiLpjQuEP1bu5zG5lmCD38nkXBK5kJlZ1F7lL4Fju8Q=;
	b=hc8noXUCuAIhXua37hZQ2Ag0eDJmXOh+caB/nw+iSuwoTjOhh9+kduIb/P5vJWiBu0zs
	 1GFHO0Lj0kiwB8+NdTEnQmBPsP3jN1IUj03Jp0iBLUXmQcQDs/UGdVQK7ut0bBiRMhyLH
	 9seMHD1VAZoYZai8krCZCrJzU4AiXsiWBFrYDkUpAj7reCeqyePb1e+bLqQyIYmOdA/P3
	 6BBfqVmS0awt0ARqxr8lG+pgTxYm6W3UdOgQpJvDL/M5RD9wwmsOUU5T8tFGhXkTeO8MG
	 xV/4n0lGyAqLO0Q0K09gDPfOFskuP1aPGybR29hM3hgqThYL8fbRhmi13I3e9GcysfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oetwc6+s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BDD606A31C;
	Wed, 18 Nov 2026 23:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oetwc6+s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68C71F000C4;
	Wed, 18 Nov 2026 23:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044392;
	bh=uiLpjQuEP1bu5zG5lmCD38nkXBK5kJlZ1F7lL4Fju8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oetwc6+sfB9Hy4vNFEW20YfyIWldyM9Obh7IAXKXgM1BBuXlKg7ipUWRTP7RMEGN1
	 9EkxEe8zN/g16alIV1gSw9a5y92cTREGz8LO1TcxXv0JuRAiB4N134D0cfVkNlprLX
	 cvU7l7Pf70nKGUDHqANc7y0QLoNT5uX/lZWqXcC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0550/2857] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Wed, 18 Nov 2026 15:26:24 +0100
Message-ID: <20261118150221.292276613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3943,10 +3943,18 @@ int wacom_setup_touch_input_capabilities
 
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
@@ -4369,7 +4377,26 @@ int wacom_setup_pad_input_capabilities(s
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


