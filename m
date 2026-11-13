Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591151;
	b=y6PMqLAeKkWFb5bh6d/lGq6bM+24hPG2ffiLZcooiWpApZtwUfrAwn73X2SGZVBvocJ7
	 KKhqm9oOJQL65rA0zWAnOTcC1CliTjNO26kb0fzE5GTUnziE1c88oHEMCDvLmQQk0Afef
	 XkDIpTfBpAX6vn6N7UAdNako4KvQx0bMcZNqXuaRpjBunvmYM59iKChn9vW0n9ENtwmBP
	 gumE++FreYzIeS280m6LGLrEwb4E5bzuZX1tF3EYlAwsfMkMPZaDSe+SJBBE8FyaIymYn
	 J8nRj7s+qectPlNeuFQaqU2bPz+GJkUr2Tvt2bMtOERHZ1hSnm04M0u8JMioYscbIoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WUrvwZWf37Q9Q+ODUTxhIf95XGM4WXMuocF7BtZnAp0=;
	b=ru4in9z+8lmeUFl+mga3gKyslhnBouk5Oh2Irmcncve1poPbddxtqRzaAR12XByfAdwA
	 4/bTdnMgVYq1WvftUWRNsPlq66aYiWebAD3RDvsz7cOPj9eDnKRPNHReXjENpkolg3051
	 HH50Z9V5IK3RzD5Fk4uAA8J9pzeKapunsuRpWetrqvTjwT2yk/WqSehmQOwUMKy42AXCZ
	 LNhl15CvEzK55NxEEV6Y8H2Jyr6y0CY6oaEDU81/oLa6y6rh6jK16H36kU98Aa6gttOPH
	 PB1o6qE8sLubHzM4BaRmkbYTiFCkFF1Wr2p8Hu5Vz+hbY/Tbhhr4tDo3OS2TJjzz8ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpZFKpRz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B753606C080;
	Fri, 13 Nov 2026 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpZFKpRz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB061F000C4;
	Fri, 13 Nov 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591151;
	bh=WUrvwZWf37Q9Q+ODUTxhIf95XGM4WXMuocF7BtZnAp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpZFKpRz98HxmQX/3uf4H9E7qcUIU36OXXr4G1eEB5XjQtvIVLfym4KxhgAIX5jVl
	 ovjPGv0HjKzuOpJ7vS9RQcniw+NFGwcaR5hvPkW0MTQ0wQLpl1p9dKLJpuOZGdjvuI
	 2t6KeZ9SEtmzeRXK3LH7bvdoInJYYbCt2j9djPe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Jack Doan <me@jackdoan.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/670] hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices
Date: Fri, 13 Nov 2026 10:46:57 -0500
Message-ID: <20261113153820.410732133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f0e71d3b52e4..e0052ba4702c6 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -1593,7 +1593,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
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



