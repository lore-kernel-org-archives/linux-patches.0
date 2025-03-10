Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB8117A2E8;
	Mon, 10 Mar 2025 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629641; cv=none; b=UCFfcKg/SHq+mRZExPyWVdj53w8E9x8ftATrIDH2qDiFiQLOobjAOYI1VjYtkhfvrrUKOZIy5V7rRHc3rm0vaLgMyivWeqmZSAU+HJ4eqpy6f3BQWDJLg45f08XWnRrlQb/NZESXBupr1Zn9y1YjUR1QaoeerQuJx6JfMrijpX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629641; c=relaxed/simple;
	bh=D+OR/tIfVZg8HVEnuwS0FEr9SGFSrB3HI2fph3dcOLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwJ9OeNIWPGNUV+AQcc7yeWYrtvow2DOBV3Yzj0H2FBy8gPmA6TwmehbO1xXEfx1Lo0KJjehDo3tsrhwcp+Rf/+Iipw7lIUX5yDP2LO5toi8Gh/uLn1mn53BYQ9vOo4m6+nTWaMWiu9DbkAidq1hlIIEkPRew9qi4+G3xF3qM0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq0FLoBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq0FLoBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648B4C4CEE5;
	Mon, 10 Mar 2025 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629640;
	bh=D+OR/tIfVZg8HVEnuwS0FEr9SGFSrB3HI2fph3dcOLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq0FLoBxTroVIzUsdGHHhUkR4uhCLTsFOMEk1rWPrcGnjRkKhao1fveGSIabCbxpD
	 iS+bTIrXqCsSoOiWEhFIJ5Gm7GfgYZt5uA6ClLgRsbVRqtIQf3DrYrtbDrMCZHCVPM
	 pJlYKfixgIqhRT2F7BV8MCtcYaYATbqpDh3/l7a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 365/620] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Mon, 10 Mar 2025 18:03:31 +0100
Message-ID: <20250310170600.013516703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,9 @@ static const struct usb_device_id usb_qu
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Teclast disk */
+	{ USB_DEVICE(0x1f75, 0x0917), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Hauppauge HVR-950q */
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


