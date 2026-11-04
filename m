Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827088;
	b=uZ3PCWM8bFpVBZd7yhziOWE6tYOQwwkTFa54P8h07bTT9W7RQ++EjL2YGhc0GeDSrCdM
	 9zWXl5c8Yl2GWjzj5t5ewBSEkRXg2UloDXdbvCTYsa6eg+vridr8EoHa1SLRoxj7cp44h
	 gz/OVlRv9J99fJ7NTT3ks1ZZ4G0PM3CxWoPNRm03HBvNU6YGJwqifkhguZLAuPq11gcjy
	 CZ5g9qqTJ5s7hBsvVvEfYDW9HV+VlH3MA0VYZXinjH6+cOhzqTIHLWx1QYGPd7mnPIXt0
	 fbVkMhWdsm3VCf2YdZo2hJKdGmkdrtSXQRU7j+m+G/mCRj6r9vIhfLtRpqjuDRCH+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/lp7uuxIyCxxzXn80bCP9h6DsVSTL0q7kcm+I0pDzk=;
	b=UTeTOO5tee9O0k2K3dAs432uFguJXvjiht/6s4Vvv1WszPoNqFghlTkC4ftGm5XZZXdH
	 b2Ee2PGNp0f1kU7k0vQbTWMEu6nBS4RJfpLFbIEtBTOagml10enh2d0sJDOdQGJdE7tEg
	 oUVWHIT/xFkGBr33ovnYcQCLHHcLaNSC/rFK10xMqDvXoETp1/E0ZyBwWYgiuUtGfBmT4
	 YHPQWRBpgdLmOaZK+cXHJ1g6Gjx4/O0JK1dOxEccD/GdqtsYNJzOPfykjcb3UGxuZQlBq
	 Rxafgsj8iwPCYBe+SmCGYmhno4KadzebW8K6trajwHVRKs8fbw8iNudhiFJiBd3kgSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6NZqKju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9149606A86D;
	Wed,  4 Nov 2026 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6NZqKju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4434F1F000C1;
	Wed,  4 Nov 2026 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827087;
	bh=I/lp7uuxIyCxxzXn80bCP9h6DsVSTL0q7kcm+I0pDzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6NZqKjuVH/1VAZbHO3rBJJrXNSFF7WB8V7wxgqiK9FOkciNkR+d/cWKMWltXQ7ob
	 H8bsYm6o0hWcdV6UtprBnpCTtU61YW7LHwASSqlWwbCrAqc0WB2ZFmw5PYJ02iJDdQ
	 Z7r50Ll3RcSco7uFtO//YZfR+h249BhY/8VZDD7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 188/547] HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration
Date: Wed,  4 Nov 2026 16:06:12 -0500
Message-ID: <20261104211043.480268450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3977,10 +3977,18 @@ int wacom_setup_touch_input_capabilities
 
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
@@ -4403,7 +4411,26 @@ int wacom_setup_pad_input_capabilities(s
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


