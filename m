Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA386217722;
	Fri, 17 Oct 2025 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714611; cv=none; b=EcvOUtQgO2sqT+i2dkR8bwEUpCY7UBWr6PaYnPw4utjvItgWhOcSOY0D/xQuw4UdQlmp3QcQbVWjpMwscXesTrv6BCEGpE+nup4i2LqeONEt/hPrPftDQEJo8Y2ymdLSW8UInLqs48S2wSaNygM4amy9glnCyG5e7zr672PA5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714611; c=relaxed/simple;
	bh=1YvF/OkCqQzO+BiTpKaPvb3000KCsi3DJ6c2Lmf/Qbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9/pH2hdR7gGpDHeBknKcX84VGZV1ZfPqOi3HSwFe6njd93EzgVYYT5S2CBBcm56uRPvF5OgGYcnESk9dnBxQ5tK1GBkT6/ZSdeGHqEeX47yUeZiUdGWh4PZDknDrwVFU85/IGo6jTvTeYI1c8tzZl5+9cEiX+0iSrjXhk6hoMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H86zWnOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H86zWnOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C97DC4CEE7;
	Fri, 17 Oct 2025 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714611;
	bh=1YvF/OkCqQzO+BiTpKaPvb3000KCsi3DJ6c2Lmf/Qbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H86zWnOu3fsoqZg1HgBBlgReekxyU7rNjcHDtMDGGUAO0IG506jYX2/hNC9Y2s87I
	 7glI9yaPOrw0hEBWILlU6YzBlKbo+hJ/MchbppYqVLJYE0cEYm6HVbK4tBJAi8DNQe
	 QXx1ICgt5NtDuMPvLnagOM9+vPzt5sK1B/wV/NtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Autumn Dececco <autumndececco@gmail.com>,
	Nick Morrow <morrownr@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 204/277] wifi: mt76: mt7921u: Add VID/PID for Netgear A7500
Date: Fri, 17 Oct 2025 16:53:31 +0200
Message-ID: <20251017145154.572193102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


