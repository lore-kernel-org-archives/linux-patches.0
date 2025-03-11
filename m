Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145C2571D8;
	Tue, 11 Mar 2025 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706310; cv=none; b=l6TPB2xenMpXnU1frP5bFXd7s7461lNOsjXL3qqWGXQJZ08FLDW59Uw9bhbnj0ltE2NahECuYQOIfstwycJmon45RGN4Oetqq5uowhSIg9v/zou9pDvgX+q7AnwijMvht62mEi9dQPnWQcJbzv7s71oP8FZPtq0aFPIPOALXLUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706310; c=relaxed/simple;
	bh=qhX14VwZdkxXGCH1SbzxMoqM26nvp3g4CxhrbGPJuCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACeGHXE6jfY7c3WBP8d1axy8pvN5QLCKW5i6X+F2ZclKVE3ggDCbCvzMhRUI2lc1Wb2/Ol2/Yfb/ACLEfv8zYs45tsw5fMPT1VpEbBIZuTzGz+DByqSBPCHWRc1WmNTMmALrGIEHCuT0YKVXOF0mDn0Gxl+3U36aYqxpjh7abSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdW9WUyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdW9WUyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7887EC4CEF1;
	Tue, 11 Mar 2025 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706309;
	bh=qhX14VwZdkxXGCH1SbzxMoqM26nvp3g4CxhrbGPJuCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdW9WUyCzWROdIVvgCUoyuDAGKm1k4GRda4acT5Tv9B4cyJLU4qJon493kd/goC+9
	 Cs7CKETqw79gT81yjwVPiro9gHOrKTVTRPMOVG9uU8Kfil8H0gABAXnEWIFZg+qQ8x
	 NcVV34JwYu8KI6roJdwfQunWBj6sZlCLo07duICI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 314/328] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Tue, 11 Mar 2025 16:01:24 +0100
Message-ID: <20250311145727.385408227@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


