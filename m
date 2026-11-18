Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045423;
	b=pbrJqO1ra4bT39QBFtxhFB7kaa6c5oAM0lhZtWm1kYMQZFq5UIfdiSffdYVzcaTNSyUL
	 aP5TJtVHras5g8uSaXWlVyoeoQTir0zObxFGcyEgJRwkd+30rOHeA+/XTWGIGSHQ92aIy
	 RCR3qFxXaHMak6x5oN9wzxcyMb4nlz3h3lAnWXUG5ag0TUYmVA9Ht3PQmdYqrasY9sZdL
	 W4S+DyFSYOnoUBaZYnG6YQXl6oW1nuUPPAphOXYxhDXgHiNFGroKy84Mug5KuNHLrBHIM
	 oGZynmCA12fDYPA3g5Bp2pM72OBrZXdm2/mBD9Ci0RcXGZ0Mktj4h4SRNiDrs9XH19w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVfWtG6ThyFDvumrQDXk8oLF9Q8QYLiC5MSKxPcATCM=;
	b=k61fZlZTmHD9S/SAnR1KAD9EF2FXCRHvywzw0l7wKRA1AZH8wcJEhrImM20zGk+9Lt28
	 lNrHhMkxRDB82xCZCxf2OTXknzfSHk3e6yGt0p5uNRVefXIWW2FubELR4KAumtbuETSkS
	 s/O8/o3Y3Z3cWvTgSQPvafVkRRCQQzA3i+ziomO20gVQfn6CjZN1743FeqpYcKdmFMxHG
	 ulCJlhY8Jxas9ivE70jesZ4rZeOTG6ZKeNpggo07C8cv5MGyQgo8SlfRvD9kNFYVt/cdU
	 9eTLSKTr2CdbBu8SBGJCdozJxFDOuQ+LC3vRMcEU9gdYbq4X+O0l2IS67WDi99K+q/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CdofbCW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0000606A31C;
	Wed, 18 Nov 2026 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CdofbCW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8411F000C4;
	Wed, 18 Nov 2026 23:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045423;
	bh=BVfWtG6ThyFDvumrQDXk8oLF9Q8QYLiC5MSKxPcATCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CdofbCWg0z2Dc5rwsBLSqhtvgA01gLclupBKaVTaHz8qpnA2PxtZPGMGg+69LXQC
	 kD1LOt+rxDtZB/crrJZg78BYMubPwvDXlaIFvO+jHr4c9utkmggAKoOK10RYNRz8VY
	 hibWR6uV6+4x4q/zAhvw0adpvHvvWfGSXBDxeswc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0918/2857] USB: cdc-acm: add VeriFone VX820 device ID
Date: Wed, 18 Nov 2026 15:32:32 +0100
Message-ID: <20261118150234.634085998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drobyshev Vladimir <enigma_137@icloud.com>

[ Upstream commit ddbddee6592ecf6cf6c24d888780f9ad45a3e30b ]

Add USB ID 11ca:0219 for the VeriFone VX820 to the cdc-acm device
table and apply the SINGLE_RX_URB quirk.

Signed-off-by: Drobyshev Vladimir <enigma_137@icloud.com>
Link: https://patch.msgid.link/20260929173833.105208-1-enigma_137@icloud.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index a699a00a503af..3184d4b959653 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1794,6 +1794,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x11ca, 0x0219), /* VeriFone Vx820 Gadget Serial */
+	.driver_info = SINGLE_RX_URB,
+	},
 	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
 	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
 	},
-- 
2.53.0



