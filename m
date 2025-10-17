Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E92C20A5E5;
	Fri, 17 Oct 2025 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713186; cv=none; b=dqnvMGYRJIgT6FLMqwptnrzTsrDs9T/owlivgE0PObTDpTRGND9MegqJ4o8Bl0dhygMor2IW2cKBzo5QsPrQ0YheqJTTubwBwntyJKapggl0jz/FrSYBn/Za0w8OZGva958Di+LMnONE/UYCYw/duqeUzm1pXPHpeQ6z23YL1xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713186; c=relaxed/simple;
	bh=BgXjQT2G1e5aiVE2Yl2QILAlxlyA8Tm9IskCvUI/zZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPxDLHDyWEuh8ApGQh0QhEEZW3UkH6TFiGYiVHkHw2ZkAXkT3bnVrv5lem5l9J19ZXsNYwyijRupRWIOvq/dWAEDJkefOrzr7G6vQ7y3dqSE2GcBG8ssE53ODLQZe/aVfIacPVmKXMEqv4CPdCcPc+3e6ZEQ4E7gDkGNEhVEHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVWhq/xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVWhq/xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588CCC4CEE7;
	Fri, 17 Oct 2025 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713185;
	bh=BgXjQT2G1e5aiVE2Yl2QILAlxlyA8Tm9IskCvUI/zZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVWhq/xPE28fXTa2oB4KGLM6ifb1pe+3Bc6HvLD6LOAktubLuzSFcGT0MQavhgXP9
	 voT4cgIYiMvGEMXH9H0xgxA4HWjiVq7pXnoEWDrYf4HimoMBltcFIHFScNieRzdn7A
	 MgFc1YGEg66AfAY9ZuRFBzAesfnjr5QbLBwlIDMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 077/168] iio: dac: ad5360: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:36 +0200
Message-ID: <20251017145131.864962830@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit f9381ece76de999a2065d5b4fdd87fa17883978c upstream.

Change the 'ret' variable in ad5360_update_ctrl() from unsigned int to
int, as it needs to store either negative error codes or zero returned
by ad5360_write_unlocked().

Fixes: a3e2940c24d3 ("staging:iio:dac: Add AD5360 driver")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20250901135726.17601-2-rongqianfeng@vivo.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5360.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5360.c
+++ b/drivers/iio/dac/ad5360.c
@@ -262,7 +262,7 @@ static int ad5360_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5360_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&st->lock);
 


