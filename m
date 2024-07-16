Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12951DDCE;
	Tue, 16 Jul 2024 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145726; cv=none; b=rEhCvNtBM0sPvWs3MOZbyZCc9HLzBtt8EvQR7Jv7GgxoQOMYQQ+g7OtAClvNJg3DI3xWp7D0YXLUjPkb6SJqM8TPUkXef8UrFGMIYdZ/iqYBKadMbNjCcgjOI/DEmXSrs2vlKHyEp35Y/Td2nndIHTv+FwJRIf4WE2UIyVxM1+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145726; c=relaxed/simple;
	bh=R7IK7Z5aiC5ph6S1sm9ut614bq/6ryrTld6UprKIFzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evPq+x/tPgLmDaF515CrUzIacVuwnNyppJ7ND08NOYL22Ux36ZiVrdlLmA0yPGXNC7Pr/ITF/7gyEpTu+v+6HFfrZl/ENJ1/OcbWyOxyM8adcs57AKuYTKu+ShJbirL/k8wwa4qU3maGyosCovrwIgkTh9LEG0mE8HLUtFFM4IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/cmF3GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/cmF3GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A7CC4AF0D;
	Tue, 16 Jul 2024 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145725;
	bh=R7IK7Z5aiC5ph6S1sm9ut614bq/6ryrTld6UprKIFzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/cmF3GFxs28/Ary89xqdXKxY8+Hd+mSb170uLlZAi+HAnu40Kdu7gVvdOp0FUDfk
	 crG28i34ZwGBc9Rs6WDwNwyC2CY5SA5B48jxw+3wdM+tIaMJ9FWcGxyPt/gWK831by
	 61Bm8suQKy/AD+R8dvbD0hszf8v5z2ZZkhQzVRmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 064/121] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:32:06 +0200
Message-ID: <20240716152753.791854732@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 3859e85de30815a20bce7db712ce3d94d40a682d upstream.

START BP-850K is a dot matrix printer that crashes when
it receives a Set-Interface request and needs USB_QUIRK_NO_SET_INTF
to work properly.

Cc: stable <stable@kernel.org>
Signed-off-by: jinxiaobo <jinxiaobo@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/202E4B2BD0F0FEA4+20240702154408.631201-1-wangyuli@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -506,6 +506,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
 	  USB_QUIRK_DELAY_CTRL_MSG },
 
+	/* START BP-850k Printer */
+	{ USB_DEVICE(0x1bc3, 0x0003), .driver_info = USB_QUIRK_NO_SET_INTF },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


