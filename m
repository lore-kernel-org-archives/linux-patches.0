Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57441189BAF;
	Mon, 28 Oct 2024 06:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097678; cv=none; b=jw++YUQYNoFnQrAcTLRT9wm/mt8ULs4mzKBpMu0t6FJgvobDVhJrOXdLLkqiEVYqC9P9bUHjIK2pXJ+v3n5gqMVo7dOKn/SqDQsd3FDIFu7fdG3JUFBpNTZg8cBE9G8UAGY0GJrOlAwP8UnOBLxu632FMXK0CDfiGj0HNkCjCrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097678; c=relaxed/simple;
	bh=px81CAZ0uG2VYP6BrAigVYGCwPAaG58xFCV5u/08HW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lthpzkoDP/NSleiH3T5ohKWFyuL/z07NoC08ArwpahYJjiKEeCwO4HOpiTbMg4hMsAP8SVbiY+4vy+QnzUWnSBLvxdDCz3aWbHlbGWFD72HLlR+jwLzwlf917Bkf43hYF5Cc8rNpwckU/ZdN6deJysdrxaq6VyiCQZuZCwYDQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxmqc1wE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxmqc1wE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE2EC4CEC3;
	Mon, 28 Oct 2024 06:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097678;
	bh=px81CAZ0uG2VYP6BrAigVYGCwPAaG58xFCV5u/08HW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxmqc1wEH1ekpfsZJ1Y15FAY+3YQphbQ0A6RHgjfo2H+2NeJFpTY6lHXRASuqJ8eR
	 xdy/mz9BGp3IeFcYFV7AQXSeucnlFZ9jCA7AFrEQrTn/XGu1MYf2trVFOCMg8RAhw/
	 Kk54AdAJRHGQmV+ruCTk7sy2I5kLvEyQ8STNFn9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/208] iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 28 Oct 2024 07:24:38 +0100
Message-ID: <20241028062309.073203050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit a985576af824426e33100554a5958a6beda60a13 ]

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 6c7bc1d27bb2 ("iio: adc: ti-lmp92064: add buffering support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-6-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index e46817cb5581c..6dee3b686effd 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1335,6 +1335,8 @@ config TI_LMP92064
 	tristate "Texas Instruments LMP92064 ADC driver"
 	depends on SPI
 	select REGMAP_SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for the LMP92064 Precision Current and Voltage
 	  sensor.
-- 
2.43.0



