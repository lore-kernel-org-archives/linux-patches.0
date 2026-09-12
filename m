Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7934752E;
	Sat, 12 Sep 2026 07:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199907; cv=none; b=D32LBypvFYOa63hF+vEgsXnU3mqcEQFs5y7xdGs0eFS+vCWCC2V+HRKlHTnwVYDyNps2tFWHYh+tcY+6tpmkNKnFROlEMBiI5CWCdEiCnVeuQXeCPnmpD+bUFMQHdELdaRfX9xdSnmpV4zZNaFEEmqTmx7GvaGq3XjqcRxqSjYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199907; c=relaxed/simple;
	bh=Uq9oiw3sMyfAi1ap9GqXg11wxWfcLuCBbXjhRbhDHwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exBpMBoJU9A7tUdcuDG7xW3w1IN/IBqHQdP9U6WqpQvcQ6EvRc7YYhiG1PDkAbUzwMFHFI5KFQSWTDzIvu/hXF1/0ddxdWtwLZcCZjNqV7bBcEVsPZ7IgL9SfX/PK7uafHS9bgkI80gp0FJCE3oDQoasJajBpU9830MBnb0m9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsTSECPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsTSECPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B02F1F000FF;
	Sat, 12 Sep 2026 07:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199906;
	bh=lyeK2jga21svbfPqwvXGtFwa7CP86L+f2Aqz5dy7HmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsTSECPnt1BCln2LXl8k3o4cdeNaoPR9cZO9kSPMtsWE+5r7YGu4yqqPzdLQnIEZB
	 UneFlprlV135Q3h94SzwxOKWx28L8/muFi9UAGVhYgov8H0MuhKMx7Ov0P3fTsoWau
	 uIK+EgILyNR+/2oHqF/XivCITsIAV+1wUb5Ez9i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Kota <rakesh.kota@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0679/1815] thermal/drivers/qcom-spmi-adc-tm5: Drop IIO_VAL_INT check in adc_tm5_get_temp
Date: Sat, 12 Sep 2026 08:40:29 +0200
Message-ID: <20260912065704.827770382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rakesh Kota <rakesh.kota@oss.qualcomm.com>

[ Upstream commit 0c569e22020f53ddfac0099b0aa193907bfbcd6f ]

Commit bb21ee31f575 ("iio: Fix iio_multiply_value use in
iio_read_channel_processed_scale") fixed the
iio_read_channel_processed_scale to return 0 on success instead
of IIO_VAL_INT (1). The existing check in adc_tm5_get_temp()
treated a successful return as an error because it expected
IIO_VAL_INT. Drop the redundant `ret != IIO_VAL_INT` condition
and rely solely on the negative error check.

Fixes: bb21ee31f575 ("iio: Fix iio_multiply_value use in iio_read_channel_processed_scale")
Signed-off-by: Rakesh Kota <rakesh.kota@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260724-adc-tm5-drop-iio-val-int-check-v1-1-0b85a0895dd7@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
index d7f2e6ca92c2c..d1b086737bcd2 100644
--- a/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
+++ b/drivers/thermal/qcom/qcom-spmi-adc-tm5.c
@@ -369,9 +369,6 @@ static int adc_tm5_get_temp(struct thermal_zone_device *tz, int *temp)
 	if (ret < 0)
 		return ret;
 
-	if (ret != IIO_VAL_INT)
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.53.0



