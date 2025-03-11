Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469EC25E820;
	Tue, 11 Mar 2025 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707129; cv=none; b=JNFceDwzqQpdpGRYvM/iQtffUx9QZxpGrgnsxXzdWgApLqzUK/Lc2B34qAfwnCS3WyDp4/47/LJu96iRV1DVBs+x7U60hlQqNnnCiwP8RLs8uBqFVtu2yjO4vtwztE3pv27wT8cncen1rGtsZUVc8RHtlKnBRcuOkeSXfJroPQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707129; c=relaxed/simple;
	bh=fbqeguP59yw7kKmSCQSXJU2CmwfAMltU4a+bWs/HQmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHZxklk0a4uhAnQayjsvFirUcpME3vYCnOv6/5XcSgOzEiqGTk+Zn6+nCuCg5atZB7fjGbqvKCgVycxRrG0dDBtFjU7EOsZ6gVEe0xFfI1xKKnpt7qwERMZXRQIYR4D2h6YEHQMLFp3rtzhyYgywkovtSff2eKr1/aHLRPEQ8V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaZiJm+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaZiJm+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA46C4CEE9;
	Tue, 11 Mar 2025 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707128;
	bh=fbqeguP59yw7kKmSCQSXJU2CmwfAMltU4a+bWs/HQmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaZiJm+r4am5yArxaZMFzcO0tp1HhqM2Mx0AeTT0AsRKO4TRr6804MRdrrM+8nX2e
	 NEfZwccV3betP1yqYc90abdSX1kZyl426XmkzAYSWBxcYvM/kYiJJ2TVvplgZ0hAVb
	 EcZoRlmgjL8tqLfxcSyYw/C17q12WYywmo8IGUlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 252/462] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Tue, 11 Mar 2025 15:58:38 +0100
Message-ID: <20250311145808.317221243@linuxfoundation.org>
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
@@ -520,6 +520,9 @@ static const struct usb_device_id usb_qu
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Teclast disk */
+	{ USB_DEVICE(0x1f75, 0x0917), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Hauppauge HVR-950q */
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


