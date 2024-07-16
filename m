Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898201DDCE;
	Tue, 16 Jul 2024 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145031; cv=none; b=jAPUNEIQnGBXVGvl+sbtS70Z5/AoO8cCpBdwzfPPPoqY1aqXmzUSZUtsAymaxZfO8ELGJFQB8lUkO+lGpI4jvhi9GN41NM/dI68YiGh0se05qXEntgDeXF6YR/S4UzWpYO4GFzcISIuyGANNrGrMSJkyvuHBBWZonrpRaOW1Qmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145031; c=relaxed/simple;
	bh=sN+5AqOCbAEV8VRTc6V/2nPMZXxEVW0fwf74xU/NKEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuitesKovh8WnZqKes2I05thj1KWWU/IanbsrkAbnbj1snO5XjwShpmXENten9IZFY19r+5jQJdSsDFxvPZ2nPz5onGnKF+jFxR8oBnBFx+9qH5FVffyrM46q1ltKieugbEMwhG/hMLbw2XzKFVF6463lESDfYNHlQTncyhyZo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTglqeY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTglqeY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9550BC116B1;
	Tue, 16 Jul 2024 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145031;
	bh=sN+5AqOCbAEV8VRTc6V/2nPMZXxEVW0fwf74xU/NKEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTglqeY5kv1ycH5Ce5chPCEEJ+DXNLU9n2Jruo7HW2lx/gP4pZcGJpKPyMEXdRPb2
	 oHYMJ2aD1uzNyKWOJpu+7PZN/LWquym9S+2VeI5PtgnI1M3OdUwFDj7SkwqmvjvjVR
	 URNeq3EBEs33Snp1moYghKKTDpJh56YVMB5pQt4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.9 076/143] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:31:12 +0200
Message-ID: <20240716152758.901914509@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


