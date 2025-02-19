Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ED61C760D;
	Wed, 19 Feb 2025 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955679; cv=none; b=r65c4O2jGF7CqNE7jFP5haI7mYhhPBfKBYLyVd6Fxb6GkI0HiPklU+tFnVkYriONmjaIe446SGw+7EAgvNS0OQ+OZjc7X3Wb2C1Giz/cnPrd0hXVxv6LG3IL5kh1rurAM8xdmh0s6M3Bpte89mwgBzNlLbO7Y7IRsNkoeSL/QQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955679; c=relaxed/simple;
	bh=WjRtVvQJdPNjJpbj5ffkimr9NLiGiS/jpdZ4pay4dko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZy/uDERwoByCnrLgZo1YF7RHewLOW4ax18sQM32m26oV7uMIrSRrcydb2kiv3xOlUTcVQH6keRDswVJ3UOxXGMM1umK+eQAlEssXJ060B43TaLphSYONTqzL86XLCcvyhJbCaP8kaBF8P6xamoLXB9a+u+lG+AAyi6eH47d5hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tv2pMjFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tv2pMjFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F9C4CEE6;
	Wed, 19 Feb 2025 09:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955679;
	bh=WjRtVvQJdPNjJpbj5ffkimr9NLiGiS/jpdZ4pay4dko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tv2pMjFWmiKmHcDq/0ZSVPnHG4ezWRtiegAAQ7A6bp1iArdaUiWrmf1e4CbqbkHwN
	 UIpZpef4WIWY0GMwwncUXhmzlo7+uVwHJNMg8i4APKDEsCHKx9qeAOAjW4NJZmFhxa
	 H0gITYJYmKZaKLJBCHyhwvGeQG0pXhOYlYMlGpPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 063/152] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Wed, 19 Feb 2025 09:27:56 +0100
Message-ID: <20250219082552.538094884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


