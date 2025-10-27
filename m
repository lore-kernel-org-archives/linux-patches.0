Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EAE3164A8;
	Mon, 27 Oct 2025 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591289; cv=none; b=p8VO8w98I/vRt0Wfo7AQ5B1o+c21K53kR7iDevyNS6aMR1OqjWkA+teFR7MysBN6N6f3Uw1gEDZuedMb0MC1ih+B5iAl6yrKRNR5y56CF2KAAPGd5SI8JWusGG6eodDSmlGRypPW3i6Fyca2OQwOCvIFmf1+/PwZn16UaJTn/bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591289; c=relaxed/simple;
	bh=kx0adCQEriJ612K7d1nMlsLGycdyQsQVawm5NBExhFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8JyZrcu6H8WsGWKcyR06wKJTULcK0lIWfaDMsESMBMUK/IhpWeoT06bFyOV3FVvtCmjy8UfPol+Ko4NjgFS34/t6hUc6GAcOlmdK3O480NDGGoQTWQ2JBEUG8Su5YHdVUGirPIaIwtdWOwOYUMwoM2COtluclbgr7ODaeI5ChQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQb1QFUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQb1QFUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D3BC116B1;
	Mon, 27 Oct 2025 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591289;
	bh=kx0adCQEriJ612K7d1nMlsLGycdyQsQVawm5NBExhFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQb1QFUJlqOa1+GAc/4BxHAM9cXgAaXAugnehrtaCOWnWb7G+JiAUXTrnkIDzCo/k
	 E3spmWw4fkHgZGLv2xNROZRtjOzAVJyRSiJ/C8jhcm71l8S5VQubQQrr0mk2us335Y
	 gnHrG8YezvmGBqbT5je0Qj+fwcg52VhTuDBE9MVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 139/332] iio: dac: ad5360: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:33:12 +0100
Message-ID: <20251027183528.306133235@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


