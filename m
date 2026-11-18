Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048716;
	b=QhsqX8jR3aeM1AjmwO+mRcfoyrJ+EOVNy1+1/xCbjXjplnSlmDmykuPuTtkIIQotabXj
	 EUMA9tU0haMxZ/mY6OU/E4iRlahjZ8tHHasmujrBySnE93dJLpRJPvISspR48wn3qvz34
	 CtAytUuQoQ/N4lT/6xlZ+j/Qtm/iGXdaaEPYXUL09Yt9o4Ka/hn445ah/Bp2hRDFGN8pD
	 zl6dHDafDQJA7PfN17wdhjOG8JpPjA8qITf+T1PkrwEoi/hpIhoGnzUtw/aeLmEvQBFOG
	 nYqe5pnnLKZT1JpEzBFKLF6LJTxLsUiwwzRCgkJl+UN9IlOuuWMp9+zPyu98eBCgFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=euRb73l17iZGQUUdlJmEZX022HRvBHH9x6UM1UQQE+8=;
	b=ANN/oSY0q2aybf1iC3L0hcy62kbZhzn6Oe5DrdxQkw4CoT/KEE2OBFO5IToiJOHXmSuN
	 J+J/mxqfP86fgrD01eovp+H8PqnwEuoeLCtfo/Qnn22zyw455dzI4ZOo3hZjWpyWNTcY3
	 bmAeq9COnHWSi8Vu98Nf7Lbyd/gse22HTx7dZzBMSCa+zPBhS+aZPapq/gdNLao36X4Qw
	 NQ/a0M4Wr22OFHBowkDdeagAOLkAJoK93MvEGgjVavgywlezbQjU/S8Dmdjt3PgEziSeR
	 lPIuEW9gNEtNldMt91/wmO/D7A3M1jIiAH8YtXRlkap6Ah7dr0zVbbRIbjepXGQ6vFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBCfZsbY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A04606A320;
	Thu, 19 Nov 2026 00:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBCfZsbY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207151F000C4;
	Thu, 19 Nov 2026 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048716;
	bh=euRb73l17iZGQUUdlJmEZX022HRvBHH9x6UM1UQQE+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBCfZsbY1m7ENw0hMFVfuGtLuWUaMqXHa2VufbtaQ+Al+EHHF0J6JyyXVUuBMuKTz
	 tg3BOZNnNutW7qyOY/oDrCBUK81bYq7jGBDdtNsvU9Q27vTr1Im4qV8W/2zT+qSj/k
	 qfCTMl5rEx7ZMjmI7l7Ff5QNFDOjBkJcJisddyr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2094/2857] staging: iio: adc: ad7816: Sort headers alphabetically
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150316.803470851@linuxfoundation.org>
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
index a46ca0559b6a2..6a402e8877605 100644
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



