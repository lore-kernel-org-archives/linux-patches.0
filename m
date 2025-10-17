Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D723EA9E;
	Fri, 17 Oct 2025 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715449; cv=none; b=TvFJZrEbKwmtSM2QF49rMSarGSvvcTpQIvbx6SYdybKjPOnefei4DJaBeW0AvunNlisaPS47qSWTvMa/V/xxH1yE/OlyQBPJBvtQ7vbY3tt2qeheSBD+c0wM1WZXH5BfWYDN3z8cFWfNLSbpIG4eAYAStyx26+tChqxrEh9hMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715449; c=relaxed/simple;
	bh=nalsKtvlhvib+SYWpzmEiWiQlF64MOUdee+Dj3jci+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekDcNl5Dc1jiDJhGHChnIchqQ916A5mQD5x7Hr/Z8gHICt4bFZWzmmTblW2eYBJUQia291hlGVPyp4XbZy5mlqjkf4RYrX5ziCyetZNcqBT55a/XGnJ2sS2+fvpStkIRhw/P2NiPahbhEgFpyVnHA68BtwOKTJ4Crz7hDcClmWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xblBvOvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xblBvOvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D2C4CEE7;
	Fri, 17 Oct 2025 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715449;
	bh=nalsKtvlhvib+SYWpzmEiWiQlF64MOUdee+Dj3jci+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xblBvOvWCYRukiq0LSiLoiPJasrydDoQS9MzWf+f8af5KKPvLHInkWXcwTuO7zNC7
	 Nz9zT8P95dh30oaiOd4onyWyBbAVlRf0lB+6Eoj0tbU3POSYd3kLEurAeYo9gcb/DM
	 otaIOz6FiNy7r7FiXPyTEnSoAseWr/l9AOMZkXCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 220/371] iio: dac: ad5360: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:53:15 +0200
Message-ID: <20251017145210.047753550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 


