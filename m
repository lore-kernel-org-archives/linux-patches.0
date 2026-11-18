Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037608;
	b=DzZjfFEHtYtQMwQWFbymXmE0hdAqDEHcTd2ohK+JPYRSM4m5Mo+8q/y4tPI8vyA8YTEw
	 zsG7fGjcrND0quajZeIMzvEjsjtwBlSozPobZpWlZXVYDn4HXL644zg/V7sr+iqu45RSz
	 65j83oZ2wbYoV9OfGV+DmURuOtqs8k1FOYs7/KemxNMfZF1lcWb7YueBh2xfYuSy5qd2w
	 CsRwFnmIy9gF/Z8fTdwvf1nSA8nIyaD6QiFZPbiPigpg2vurai44aLJd1guy90XJFQmTw
	 qs133OIiS7gU+k8KQc91w22mmpVhUpAUj5t/g3sQPQCE2CB+LwLRTHKo5OrAa8YyLYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7my5SIJZPiPkGkP9Z0vIKIfQ8sFo7AViNxh+gVDhRc=;
	b=1mSXTSXzHn+667cM2DfVvfHfCO0pvEV2DxRV1Iwl3u0upwdXP9hFLnfGXw4v/xn6L4nJ
	 kNhuQPerY14Vkr9o4WmXPH7R9KTWcvb/jb0UeD/6UmjuX+mXS72BZGD35OkI9rfYRYuAI
	 IDwmHLw3miajeoy1G/7nNvVOWMtMLvU5FtxmGpvmnIuFFQ22p1piPl86EeYvWA9g4q4UL
	 SqcTVLbz1h77/p/vOuSAAAIRN1+w1KAeGmGaov29FMHopsZ+bbYTc5GCV2gFLnK2JSC+z
	 V6mc6saIpO2QbQ/J6i3L1EL8oUwOF1Wutd5YmqmKHKfR8QVxvkNOcfKoWDTx3QNIRkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6yeS5Rs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD4606A31C;
	Wed, 18 Nov 2026 21:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6yeS5Rs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22B41F000C4;
	Wed, 18 Nov 2026 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037608;
	bh=v7my5SIJZPiPkGkP9Z0vIKIfQ8sFo7AViNxh+gVDhRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6yeS5Rsrot4/d0bJDsl2q+Lf1RdG/ULe7VgLrQWGkI7Vj8xBsiXBSOgkImc0ILzB
	 7VRa0BGvUiIYetslB0t1V8CzX8JbnP+GtmmjzAnf+Byu+VAekQVap1kZYnrWRDBzF0
	 HHGLkaBUKAm/3XZoFj5RKOFGAGhfFFQZ8KDpHJeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Jack Doan <me@jackdoan.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1456/3318] hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118150404.573945311@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b7743c6dbe3ab94045164ef298f65cfb9b0b450a ]

When a USB HID device matching USB_PRODUCT_ID_AQUAERO presents a
malformed report descriptor, an out-of-bounds array access occurs in
aqc_probe() due to an unchecked index into the parsed collections array.
During device initialization, the driver distinguishes between the
multiple logical interfaces exposed by the Aquaero device by evaluating
the type of the second element in the collection array. The driver
unconditionally accesses hdev->collection[1] without verifying that
hdev->maxcollection is greater than 1. Because the collection array is
dynamically allocated by the HID core based on the number of collections
found in the report descriptor, a crafted device exposing fewer than two
collections causes an immediate heap out-of-bounds read or NULL pointer
dereference. This leads to a kernel panic during the device probe phase.

Add the missing check to fix the problem.

Fixes: 2c55211104b4 ("hwmon: (aquacomputer_d5next) Support sensors for Aquacomputer Aquaero")
Cc: stable@vger.kernel.org
Cc: Aleksa Savic <savicaleksa83@gmail.com>
Cc: Jack Doan <me@jackdoan.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 023807859be72..e9207cd6063ee 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -1533,7 +1533,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		 * they present. The two other devices have the type of the second element in
 		 * their respective collections set to 1, while the real device has it set to 0.
 		 */
-		if (hdev->collection[1].type != 0) {
+		if (hdev->maxcollection < 2 || hdev->collection[1].type != 0) {
 			ret = -ENODEV;
 			goto fail_and_close;
 		}
-- 
2.53.0



