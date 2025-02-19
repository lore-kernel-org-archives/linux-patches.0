Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67E72AE74;
	Wed, 19 Feb 2025 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957390; cv=none; b=iyr9dK8vcE1s7xST525XthCu4563yAps6scgQGKKStAJOXh7GRVV1izUpOrRY5E6o4nUuOQrBwAR5uJk80x3WdJTM59GzBRhlAV1k/TCzT3JouspERgku3vnnnySMAAugAaCDm50e4LShA41MU8m5b7hduuo5ql25dU7XUSc1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957390; c=relaxed/simple;
	bh=OcdA8cTbCjIwzigM0Jy+Hy3MrMS2QBYcsvT0OGO8hu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0jQSs30phq5Mm+pIg5Bscp73l/1a32fNylx62b2T6NAAGrtfeSq6RXHrjI8j2FXjVpSew3YXAlWGSsOfl1/BE1J2lAxHSpjNWbd+BSGqv7XmT0aH4g9tsNjYrR+Zi+aveds25M3ZUmpLkhx5OYh+iPCrYJzd6E3hgUcNLlfVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqnAZiJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqnAZiJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD70C4CED1;
	Wed, 19 Feb 2025 09:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957390;
	bh=OcdA8cTbCjIwzigM0Jy+Hy3MrMS2QBYcsvT0OGO8hu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqnAZiJdSkkRSc80MCLqK3/Q8UPtDGLeK6GzyuSwdcuIx89OMSN1j371kWCGxpYrH
	 2NegZUnyvJu/sCwOO8CjIYniioC+K1p49lOG4D5aCUpam1W0s2oL/gwvM2faHQSsZm
	 OA97NPCLEYzMpIEuynz/Rc3uZiwMx4Wgqqn+So1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 509/578] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Wed, 19 Feb 2025 09:28:33 +0100
Message-ID: <20250219082713.007628208@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

commit e169d96eecd447ff7fd7542ca5fa0911f5622054 upstream.

Teclast disk used on Huawei hisi platforms doesn't work well,
losing connectivity intermittently if LPM is enabled.
Add quirk disable LPM to resolve the issue.

Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250212093829.7379-1-huanglei814@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -522,6 +522,9 @@ static const struct usb_device_id usb_qu
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Teclast disk */
+	{ USB_DEVICE(0x1f75, 0x0917), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Hauppauge HVR-950q */
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


