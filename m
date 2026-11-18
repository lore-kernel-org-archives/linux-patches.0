Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017633;
	b=L6DTE+RHuUqeVPVzv3jbhFPAK1+Qb5Pz3ZU18ZNdUht2vBJhkwQ7TgL7IrseSs/TFcqM
	 8RzMYv1b8KrfO2xZDDwJi9tBrvCSmYIs0GA4fMs4/Arrnwy5Jmw2wBcL9hozO8lOQdmXT
	 dJ2S85NmVklGzksQr41dTuz+CmYQ8edaxqC7aozkH/aSjnEstaSE/YEfqtoPxuTTPTlbi
	 dNNBsN3FFvRrnSZGl1vhkKVgOlkZnt22WmoGUQPtZb+Ll3Oz1dGwa+N9QdQ8GTg1hCoOW
	 nqK2c3vcJGra+hybDE5rgYjvPcuEpRkrLU9DWvMF79UdZGx7DzdzhcRG2Tib+nKUmwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NI4IP/+X/8QhZp4p+VTkLEcQJK2aoTBqYu2NWxtrrME=;
	b=hgWDn40frmlEcN3xKo3CDi/f7zyi+D0cBgwXQxoPC1h00vzPFV2VkFt108aRzStxMMvV
	 gdOJqCOcRZpBoySPDeTRUKg1QZRiz0XCD+c5rrAjAFSLUt98cz+RS4500WI1MqjJJvOoH
	 WhBQh6xX3doOvXN+28smQyEOWjig9sqULRAzFfkZ3FsGEV9pYb+28SS41FUvZZb7/uQ8H
	 V+mQOro1iGFzG6JIEPIIPnbDp8RYNHY3SB4msuUoSie5of8liVMLM+fqhF+mme1yiaF88
	 o3hw3SDb4E2YVaIS5yAMVXKz5NOMeCsRsu4ncEA6Xot7dhYD4lpeBvZ7kzA705HuC6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlZbCrEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F03B606A32A;
	Wed, 18 Nov 2026 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlZbCrEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76F81F0089E;
	Wed, 18 Nov 2026 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017633;
	bh=NI4IP/+X/8QhZp4p+VTkLEcQJK2aoTBqYu2NWxtrrME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlZbCrEEksFt3sapRw9yM5TN69QPnY++AfxgGBJ/E+qzBTF/aoAIflgkAtm+f7TdW
	 BtqKQVh6mMK1nS19TqfJcubjFipl+VPsv/kRl1FK1b3VaB4/I8yowo2rkln02jEWpD
	 nScDDSPwEKbtEtMByoc/8oj9sQi7ez6myDyrXfqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0952/2651] staging: iio: adc: ad7816: Sort headers alphabetically
Date: Wed, 18 Nov 2026 15:36:32 +0100
Message-ID: <20261118150322.177481847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0633617642e64..18261224f9c2f 100644
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



