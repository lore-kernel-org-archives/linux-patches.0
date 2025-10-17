Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68D13370F8;
	Fri, 17 Oct 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713188; cv=none; b=BuW+e28bBFOcV+QY1peGxVaK/qvKHIb5mN8QQLtk9fZS8mJyInkaKsOp9wf2l2cSXB4POWQIdONkpB9Pu5F8y8IQUcVIHS998+RAHqpeQywsw4k2OqSCIcgwO87ETqGXBY6jenPx2rN4opgdsk8ngwQqdGmce+CvSwIoEezCivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713188; c=relaxed/simple;
	bh=YFpxyDAvZJufuFgQHRH69Zz0pherE8tOe9oCyk1+hSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC/G2iU+C0ziwAPHqJZ772QGg8CWE2zN44GX1oGCVbvlZ3cGaTZlJvj7iAk0zvPJLISOpV5DORJUOVlJWO6Dwmtg13fRtlk18XpxPTvjk49O7YiS36Gbwy4Rg5Y9DqSm2JuHxArorLOAQL4Dxom2j+zdlynQ0aTbbhZtV5340wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzToPjHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzToPjHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EC9C4CEE7;
	Fri, 17 Oct 2025 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713188;
	bh=YFpxyDAvZJufuFgQHRH69Zz0pherE8tOe9oCyk1+hSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzToPjHF+7kimbX6hwCJbpNCoXqw8vTg+7A/fI4nSDfbZHwj7KPCGqWr4tsrxbLsx
	 ETezuJTopZqOUJMPo3jCjdJp1OR4rSGcEC9TuDjJEuRqnJ4AX0UhOIGrxQJj6f5Z2I
	 NEztiHoP9yY2hPQUtM7p+qJfAHwPsPwgaWWE3mV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 078/168] iio: dac: ad5421: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:37 +0200
Message-ID: <20251017145131.901041250@linuxfoundation.org>
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

commit 3379c900320954d768ed9903691fb2520926bbe3 upstream.

Change the 'ret' variable in ad5421_update_ctrl() from unsigned int to
int, as it needs to store either negative error codes or zero returned
by ad5421_write_unlocked().

Fixes: 5691b23489db ("staging:iio:dac: Add AD5421 driver")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20250901135726.17601-3-rongqianfeng@vivo.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5421.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5421.c
+++ b/drivers/iio/dac/ad5421.c
@@ -186,7 +186,7 @@ static int ad5421_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5421_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&st->lock);
 


