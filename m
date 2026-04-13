Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D39630EF80;
	Mon, 13 Apr 2026 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098290; cv=none; b=ZSM7kg42CilBkk/q32ftwpVTWpMwsmgRR1S5F91bmVp7UpdzaKsnjGrq8NVH1XzgA5ynVnIjDSb8fUkdlqYzR+E4pzqRynHXSiyXlUIv32jxewlZcpDMjdfcRjJQWRTECy1v3fWGnhq5aDenxTlnoK5rPAiIw+/UMZlNeFM7a9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098290; c=relaxed/simple;
	bh=gWKazkinvkI848GVQOXdtypg9S4AWeZFrL2RFID2s8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQAyEO7J/4y2Bw6N/EctR9Uiu/YzQVoMYtp2bJjCzxZrNtT54ETU6RXDpITOKK0UAGROPojJItN5Db6BSdVHm7dQRUR7YUsOKWUJaJfooZJb0JonI/gMgpAVOzxfqAJ85kExipMhO4H4qBZqjLLgiP6r9PNB0ZtHIg+PqytmJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHaNueAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHaNueAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7374C2BCAF;
	Mon, 13 Apr 2026 16:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098290;
	bh=gWKazkinvkI848GVQOXdtypg9S4AWeZFrL2RFID2s8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHaNueAofSuyoGhz4xyXtebYSzwKWFsjtSBvfSKhVNBZE95K+/SaeUcq4+C4Ofzbe
	 lFWFz6457D1vPbgoMn7C82P0eFpin7Tq4YittrDVAuroK3edhaC1QQFrSAWfvsdDWy
	 kFbBHosWMDMzkiVrottGJ1jSNFu+ovaptON89JnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 466/570] usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive
Date: Mon, 13 Apr 2026 17:59:57 +0200
Message-ID: <20260413155847.923517513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miao Li <limiao@kylinos.cn>

commit dd36014ec6042f424ef51b923e607772f7502ee7 upstream.

Another Silicon Motion flash drive also randomly work incorrectly
(lsusb does not list the device) on Huawei hisi platforms during
500 reboot cycles, and the DELAY_INIT quirk fixes this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260319053927.264840-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -394,6 +394,7 @@ static const struct usb_device_id usb_qu
 
 	/* Silicon Motion Flash Drive */
 	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x090c, 0x2000), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =


