Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DA03164BB;
	Mon, 13 Apr 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098797; cv=none; b=raIOurpjQiv9vdf/wNz1nwOfEp4v80ogbpkVanZWimrITNJreLZ2ENxHnvGCtt4/l/jRj5HWFYzP6dyNepYZ/yh6kYMUoeWP7URZs20JTz8rdL5s3ejzf+8jXDFuReyQEOkTsn94s9YvKnYKXBDtCKexzryt1AZiaqZ6VDpJfgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098797; c=relaxed/simple;
	bh=134NBZwNN2Vwht9fEs7XVfQo+Kuggxma3V8d6L2x0fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rayFoeZ1e6F+8CRJyEI4m+2+Jre8DstLSbceuHOD+j/FKrmei9v80yLbKpIyRwM/CeP4KGu3XlYAjlh2T8L1YUmbxD0mb8vNFctZEKcmebHfS4l2UqtOzWqxPZeobDQFW6dLhVXTmvKYyw8LZrKAA9SEr6TrHhzUln/DXZN/bcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THpSEps1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THpSEps1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BA0C2BCAF;
	Mon, 13 Apr 2026 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098797;
	bh=134NBZwNN2Vwht9fEs7XVfQo+Kuggxma3V8d6L2x0fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THpSEps15vf/TN1yAMY7hYBetadwAHDjCrMfMrgEzsuPad/PZTGJUptf6svI5LjxG
	 6eNjB4vLLACmxhvkfHZ8SWaKLeTQq9QWz60/NCuSWb/dxlksw7rS6rUc0j3yWHnrXg
	 aq7/7oo9UOFLZfNX1jRmmHFyx7z8idWykPj0F0Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 5.10 092/491] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Mon, 13 Apr 2026 17:55:37 +0200
Message-ID: <20260413155822.489960034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0326ff28d56b4fa202de36ffc8462a354f383a64 upstream.

Similar to other Huawei LTE modules using this quirk, this version with
another vid/pid suffers from spurious wakeups.

Setting the quirk fixes the issue for this device as well.

Cc: stable <stable@kernel.org>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260306172817.2098898-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -205,6 +205,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


