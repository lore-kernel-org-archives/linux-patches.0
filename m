Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048555;
	b=XA2WCfYASqvqNbagQlgcgZd6wOuBBdtRADd88B4b3LgMiBsoEy7OYQv4TDkQcEgPd9mK
	 EqBVFtB2kc2rs3SdWmehKKAhytNXfTNIyJysfLyYCDCoOE+Ja604seNMnBNXwGIFWEAVG
	 fUp73ynKiZ+B20ANqLy8Hlfmp+BegMKBSiTC+c7OUU9pcqFUSBZrZn7o/8slEREkKCsCd
	 DVo0MIvvuXd2JSn9iQRPYondoJ9YyPeQ/w0Y2UfxGnC4xqE1koOouUH/sjDFwi+yZLzpW
	 MWpwNWG4iZgACFMGdmaHxHgwVj2TVmwp/RhSAKYDYBiYn4zr2q18A1K/y+yam3yDPcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hzqtjie7EwP2Ee8cM7kSQ7NpML2dRUhlgoH1maFg1w8=;
	b=IGXRDiRxEHb0VBSS0MIZsjF5l6c2XyKSyjLCijgKwooKqp7K3sNJldsCL3wlQLNW/Oew
	 LgvM+gmE/g0SWrYbiPy9+VhCobrqpAtBbDEnjf27cAEtqG1W2v8E1ovaeuP0b+H47ywtb
	 oG3ZR/0+2chG5HoKmeTXNm9VIO7l3taQpC+b49/lFEx9mQxv+BkhoUA9SJFE0p2isIeLl
	 XBJW5lNm4r68A1qz+g3FoM8Xli7pIn4F3V2D+5Jp+8t+jkmwRL7k2Vi+AqteXeaS6QGbD
	 WTmZlWbshxkYUdrP2ay/LGnRAk30fJFmpxAXtjUotZ1l/zqsL80uBx9mQJohfAWPkkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2E2fLLP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B112606A320;
	Thu, 19 Nov 2026 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2E2fLLP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BEF1F000C4;
	Thu, 19 Nov 2026 00:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048555;
	bh=Hzqtjie7EwP2Ee8cM7kSQ7NpML2dRUhlgoH1maFg1w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2E2fLLP9LsLW3pYYRRd/Frm7RfQiWZuGsl1Rj8FePVj3LzUh+nw27gdRXJ3/K31z
	 2oj5ImoWyLRAh4savsRQL28C1+2Che6y2PTvhBklQoyrpSXGDHgYWlmuNGpofaCumg
	 bzDNZeR0HoGCJLXFGjQq27WZMbbKPZk0jKhB7eHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1995/2857] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118150313.203722158@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d229695f2162a41bfa614f175798fa56a5f1c969 ]

In flash_fault_show(), address of uninitialized 'fault' variable is
passed to device-specific .fault_get callbacks. This is not a problem
if such a callback directly assigns the value like rt4505_fault_get(),
but results in an undefined behavior if callback just performs bitwise
ORs like as3645a_get_fault(). So just initialize 'fault' with zero.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260904054437.461706-1-dmantipov@yandex.ru?part=1
Fixes: 7aea8389a77ab ("leds: Add LED Flash class extension to the LED subsystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20260916161607.90106-1-dmantipov@yandex.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 6fe9d700dfef6..e10a9c796c04c 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -188,7 +188,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



