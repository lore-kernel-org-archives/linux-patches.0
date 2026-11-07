Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062893;
	b=v9tvxIgIR03dz8KIoGjaVfiG0HmYpKSFhdaLTXXhwcIwGE3mvAcRD+vj3tzSD+GRFWtv
	 qRkl9edefw6JGEtOOyOgL9LXyyWAVDLYmThKFsreth4r067YHIobibDX4v1eBWUXBTEiZ
	 LuoGhGaMwn1IDX4wlWT0ltlXebf8vcV+eVbyMdFU9uOjP7w/tcV8H9AM/+wsqp+yskw8x
	 t9YriMWG6HzfhHrGtsXlAve1brA7PiTjHlouayuFZjuNPTIFqIOgYFtNK/mN3St/VBOF5
	 NUeX5eKSZidS6K2Hjnaglh1JIohZ1xdX9sNUsFNJIBJIlrOWsdzdc5rbP/nZdAPZDAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZslX4+2thj8DzQwJTDqTNYbQIP9ziVPHSu02jMypXGs=;
	b=uUc2J9eZia3Kbrbm3++9qgZkTYkYPrTACVWjqPygwQkeqb0b/NeKe5L7slEO950xAAyH
	 hzCWwikK7HC4nqiHgcSwQetSEmAW/ctqVptvChHynOJhx5W7Gy+FrBs+fR38UJL6aF5g/
	 DWCkYukdjomyRd6cQYw4i8x8JQglC0MrL4c3CmUr4HfVUzeOkBpAqmbQFQ4d/DFdChHeM
	 a4lp9v1GUwildUUayhL+nZ6RWeYyDCERGc4tlkwWmDbIeD1YD/oQGxME8NGQkKNBpFGu8
	 b8fNOzWakSD50k4g+JUcWUxS/u2GaDW//nOyvJcVsGm06n0BVy3MHWgEB7anDGC/HDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEZDHN7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8D606A326;
	Sat,  7 Nov 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEZDHN7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498221F0089F;
	Sat,  7 Nov 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062893;
	bh=ZslX4+2thj8DzQwJTDqTNYbQIP9ziVPHSu02jMypXGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEZDHN7DcTYse56SGiCzmmufgu5inTJ0SrZlTSdQVMumtES3TvvKjgRvoXKVwU0hy
	 AufLPU/YM96gLLqWrlBqyr9mT1233s6BJ5bgv1ztKetBWUioskQblvpBtm6+0FHuAN
	 u2BRW4jOMn/mAiPUkVi/yQHrjt2W9SjZmw421jq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Tsz Shan Chan <tchan@jacques.com.au>,
	Subhajit Ghosh <subhajit.ghosh@tweaklogic.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/869] iio: light: apds9306: fix default sampling frequency definition
Date: Sat,  7 Nov 2026 08:47:33 -0500
Message-ID: <20261107134858.009250820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 5ce01037ae554..fc07518faec77 100644
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



