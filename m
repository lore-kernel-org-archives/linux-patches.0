Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036461;
	b=Jtnq7lt4CA0cDwpbXHcFUDzpfcDSjQALzqGB7kxlpJ2otb3AKRkBk1JR24VOD55noHPD
	 dp9eRtL9kvgcglfsknJhk7FXgXEi0Dkh0iIuukRExSmWTKNqswZu2rxVTvtu7+v/s4E75
	 MEj7YffN8+SGVItEgBkARpGUUFss611p22Tm7lIuSJRte5dPDrHHfVCiGBOTqZ0AfhBEA
	 yPhQyRrh2J7HqIbq+XA/CodLCF93161Ipn/nDQQ667Wycia5mznlhumt6LRVHEoI8R+SH
	 euEQRs9PmL4x9CijMW002XBboo/T9yxkINsBRj5G6CYX3yhHYv0e5j8Vp6F4L4y0xIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UrucaL7bStPHaiwU8+MjMJDWuYjH2gX3ZRVdubzGlTs=;
	b=k4x12YOj4GVzhp2/yOeJebSTiXi8aFX6aO8Y7/Ke1sPGFK4ObtAOaj83vT2bbJa36zPZ
	 QJtP7eyzpSgV2osVp2d/d6JyOlvaQJIt6DWqhNXZbabyk5uZQWWeUMUTGgGyyhTxk3b3g
	 1+vdVpvuRotYdVEi1iN2oxO2O9DwQZrC0aaIMqFZV315pg7CG13/RrJMr/jUXdj7FzpPU
	 Dffyu0guuh8B0KRZ7uSkx+90+kjZP/dO0FaYGlnAYkv1fM3UHEC2d75QfrqzFp8cpesmG
	 iKZVX5yS0nFxbDGsKIIKEKedCCSBcnpeJFc/NXJG2bN+IYy+KaKsfRHI6fkdvwvy0jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBaRi62C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598D360A2603;
	Wed, 18 Nov 2026 21:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBaRi62C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89741F000C4;
	Wed, 18 Nov 2026 21:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036461;
	bh=UrucaL7bStPHaiwU8+MjMJDWuYjH2gX3ZRVdubzGlTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBaRi62CowY5ruXgfRez/KRvWPAt/KmxLrBkF1lQwNab+FBqOty0s7V625Mhm+pH1
	 e1jEvz9SVA26trezA/lQgeemSPsTgcunXd0h6FW3/e2i6cyto6TCyd0igTrM360AnS
	 kRk/r+b5ep7Wba2DPIhvVUmPIinZc7IXCdnyxz7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1061/3318] USB: cdc-acm: add VeriFone VX820 device ID
Date: Wed, 18 Nov 2026 15:28:03 +0100
Message-ID: <20261118150351.785757941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 917114d0d5b1c..8ce77a646734e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1819,6 +1819,9 @@ static const struct usb_device_id acm_ids[] = {
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



