Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A41D528;
	Sun,  7 Sep 2025 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276708; cv=none; b=tZPx2ks+8uZMWBFuoXjyPKWfgLSQxEtmK/wFP82+tWrI5lbFmfawgccDZd8qxxu9SV1sNHT73W1e1regPpH3bokGlFHx68MsaOcZKTG9Wsx19C1xNrdHddfQgLIEMXCI7yNwXy0ufHgb0sMrbSvg9n//dRzOnFt07D30styo3lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276708; c=relaxed/simple;
	bh=igrXCwscfSPLSIGGOao5u1c2yF7I2ItQ82+1QBK1Qls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SG94WWbIIIUAQcRmOp5jIdroiTDYcdaWrz5HdOa3+b0MpwIh9h6Pt9CwPhpIjJkxGk23NVn1KR+iEZBPV7eyAeAvMPSMj+HCslX62I4qdk+M5ioQIaS6V8/XwWh5HHaVIRm1OZbGyVrqx1BE279p4chd14zozZ180xH+fZa0pDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04wVTlM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04wVTlM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30A2C4CEF0;
	Sun,  7 Sep 2025 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276708;
	bh=igrXCwscfSPLSIGGOao5u1c2yF7I2ItQ82+1QBK1Qls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04wVTlM5ADXIWa6nfslKKzbUwt7Xk1/4IWv/q5p7A8V7bEAucHBy1V1/7teWbRb6g
	 vTxWqduj9ANoX7mpZFx1NXC96F/JRWf/MW+94ITkPJcPGatMNSualL7MDSDmYcASie
	 xaiWxGPtvxzy20iwMOzchw30/Llc7EHCS47EeGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/121] iio: chemical: pms7003: use aligned_s64 for timestamp
Date: Sun,  7 Sep 2025 21:58:40 +0200
Message-ID: <20250907195611.993491155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 6ffa698674053e82e811520642db2650d00d2c01 ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure that the timestamp is correctly aligned on
all architectures.

Also move the unaligned.h header while touching this since it was the
only one not in alphabetical order.

Fixes: 13e945631c2f ("iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-4-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ linux/unaligned.h => asm/unaligned.h ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/pms7003.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/chemical/pms7003.c
+++ b/drivers/iio/chemical/pms7003.c
@@ -5,7 +5,6 @@
  * Copyright (c) Tomasz Duszynski <tduszyns@gmail.com>
  */
 
-#include <asm/unaligned.h>
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -19,6 +18,8 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/serdev.h>
+#include <linux/types.h>
+#include <asm/unaligned.h>
 
 #define PMS7003_DRIVER_NAME "pms7003"
 
@@ -76,7 +77,7 @@ struct pms7003_state {
 	/* Used to construct scan to push to the IIO buffer */
 	struct {
 		u16 data[3]; /* PM1, PM2P5, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 };
 


