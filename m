Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB596336EC2;
	Fri, 17 Oct 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713851; cv=none; b=hV8/2oaqEtyAFFeBUMkUnwpkRlyE/zpw0p9dCw5q1o8s4yDx0r3oMp+4rTRGdj+pM9T/vSCLyDHwt0Cw3ar5ebD/YKCo3JVuLr8zomMNCbby/yqT+IdCKa/SDRmG5DlYvOv43u5jqix9V67/yT07rXxu71eHMc7T30LBtMjFlnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713851; c=relaxed/simple;
	bh=znz6ppy9Idt5WffpUI+QzPw4/qWysPZzzbcfsve3UMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b79QbZH6wjHvIEKDy6pp0/LqN8AbafT/rnucMFmNNlafEuJ04vlxxUdboY5NPJbz1jYJBzmqasxFpqW3xrDEx/2QUQ0pLbcyYUwBwsHFLNmnVkQtPYPQvtAdBtXv1F0cXg2e2bdULRLHMbBrAtNx/TCEELl2Jxc0OgB71QzFpuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHUgOPHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHUgOPHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F93C4CEE7;
	Fri, 17 Oct 2025 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713851;
	bh=znz6ppy9Idt5WffpUI+QzPw4/qWysPZzzbcfsve3UMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHUgOPHGJ3d+q++0LbeKx15zAxuPf7crUMc19PkGSmLmP0lRSpsC4N91qtRpR61+X
	 /SHk3+P597PVj4U05RydRQieeOOvnhdysjmX1EbG0jbzT32SbLDxblIE9UY7hFAvn4
	 EPCjAtefWbhT1U7CWEi7q8Hqx+emBUTKfjXlkttI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Autumn Dececco <autumndececco@gmail.com>,
	Nick Morrow <morrownr@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 142/201] wifi: mt76: mt7921u: Add VID/PID for Netgear A7500
Date: Fri, 17 Oct 2025 16:53:23 +0200
Message-ID: <20251017145139.950663633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Morrow <morrownr@gmail.com>

commit fc6627ca8a5f811b601aea74e934cf8a048c88ac upstream.

Add VID/PID 0846/9065 for Netgear A7500.

Reported-by: Autumn Dececco <autumndececco@gmail.com>
Tested-by: Autumn Dececco <autumndececco@gmail.com>
Signed-off-by: Nick Morrow <morrownr@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/80bacfd6-6073-4ce5-be32-ae9580832337@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -21,6 +21,9 @@ static const struct usb_device_id mt7921
 	/* Netgear, Inc. [A8000,AXE3000] */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	/* Netgear, Inc. A7500 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9065, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	/* TP-Link TXE50UH */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x35bc, 0x0107, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },


