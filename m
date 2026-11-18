Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052574;
	b=AUt4Ny0Pru4PCxkDia1YqD2yfSAL2bhhBgfh9XBAcSQWxDcnHxBgzF5zHsKTDu+6/NQL
	 HeQO86NyEQaCtRihcd+cjDjgJ5ohkLMZ8jEHxFb9jpl3lNoDUae5VSPKOHJkT7kzzIdfq
	 Pb7QA6H+DmqOKHY2jimShALMKnqg7FeI/QcWzpTFX03CZmqclDV6fO7Ss+aLC06L90N37
	 c/Is3j+0obDYvVlLwZMZQ5jKwLetzfWNSykVYyHVZ+I5B+RDWvfxoSlQ3V6eyx5iIh+T8
	 QzN3gIqPQQk6Dd6s6Qshum9WvggneXsg58NsV2O0L5tMZ2reice2kWliDYsej5EYZlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G3PDLSEN5ybH7hrXJpJUGJoCzz29OY1M3kun+p09OLo=;
	b=SKHMtZcttJGM9tHVFXVpidLYPGTkemaQ9g2jzx1oyb0Ct7H7IbFDYM9sWz19AG6iYM94
	 iOjKFvcLGgYoUBB+TZBX97YBWClVky7KnHiurVV2HhrQ3qz5P8+Gc5XQtuRvveojkiesz
	 kgDadYWg2DGSn5Z+3/y3JEhiYU8RR/ixkDERuzZ8GhyfKTyIEdsfotCwWy5RA5A57lcK2
	 P/Zqm0k7P8EcOoEaef/vFrbD5kNNeENggLnrNR8d7Xb9h3LFfqxDkLdSNvqKAydpGsGzj
	 aQSPozPadSFtwOfnb5l9d5fOoEriYg9j08j7VZnkf3UgcySqGjXwHdouxdL7gcoF1xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zk0QYO61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C68606A320;
	Thu, 19 Nov 2026 01:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zk0QYO61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE701F000C5;
	Thu, 19 Nov 2026 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052574;
	bh=G3PDLSEN5ybH7hrXJpJUGJoCzz29OY1M3kun+p09OLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zk0QYO61SYi4z8kMdIkc4HituzTHouGUeWpB3WNhVXiu/eg2k0H0KVvyJb9SqvkQV
	 ZflLdSgjjQ/h+90/BOBPL2gdTrbKZwIiXiEWfVvzK8q3ZALgZLwzVEfC7Hw9ft0QRy
	 aqVCSBMmNYZJKdTe1O33c3CmAF87yKzKXuofebSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0611/2214] USB: cdc-acm: add VeriFone VX820 device ID
Date: Wed, 18 Nov 2026 15:38:07 +0100
Message-ID: <20261118150035.706544687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6bb29d679bb1c..5c41de688e3d0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1767,6 +1767,9 @@ static const struct usb_device_id acm_ids[] = {
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



