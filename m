Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062024;
	b=OG3AeKcDpJFs/Wy9z45sooxSvAYRsUTrUaMmqovulMNa92mabwt7Rgc+zYeZ9S93lKCr
	 TT4y5fz1x5eODvmYihvZyw+qApqYbkw+1/KZePxe/u0M96rPoSDs0vPYXSjokybDRU2Nw
	 EVr+OxWEOHB6advlvXZECmEZIFYI+FCpfQCAdtl3Hd7NszS83Z6qrdg7LvO5FL1wqy7Id
	 NDxq3ZPD2Vdl1IZkuf+z91LPBpAbBemeF3i/sL2rb4Sp2rZsds3kJfVTHVSyqgtqqGoQe
	 NevuczjX1vn9V0depdw+LlnQTQJjZLCDoEVO1AiHGN4J8kxfzHH5bvIhhyfyLNgFYgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n+YXYQqXWicA67Ia+HZsP0Ph4sYFthlOzeyyfPi92wI=;
	b=kf0hwnZY7H3gM9Vls6rPnUvOv9F5aV/gXqy28jLsTNJJiOKnZQfkqYGpUkoOoUdWkcvp
	 FMQiLaS+felYWBRWurKPJA7eNOXo/MdgY86yht+nUV13vbVz4dGWmhm9GspHJQDPiNC6v
	 6p7QYoEGbRII9GU7vV58LkULPMfUb8ujEb73f1BaBaDD8EQoycn4XMkyv/GtoZajpnRf7
	 q2iuAd+bpRJGI/jbPGkfIlPaza47Z8ZqrV5BOHaIoEq0VbPo2eY+3ih6r/I2iy10FCH29
	 Qk9BkyvbOoYCEPXwuJQK8qVHuwinK094uYMmm7pXLr5JeUqW5lFhq67pG67oNIxVJIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0my+gQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E667F606A337;
	Sat,  7 Nov 2026 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0my+gQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B71F008A1;
	Sat,  7 Nov 2026 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062023;
	bh=n+YXYQqXWicA67Ia+HZsP0Ph4sYFthlOzeyyfPi92wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0my+gQANb9xfvQAZMnkECrWZmw3CCJ6vP4d60wd364uCrMi+KejdzsNApEqX6bl9
	 A18/8AEeWVwVLLMlfIgEsvizDWkg8KvXoXP4XWmdZODikBLV4IIFUvVVClDU7NkvYO
	 EwCcS7Go9w/qze1QTTbp2fdJJOjRPddM2sn91rX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Tsz Shan Chan <tchan@jacques.com.au>,
	Subhajit Ghosh <subhajit.ghosh@tweaklogic.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1010/1536] iio: light: apds9306: fix default sampling frequency definition
Date: Sat,  7 Nov 2026 08:50:26 -0500
Message-ID: <20261107135026.038652392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 7f9d6cac8adb7..db648e2cb5200 100644
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



