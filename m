Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9721E98EC;
	Tue, 11 Mar 2025 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707552; cv=none; b=Fw40+ZApUAJMKyAROVfuQeYKIphLS3d4HDoxgIO16w+Iofmo4TFjnmZfIAvtyV2W8GPa6Y5aF6G3GOQXNFdi1V2mlH8vK572PzNry0MGSgO89Q+5NlKEo+pT9wRVIxLQwFizfc6nMxR6M88l3o0avGHUrM8MHrF5Z+yKKtWW16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707552; c=relaxed/simple;
	bh=oPEhnpw0yOhCwIZglHw7wC1CidSVJ5XQJJeKvSYivxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYxvxV8ElD+g2Wvyr4+GOYGCTKYzJOV1ky0R+zNaOQZ27UYFycbdI3M19sSAuUN9mpugvbosNe/hv2rjbM0xs27X4s1y3wDx+WkDKOenHigjP8EugfDjCFB/Zy2kD1wGCSlUoOONx/1r9WbbxDNoi2G4+JZ6x3D9plYecoWB9ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7XAV7W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7XAV7W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B487C4CEE9;
	Tue, 11 Mar 2025 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707552;
	bh=oPEhnpw0yOhCwIZglHw7wC1CidSVJ5XQJJeKvSYivxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7XAV7W+Tf6Ot8K7jB/OFVA+LoSZFQ+LmlEgihlhx2d3AUlIgHFbeAQ9OkOrhCfpS
	 RlGSYv6ZQZMzVOn2Iac/dJp+UBCoDzQsa6IRVNeSzPUPUKlb3mRLvDgIKFnCr1lue8
	 29RFl7jSkkWvbuxD2h4wiF7wKMg2syHXbNo9R0VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 428/462] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Tue, 11 Mar 2025 16:01:34 +0100
Message-ID: <20250311145815.244635218@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit ff712188daa3fe3ce7e11e530b4dca3826dae14a upstream.

When used on Huawei hisi platforms, Prolific Mass Storage Card Reader
which the VID:PID is in 067b:2731 might fail to enumerate at boot time
and doesn't work well with LPM enabled, combination quirks:
	USB_QUIRK_DELAY_INIT + USB_QUIRK_NO_LPM
fixed the problems.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250304070757.139473-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -338,6 +338,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
 
+	/* Prolific Single-LUN Mass Storage Card Reader */
+	{ USB_DEVICE(0x067b, 0x2731), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_NO_LPM },
+
 	/* Saitek Cyborg Gold Joystick */
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


