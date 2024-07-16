Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61A719AD93;
	Tue, 16 Jul 2024 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145416; cv=none; b=Ow8VgRwwFem2MU3tnp7plPLIxfTdN7ZBpp5K2YzjgugZUPiDQtUqNXoYsDic1LtaXLsLlicStnqDc8N9jyY+ILn5tFg6om4+8wibfr7nDW+tmDP2FMixuBOrE8FUTb2vZ2x344Yh2vxjkaERj5HgYCKB9cf+aOzYUHlQTeKUaGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145416; c=relaxed/simple;
	bh=9Nl2eSB/KPw5vWnwMqWyYvlPJqSRP14DJq5RXp0OM+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTQfzoGnIdp05v41/Uyl50/TXfosBsydwmFIXeqVqD3P/7da4533T3y97IihFWTDzq3mL8Rwc51o51W3L1z0Ppie48lRMR4/KO7IF52AdKeoqF2RwbwqVRq7tAS7taxzgIOy7KM3LyYSNq0Ie1QxjR1imy77eC2DM2YU6kLsLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CMrLN6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CMrLN6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D1BC116B1;
	Tue, 16 Jul 2024 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145416;
	bh=9Nl2eSB/KPw5vWnwMqWyYvlPJqSRP14DJq5RXp0OM+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CMrLN6xnHJiNFHFa39AI49u/ehuVPuOtr91EjIpxDZGOXgkMj0j7KMAtWMbQ7jHu
	 4rscYJ4G7OYIGqYbTXoZ5vFq8SDaNwivKjLozec/o3wxtBkgmN8cKyh6UGiMnStI6M
	 Z6ywNEd0C/5ELliAxl2pIDucY8ifXsD97cX4889s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.1 57/96] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:32:08 +0200
Message-ID: <20240716152748.698184290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


