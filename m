Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE7B33710B;
	Fri, 17 Oct 2025 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713706; cv=none; b=TIRH2SGQgBQYdJIaHblh172hMGh+UE/MlxzbUsY2bBVNCsbLXbjeINo0xDvku7KwWQqnTRmo8eKFD+Tfbt0Dm/0kYSMaugF1dptRbSjGJM3RxbPOdtqhAubxmdq+H8KOt3OP9PhlAQewEE9PjqmAI7nmtoUvkOsHPsd7p3i03Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713706; c=relaxed/simple;
	bh=ytmKJDtpF4/ZjeePnE1kUaDPHIRaU0FO5mQFLo5xg8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9pWPRuYInl9SyZ4okHgDwJquawymVAuBelZXoRVWEoZwBQ5FmNCwu0bMVhzpqjg2Waw4nW3DH4sD4DzAdrj+em2vpixMbT+HMsIA6cwVG6LrK+JPhexgDCSIuB9fXU+ukAdod0mclTjIG8fG0Pn7i1xCwQVOk9hacdFZbMYvao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFjxYoL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFjxYoL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20494C4CEE7;
	Fri, 17 Oct 2025 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713706;
	bh=ytmKJDtpF4/ZjeePnE1kUaDPHIRaU0FO5mQFLo5xg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFjxYoL/JxVlwQF6C4Q35r0ZPuKjsuvwoRzV+jpgmoNWNYtPgPbTI1gSAXYyxiuVv
	 sNJhreX+xnkQuPZXjpwva/ei3FjvZo0Pvc6aaL6E/QysFMbmCfLPDA9aHqg2Hnyl6A
	 qYeBJzlwAndOcxC6zcknMk1mZEYd3XeKSPEG+4jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 092/201] iio: dac: ad5421: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:33 +0200
Message-ID: <20251017145138.133154304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


