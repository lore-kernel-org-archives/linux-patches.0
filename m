Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E97212B72;
	Tue, 16 Jul 2024 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144721; cv=none; b=UIjY0/ur9p1zMAvDEwwY/IQyfxLrj+8NbT4cThzR9Ggtvq20ENr76jikCggxm0tfQfNvofeVkGZBSSb3FqgDkaQVgiWdZl2wgNcgBkr06rT/KE0tHWC8NMLWLydAcm7oUgSKmFgL8i8szk71rXT+Y7Wo3PGOfNPa1nDi0h3E6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144721; c=relaxed/simple;
	bh=lf0OntD+UyICgjcdcBlDBgWEnSG+1wCdaTAquyRngwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNwuWNM4pPboucYqybo1dcX9qcUNOlPA7GRx84VJnP6DdkhidXBTwKqiTBXxUFODPB/M+XlyZRCts1bgex7LRDcZ8GdcG0D2xUfCdRzqgf9Ki2w/On8BTVropr7UDYGRBD7kB9nXVm7ogGCXitt3LOmBP81dDe8pWTVtyS/fEnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpZF2MTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpZF2MTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F419FC116B1;
	Tue, 16 Jul 2024 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144721;
	bh=lf0OntD+UyICgjcdcBlDBgWEnSG+1wCdaTAquyRngwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpZF2MTC2bU+Q0AqnPdUKlpFGRduh84ci15BLA5Fp0zebdggouyp0a7tCRgc0y8jP
	 mrkb6qJghG+0AECpsTtAnPpVIoiTLcy2/pmno9sqVsLg/Gnc0kX/dW7N0tcQX8ZnOh
	 aZxWihB/bliOtTFdSTrLGlPhzTbeS+fBnJMT9064=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 5.10 083/108] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:31:38 +0200
Message-ID: <20240716152749.170106799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -504,6 +504,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
 	  USB_QUIRK_DELAY_CTRL_MSG },
 
+	/* START BP-850k Printer */
+	{ USB_DEVICE(0x1bc3, 0x0003), .driver_info = USB_QUIRK_NO_SET_INTF },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


