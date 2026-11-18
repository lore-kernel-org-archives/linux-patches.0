Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035099;
	b=iDA33fY6Us9wEbu/fYOGknqz3jNkm+i6pQTmI6wxA5i/tSZ4GD7auWTaVz1lF0fOzKng
	 8ztDX0H2fJR/eJdAq4bI8fv1DhR1C6YlUrq1MpW7QzihlfSFF+ulyP4Kr0hy22aR6J/xt
	 wxY5fKnifZWcyVUdB1igFgXiX8NCAIJNRFARWOZtokq4veZUMK5mOLibsAtyBdyfo93Zp
	 Qn2KZVX+MgITjkC05jqrpKPKGfVH0+gPZxvgH+SVmVu2aeu9XWaoQaeL3NQG0v7RONNXX
	 lJeXVO8Mo8kTKF7S8cXELrFakkqDAbvzrCBwFnJQ78C1OIHrvoWQdJezXabHivD5vvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w32VNI0W9t1DgxXR6158lac6WGh2DT9fOZeQyiJN+bA=;
	b=ieG+iXIJHlTmmpbh+tXLkreTixoQjNXFIvuD2Y3hfpbGBVlG2Wf87Uh4St88yCDGj39c
	 RYDJQfv8TJDT/AsLHQqpc9+wpeo18BEeOE6ohAMhKfTRpQnzMtSh6KG7+TLo3Yo3Z+5e5
	 wLsQltt0gojMnlr+MVKAFA6UvB3GrJh1trRVLDlza+OIT29WRIAg0NegNYOqcv4XFy03L
	 DLBGRedanEZVh5kcg5OA/pUFLuXDeH/IcactGZ6DabnUHy70d8H5uKAv41PhiHALaH/gG
	 QU2XeGwBM/zUMv2/Yd1qJ5dLa1xLzT2NJFAV3EQ4LBSahupjUG8fKwQFvaQZK+DgYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaOnzA4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E80C606A31C;
	Wed, 18 Nov 2026 20:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaOnzA4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A551F000C4;
	Wed, 18 Nov 2026 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035099;
	bh=w32VNI0W9t1DgxXR6158lac6WGh2DT9fOZeQyiJN+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaOnzA4cO+WHlNnEzLAfA6vyT/t4jJ2s5nSzf60x24Xy0SYMdyMFvAVj435V2BI+j
	 K4d4gQ5x+09tYaqe7WVwjqXo1M9tb6RAanBYueDpX9FYBotEkyMGPaY1i1zLYojSl7
	 1PtCSQElVUchHpsqszhn6j2uaIROUkG975IH07jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0606/3318] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Wed, 18 Nov 2026 15:20:28 +0100
Message-ID: <20261118150335.903603937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3940,10 +3940,18 @@ int wacom_setup_touch_input_capabilities
 
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
@@ -4366,7 +4374,26 @@ int wacom_setup_pad_input_capabilities(s
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


