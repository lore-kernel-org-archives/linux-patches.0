Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040422;
	b=jQQ6EkbdNgLTOe6KRBkHjPpD8o2XxmNcMQSJfTOx2qMpMpa9lwfH6dLJAQT/QlYP6g7w
	 eI8k6s8EuA98wZJkhhx1hHTEBGL/leHi+H9d6aUk/71+PHhJa8nIRBLaVX30jUtUqqfV8
	 15D7ke/F6cEgaGBxaIHdfosTKTl8/Bn/udTQCdqgh5reSt4QWhC8t5xIu0t4thotyv18f
	 e7jQyBDyoEDxhJ4x6L9DOjFn+/va+xTo1rU+JHgifb/P1z8tzP8iGnHP6pU3kfIx08Rl7
	 9DpzduL7cRdkgZRF57YrcWI+qvRKiw199KSxWTh+nRfmqlRNjY+ZRtPBQ5OcyuJnYXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nEGrUwzfE6Rrxec93zaET2Sm3HNjHDQHEqLwzzt37lg=;
	b=C6PkHm8sjr9JPbIXMUMbztdZuJbL6nOLZPo0LIN96b4ek9R/tOiK7ubHPP5sZw1E/Lw8
	 VLoz4T9imycbi3xjnw1UFhxwF+lZJ1nTAih1WJBI5IDQU1kqzfwSKO4mEULoy8iO0fR61
	 FwAIeO7HbHlIg281yLoLTaizU0Hd0T4sA0cdaeuboRVhXGFEjHRIyAlIpCB/Vd5NlmvIz
	 77JcWizxG8IuSiyo7FMc/xhXNc8QkhBMGyhivqzbeV2OkvMn73mlYXMWfr7tG/hIsqS+d
	 gE3gzOl78tkIkKJGB9h0WsczWNCkkyqTZp2JnhggziFFX4T25pCe4PRFcNp0qGfiONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgGtuL+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4846A606A31C;
	Wed, 18 Nov 2026 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgGtuL+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669BC1F000C4;
	Wed, 18 Nov 2026 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040421;
	bh=nEGrUwzfE6Rrxec93zaET2Sm3HNjHDQHEqLwzzt37lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgGtuL+kTEyNErlX/yjTazFTjUXoexRhndGUWmf0XbsuOIBCwVPNG5IZnIX2w9338
	 Aa3V2NXKMe1mw0iYI2AN5hdSRvyD0D1vClVbUqzrcLM+eirY7QqesGSrSApV3/y/55
	 7w5bSVZA+2hPCuR0IJ1i3oYtkh2mNHM1gWUd8KOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2410/3318] staging: iio: adc: ad7816: Sort headers alphabetically
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118150433.793890023@linuxfoundation.org>
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



