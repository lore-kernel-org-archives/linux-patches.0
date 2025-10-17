Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42169217722;
	Fri, 17 Oct 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714513; cv=none; b=IttUwqJm/1ry+kkNJXaXx1nspJw10cQR5o2RvAOcjlAdWIUPBDp4GJ4rLTV3Nc1HCLuTSFu2GQ3chl6mow1S4D5sjBhZvDUdRaMJ6qmrG9LprzNzhRwR+WrGz2CK62dxtUVUBCOWR5f+SGc0CJDp4LI7mczJJ61JyP80avg4b88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714513; c=relaxed/simple;
	bh=7fR0/toLM85dMz53/R45BPA2+TKlCvmh1RBbgywTLJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtJb4LV9braQCYS+ZtgUpy4JzDYR5bWeP0upZXgWBgEq3zI/3W7DQRsIuC6iYtEMsWSTvmtEO6FyxL+C5xOaqTzHGopC2YkHBpjGmwUDazK7QzdYKMCs308xqqdnIEwVp6ZvQK/5IkGtAhracJgh4/nRJ2/JTQL60hwMNN/um4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c80+fQH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c80+fQH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C5EC4CEFE;
	Fri, 17 Oct 2025 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714513;
	bh=7fR0/toLM85dMz53/R45BPA2+TKlCvmh1RBbgywTLJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c80+fQH472vLmHLjYbf6chQmAi2P3cnvbmcnQ/z4O2bTrSkj5smSZUSZBnSy/hI3N
	 w3tEuPUVLBNcvufoANaom1Xr7MpIKA/EfBe30Gj5inbcJmktkQtppxKvzWSM+HPgIb
	 sUTAtQaKzNrKSuBpbEiga1WXuHmhfx2xkWiuiep4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 138/277] iio: dac: ad5421: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:25 +0200
Message-ID: <20251017145152.164824595@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


