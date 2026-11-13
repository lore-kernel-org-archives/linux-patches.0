Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585548;
	b=38TQf05wondFlqUfSynbxeiepN3r0edET7Oc6Jr8HNnIURAC2z5ARoEmSHcu2ed9zPXS
	 HQm7/Mtcatg5SQE8gWn/qX46lz/JbWXvL5HBPO4M7DX8TYzZ2qa0mw4y9VHw19l7JI+0W
	 MSO/hNKlaAlJa8EpaXggq/M0Nz/AU9C2q1HmjZqCb4hYFib7RWsTCB3fnUdnRBzPxGLrQ
	 VAMQBdh1Y4VNKZuMuJwoUIF+LsRcIlFQDrzloSSvsHdIIjZioShmeP7qot6WZXa4sjE+7
	 kH11hfvEfzWaQIXD0VP4ON0TGGEanomtTYKZnh62eIdgYQ4xqlhmoDCUH0jMKkzJ09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pmnvQe2j2pFQG1kuuLcZIg6+x9c9hjBxn+imuA1x4R0=;
	b=Ew5sj3NszIgI+t+6IAQeqi4beRApCgG3NWYIdN8curOQbGHN5Zq1+05xx9Dt+0+o2QHK
	 Bn/Lig+tARlpGxEwT08wdWSAxn3Vvp+4T3osIiTUg4AhgB60dCd2BOWU0IaytuRmyAK24
	 uOmscgQcO4876tuuC1cUqoWa3u6QqT3yOtO2RJDmQI22SVTGEHEec1lCjfYfMGvpvaZfF
	 aSWaGOTcvKXZ6uaCgyxNVAX7RE/h4xptJwrc/+qU5AxLf2tDk4wr34Zh/I9FP6AgvKgpi
	 GdsMHUSB6/M5bLBoje1zueD+0obgO/U09ux57N6HdJlcgffGKVUWpdDa5VX7Or/BM/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ajZs+Y/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0800606BA83;
	Fri, 13 Nov 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajZs+Y/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077EB1F000C4;
	Fri, 13 Nov 2026 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585548;
	bh=pmnvQe2j2pFQG1kuuLcZIg6+x9c9hjBxn+imuA1x4R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajZs+Y/Kch8zyGJh9nmtidkwxwdKR09QeTpqqQ/yUyhbM1UnsZqeTuvyo2Dtx5y+l
	 yv2NQFdKcU7qelYJTtANiUF/78ymm6UIB7gaq74k1v8LrElLRj6arc5s1K6iWU3405
	 /wF7h1SpW/do2ecYsIfHDXJkzDIbyfLqPJgHyr2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Jack Doan <me@jackdoan.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 184/507] hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices
Date: Fri, 13 Nov 2026 10:48:08 -0500
Message-ID: <20261113153800.718013993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 341cce4347e24..6565731b0e71f 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -1570,7 +1570,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
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



