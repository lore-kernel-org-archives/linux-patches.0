Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064093;
	b=XqMVCqhqO8knXk6J/Y80K5zRKZwdOoHpHljNuPduLD+OtTPJx8v2XUzYJwDZnz8Bqy4v
	 i6+oJRSMbzRvPsFBtzSvsEk1jbhNs7ppw2rJTA6HDIzuxUku6iJvy/3zEqit+hflwVXp8
	 iomn24m1QD56ury1MWGBo02r6iymkSYvtDkAF9dfgxTIUzl0gST5K62Z3HGPBbwgyYHQY
	 L05g6/4W26HGGn8RoJybxJuLBdaDlMNE1U4bMa7L2C2PO++exXujIFdG1sL3YjD20fFzH
	 aVQ4q6GFmggJ7YeL39U3Dh7Ject8ldOjeuaz8iHQCT01b16B3zhA3OAWIDVDPr2T1Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nbuPDMAR3vM5CJClZbHk771lI03CCDaN+f0Efhfr824=;
	b=Q52PSKId2SqwfMTPvu4FKlHt01J6hh/UyRmgsvRQxJ5ReSQ7GDzwRTMbfgqjbHxtP+IN
	 N8DGpTHpyQQt4VvsZvUdkkYhwHMMCtgTC47fGjaUdHzdfl/9J3xyPYFYstTIcmCztc8+g
	 uD43FdkkH2YnKPoS9t0HlwnUOVd4cIeNNEWoYDoqvEvSiKtVAlghIqI7FJl3LvHYK6fmJ
	 1BnIzOJFHkNLfBe8P7jn4r7ZwIp4B/yEaHGhBR8ngYud7uN4isoBYjQ4sgadRL4HRMnO+
	 WkY3S61d6NMoh6XNOmIrF1LNAlTytPyGZrc6xZqvI6vTpZvhBe+KSfxQ5QGVcKahWQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2XteIYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EF606A9EE;
	Sat,  7 Nov 2026 15:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2XteIYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9901F0089F;
	Sat,  7 Nov 2026 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064093;
	bh=nbuPDMAR3vM5CJClZbHk771lI03CCDaN+f0Efhfr824=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2XteIYg5LTyFH3XCX7TBzTmyq1hnZRzPBbp9JWCD/Ri+2BfdkqYNfTHVTSDac/p8
	 hbbnD4aOg8xHmfgoQaif/og8vGgvcE0jS/a6r+eFcp5T00J/i+cGS+cMfJyhmv32yO
	 /jBn88Oev/VG5CDdH7td5xRwqMLX+0WYNo51N2pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Tsz Shan Chan <tchan@jacques.com.au>,
	Subhajit Ghosh <subhajit.ghosh@tweaklogic.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0216/1257] iio: light: apds9306: fix default sampling frequency definition
Date: Sat,  7 Nov 2026 08:41:52 -0500
Message-ID: <20261107134945.503001123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Tsz Shan Chan <tsz.chan.dev@gmail.com>

[ Upstream commit a1c005f6336aa41f23552e66ea1b98b9ee493a86 ]

APDS9306_SAMP_FREQ_10HZ is defined as 0.

According to the datasheet (Broadcom AV02-4755EN, page 11,
ALS_MEAS_RATE), bits[2:0] set the measurement rate:
- 000: 25ms  (40Hz)
- 001: 20ms  (20Hz)
- 010: 100ms (10Hz)

Change APDS9306_SAMP_FREQ_10HZ from 0 to 2 to write the correct value
for 10Hz.

Datasheet: https://docs.broadcom.com/doc/AV02-4755EN
Fixes: 620d1e6c7a3f ("iio: light: Add support for APDS9306 Light Sensor")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Tsz Shan Chan <tchan@jacques.com.au>
Acked-by: Subhajit Ghosh <subhajit.ghosh@tweaklogic.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/apds9306.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/apds9306.c b/drivers/iio/light/apds9306.c
index f681b02e49225..7dd41136734f5 100644
--- a/drivers/iio/light/apds9306.c
+++ b/drivers/iio/light/apds9306.c
@@ -61,7 +61,7 @@
 #define APDS9306_NUM_REPEAT_RATES	7
 #define APDS9306_INT_SRC_CLEAR	0
 #define APDS9306_INT_SRC_ALS	1
-#define APDS9306_SAMP_FREQ_10HZ	0
+#define APDS9306_SAMP_FREQ_10HZ	2
 
 /**
  * struct part_id_gts_multiplier - Part no. and corresponding gts multiplier
-- 
2.53.0



