Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058476;
	b=Egj6Ofy8jWo4i5E23HoDwHYGf81GPipkuPniyTpOvhLYNFu9yuMeUEf25hvYoWBfaXEv
	 1WpFmob3teTjwFpzciUvkwJQmcjd9KBStSRfm/D/EN1S7WpqcbdGfihHIX0lXou4f7iF7
	 goK4xbhhotT6M+qYp8CVaGP/1BzL0tpINPb4m6c0Olic7wPyLK+x0f3gtNIM5FLHQc0eZ
	 8ElPHJY9FsNFSV6us27aMkHbUYu7mIHgd5WK6pVkgth02Q94CL1lpiCaDZ3bnOHSU3Ykn
	 XvJ9f24a62hDQcQ03IFjq2WdH7p3R+L2g5dmaj2zw8tChxv/KUACOXQFOacQkqtq3SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DY/tiF1LML8C4PsmFT0Voq5zLK3J1HjKXUOHJF4MoOc=;
	b=Ss7y0O0eG4wn1aA/T/VCGwjMH5DGnOrxm2qjOrJEmEQcqUlvDdjPzSJhswIO5/i7/cUA
	 mFPjg3njussASRCTQkfJ+z9v3XgmF039uvTgizUy8dtAEMlyo3N6AbBdSyhH0p5J2N/D6
	 zBJG0Cw1mGr8zPvpHAvqXNUzk9m9qlqon+ab8cQKRKSL/eTpTN+TFF53+ZzbGSgUBWhPu
	 UVGSCpEOGFNN9VdL3q9puwiLzDTMNa2nJYjVQLwb/mNBAQf1xXwswFR54ChRuNToP5XSq
	 RmD8IezA4A2QmSewyxubt75DBJnEaaZw92xHPjaWr/vnbs9RZlo7/82L16lksLurz2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MY6KNQxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2CD606A333;
	Thu, 19 Nov 2026 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MY6KNQxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E1B1F000C4;
	Thu, 19 Nov 2026 03:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058476;
	bh=DY/tiF1LML8C4PsmFT0Voq5zLK3J1HjKXUOHJF4MoOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MY6KNQxLOGzysAS++cw4pwFd04iPO0tlj8q5sF8DE0/FGV5ceFf7wOKr3blMer9wo
	 eN74ANMd/79Fe623OprJJX/5dE2Ec0AVCYWOxX4Tdmaw1AuGpQBe218CyyI+Rxvkdi
	 0gK1xaiXiynqwHASr0fUA63i5coQ3aPWICt/o77I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0500/1848] USB: cdc-acm: add VeriFone VX820 device ID
Date: Wed, 18 Nov 2026 15:42:18 +0100
Message-ID: <20261118145935.635956113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 056b55d121ffb..83116f1da87a2 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1783,6 +1783,9 @@ static const struct usb_device_id acm_ids[] = {
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



