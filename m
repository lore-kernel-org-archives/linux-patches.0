Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024679;
	b=a8/R1Yc4NDJko3nclw/+27dcLkjJ9uDcL7EDjhYKmixXM2Ex4uVXJBgJmZrAh/oMJ0Ol
	 ZSU9HYYWj4U2OK+s/bK3UUAGemswKcRTJbTHXk/3nPxmUbGdnufzZo/v5IOJUDxWlyxOg
	 KDjrbs+kfZ1/j5K32v+06SeOM9NgFhJJfw9IDdhrPjQenrqnaRs946NBLdVcVKbLL4pou
	 GaXV17vEBBu/szh6kCQmm/bcrgmsF4pYNOGuYMMaQsgvAFKTJsuEgkvodj3fal2UlaLXg
	 FDWGgIDjIVbHhHOh4g78hGu0OE85+TP7sR5FK6WbX4efsvljFs5aBlzD5dv6DSWY/9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QQFH5kVdrPec79A4sqFOO9GrdGh+CCjhhN3AcXqPAg=;
	b=E5JTqXv4H/CiKomd4T9G2VrjqHh2O+oe8lG4g0yE0pDIDlrvGcZPF6EfAEVN21dQbrEe
	 afW0WwI4YgM2m5iy/LvyQ5+X9k1H75bouVis6pUbYgYae/bFvCL8VJX3XFm/70qmigNov
	 eKTHbRbZYyKTPP9Zii9/iRckPHCRTyhbekVqtGCkJXVJ0m96kkBsuu98m0z7VFLksxlTR
	 NzvfQXpVotQUks9NowdLgZntWXNESWcfTMnS2nbIwH7VKKlPDlOn3uIlfQ/298TXub7AD
	 wqM0/b8wnUdDUasBeP/OcSb3ND4LivoIl70ipAV/Dn5feq3y3IdbDwXDW7yZPJzTpkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGNUn1Vw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C813606A31C;
	Wed, 18 Nov 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGNUn1Vw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B151F000C6;
	Wed, 18 Nov 2026 17:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024679;
	bh=5QQFH5kVdrPec79A4sqFOO9GrdGh+CCjhhN3AcXqPAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGNUn1VwyVnqLwVULGEdD4b3UwFrxM6skz0d65pVqgmCuYGYtShATfuLWqFf9pta8
	 UuYIrH9iJrbMnHHqfv9oFu18feJGBshpz0cVNz7sqnzDqMiNI/pGAM75M8vhVbUl4M
	 qr6D5/CfmPmcJ3bX3j1C+/yWO7p+bqNwx511xOlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0810/2151] staging: iio: adc: ad7816: Sort headers alphabetically
Date: Wed, 18 Nov 2026 15:42:25 +0100
Message-ID: <20261118150151.550956928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 8c7b99ff159d64679c9b3b4d5878e44459f7272a ]

Sort the include directives alphabetically to improve readability and
maintainability. This is a precursor cleanup patch to prepare for the
addition of new headers in subsequent changes.

Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: b96187644664 ("staging: iio: adc: ad7816: Protect sysfs attributes with mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 070621cb4fde5..c7f507916726f 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -5,19 +5,19 @@
  * Copyright 2010 Analog Devices Inc.
  */
 
-#include <linux/interrupt.h>
-#include <linux/gpio/consumer.h>
 #include <linux/device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/sysfs.h>
 #include <linux/list.h>
-#include <linux/spi/spi.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/sysfs.h>
 
+#include <linux/iio/events.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
-#include <linux/iio/events.h>
 
 /*
  * AD7816 config masks
-- 
2.53.0



