Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034493;
	b=IK1yx646ty8U+YTRBWlu8DdGGdhmO91Mqwl29b+5I+hsU6H/HEmLOWErCuV38QgNWRaK
	 ezIcEXn32CQAHU6XlCCADOEHzuBomUT3RDihaHq2uaLWXT4QRRle7on5vb83j5oOps2fS
	 DZbPRSV0i8za/pnyR1AHLxgmHzs9uPQUHclY2Wobt666aV0+rQJYwyuEagEPghA40rpWp
	 xjFqOsIO2nJNsxst1A5niNfPADMHTLKECQj6ko8g6CwZk37XqMN8u8wCxqSb58bCsbk2E
	 QlgtpbAK73Iwdr/vF75uTFp9kDu7gtu10p2oP8aR09udNQw9eSHRA9QPgRgSpOmqtwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AanSLcfqNnVZMNsIr8yb5ciiOuCAKcApOMjoGkLJNiI=;
	b=xFg5WgSjoe0x/df+ctZA/Q2dMeSNRSRxAnNY7hBkN2w+ylawmf0MmktKIHzj2Q6VcJVX
	 2dmutb3lvkV43zq1WDDaKJ6X3u45TiRUaeHAp2Am2RtqJBuUdjXuXdodqecVH7uvMrqpL
	 bpvN5cFXN4ciDA+FIkZVuVZsxzcoCE+YYfACwgaZEu9IgJgShE1Rh6O+qdJb/eYdfMo74
	 r3gN0Cm0GhVfMlhVl96+MMfMrxVTciq/MytiP9I9EiKPTmEMv5EaofY1VrPHEjXQjkVOk
	 3sr5c4M1v9uKB5QsGz+gwCg9+VX4E8ZqBg758vjI+pmMRWx+YOhcl1x9rmRY+6RUtuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSe1QXUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FB606A31C;
	Wed, 18 Nov 2026 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSe1QXUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71961F000C4;
	Wed, 18 Nov 2026 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034493;
	bh=AanSLcfqNnVZMNsIr8yb5ciiOuCAKcApOMjoGkLJNiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSe1QXUhPhoCG41/M3S//xinu8AxcPkhr7IKn36MSaZpzETpqRSGXaSknL8XWJSzT
	 qzjWDkwAdu2UF61GwOpaJNtlwLjf130lNHlV657h5IUgrIF1OTlVcvCblDLi4bwoXG
	 oDBhq9nxydcvB+JT0mlL2xwPIFAbr/PYciust/NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0390/3318] HID: nintendo: register input device after capabilities are set
Date: Wed, 18 Nov 2026 15:16:52 +0100
Message-ID: <20261118150328.031660524@linuxfoundation.org>
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
[ sashal: Moved the input_register_device(ctlr->input) call to the end of the older monolithic joycon_input_create(), since the refactored helper functions the upstream patch touches don't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 7e272e79e00fb..18a426c2c5b85 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1796,10 +1796,6 @@ static int joycon_input_create(struct joycon_ctlr *ctlr)
 	ctlr->rumble_msecs = jiffies_to_msecs(jiffies);
 #endif
 
-	ret = input_register_device(ctlr->input);
-	if (ret)
-		return ret;
-
 	/* configure the imu input device */
 	ctlr->imu_input = devm_input_allocate_device(&hdev->dev);
 	if (!ctlr->imu_input)
@@ -1850,6 +1846,10 @@ static int joycon_input_create(struct joycon_ctlr *ctlr)
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



