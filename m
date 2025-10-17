Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4427D337100;
	Fri, 17 Oct 2025 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713194; cv=none; b=Lsdn81X6tw4vvW4cB8jvj5HlZnWwQJxsT1nL6C8e06Abv2h8GBWVbGeuZcmmNTnGSfN/+jXNsCzsGQ0uXTrVY4y/HME7accbEtZitOviS3lQ6lgmYjCdz0UTSawnQeUbZ+CKCdWWLJXvSKnEu4WQjQ30EBjsEAtX6Zkqh/T0Fdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713194; c=relaxed/simple;
	bh=j9CcaA0Hk18LU1W8Xo4TtC+xW9UHwPKa0DhtS4iSnys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhIEtBtsBtc0KVZ1IyBdICLlW8+0Lhyg56KNmSmUw89Ui9+Tp1zl+uA/e/DXvAimhfXP7Tg1bNrzzWVPYcMV7UWTQ9pPnk1WJpjRbcYzi0SuzaOXsw25/MUCZwrPF0CxgEAGIud0S4RcimdNQ9ymNIytokgpS1AfYQGsNakxF0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkGYZV+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkGYZV+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7478C4CEF9;
	Fri, 17 Oct 2025 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713194;
	bh=j9CcaA0Hk18LU1W8Xo4TtC+xW9UHwPKa0DhtS4iSnys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkGYZV+nLA10+7vqKcyVJ8D4sj4qRTqYZp1I3D7WfkgaEiOmddr0VZqt47qyNHzwR
	 Edyn49CBB1mpItdwGE2E0grGvCWEs734GsRCbcsHHUPPqNHbBDQ3gKiJ7qHrAmXBzZ
	 jgA31nJfRqPF/JMiTOtBKfOYRDO3sLx3Fxm/rJ6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 080/168] iio: xilinx-ams: Fix AMS_ALARM_THR_DIRECT_MASK
Date: Fri, 17 Oct 2025 16:52:39 +0200
Message-ID: <20251017145131.974657490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

commit 1315cc2dbd5034f566e20ddce4d675cb9e6d4ddd upstream.

AMS_ALARM_THR_DIRECT_MASK should be bit 0, not bit 1. This would cause
hysteresis to be enabled with a lower threshold of -28C. The temperature
alarm would never deassert even if the temperature dropped below the
upper threshold.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Tested-by: Erim, Salih <Salih.Erim@amd.com>
Acked-by: Erim, Salih <Salih.Erim@amd.com>
Link: https://patch.msgid.link/20250715003058.2035656-1-sean.anderson@linux.dev
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -118,7 +118,7 @@
 #define AMS_ALARM_THRESHOLD_OFF_10	0x10
 #define AMS_ALARM_THRESHOLD_OFF_20	0x20
 
-#define AMS_ALARM_THR_DIRECT_MASK	BIT(1)
+#define AMS_ALARM_THR_DIRECT_MASK	BIT(0)
 #define AMS_ALARM_THR_MIN		0x0000
 #define AMS_ALARM_THR_MAX		(BIT(16) - 1)
 


