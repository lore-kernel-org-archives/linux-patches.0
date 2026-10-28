Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216294;
	b=Y1QASvprC3Ijjaj4nPRe7MHzCLbORJBgqvOnw1sjqR34YmcQS+4JJ2y/ExzFDc1TehE7
	 mkTOFMnWxsBGaFuDLY5oeeWdNvU5JU9DN2y/0RXW7gQ66WlTS1nvTXkyj8jPTWXECM5Ep
	 J2b9bqWU1fIwFTtt56MsK7+3sh8vtD4ObydB4pKHBh04R9DE1PaYSwx2K2Ost7lrddLIb
	 wfKMGr2wJ7oYU/YgREYcuy+ZNIqgML3freZ+PSGd/1Gy3jtvJ7RgKuRyxB1/I0vVU6uwy
	 Lj4Fzmct/X89QflOmWF5dq5SXLi52E3iowocZreGtQau1e4pGOHR65OZwOQ8XIV7qlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIH5bxeYZ8+JGkQobI4+++58Id1xLqyurBIj2IVkN+A=;
	b=WCiuO2ww7+SiSKHzabjqB0lyIyTh2h7QJldFWYZ4FA9yxEl3svM9t37BQpDu4Y1mIsLl
	 OJk7pMv1LrY1vrH5dDlTusTwj1dPA5FKQTRxUeqVgUzx38hGKFpKIzghJBMk2/xYbh73O
	 PiDTU6S7IiUS1vQIk6m4ZUY2+XHm9yecl8k5TEhfgjtm0gWcZ0YLL1kNHdnjZO8BEGl7C
	 vXXAovmnhwfNKrL0YKdFXHBEafjtOVULuMU/znDJwN9O370Ub9M0v5j/LssN6usPHki0y
	 +9oO/DKKDs7FihgrCmHcbrCBW8nZe4C0laD9BKvkGXj6LDPZUwEMFHqjacPr2YDYTog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4IFYCTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E7B60A2601;
	Wed, 28 Oct 2026 19:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4IFYCTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C2A1F01829;
	Wed, 28 Oct 2026 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216293;
	bh=uIH5bxeYZ8+JGkQobI4+++58Id1xLqyurBIj2IVkN+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4IFYCTz55im46PsNZx+t+L8Q6+2K72MkwrAYx6Mf0331Y0b0cSSJfyQdvXYDrHe3
	 X0UGudsQ9y2UB/QHKiBGNe0TSYMFEyfmM9kIyKtH5MOh+I0umf4BMWZud5+HjcMzsm
	 YIYTKcFn3HtnKZdglQc1XnSnVBYrQzm+et4sTmN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1464/1887] HID: nintendo: register input device after capabilities are set
Date: Wed, 28 Oct 2026 17:59:20 +0100
Message-ID: <20261028170532.771154054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit d723bc1fe2e72b9252234e94c11af644ec477bf7 ]

input_register_device() exposes the device to userspace immediately.
In joycon_input_create() it was called before joycon_config_rumble()
configures the FF_RUMBLE capability and the memless force-feedback
device, so a concurrent EVIOCSFF could dereference a NULL dev->ff.

Registering early also means the initial udev event lacks button and
axis information, which can make input managers ignore the device.

Move input_register_device() to the end of joycon_input_create(), after
all capabilities, the IMU input device and the force-feedback callbacks
have been configured.

Fixes: 2af16c1f846b ("HID: nintendo: add nintendo switch controller driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260730031927.25444-1-yijiangshan@kylinos.cn?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://sashiko.dev/#/patchset/20260730031927.25444-1-yijiangshan@kylinos.cn?part=1
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 7a1bb4c876659..6a57681fe123e 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1719,10 +1719,6 @@ static int joycon_input_create(struct joycon_ctlr *ctlr)
 	ctlr->rumble_msecs = jiffies_to_msecs(jiffies);
 #endif
 
-	ret = input_register_device(ctlr->input);
-	if (ret)
-		return ret;
-
 	/* configure the imu input device */
 	ctlr->imu_input = devm_input_allocate_device(&hdev->dev);
 	if (!ctlr->imu_input)
@@ -1773,6 +1769,10 @@ static int joycon_input_create(struct joycon_ctlr *ctlr)
 	if (ret)
 		return ret;
 
+	ret = input_register_device(ctlr->input);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.53.0



