Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C23F3370FB;
	Fri, 17 Oct 2025 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714493; cv=none; b=kLbPacqus9G6Orbv3XldUDRpz5E44wB5Lo6pE3PWxXMN5lF2F7z26UsUYppoLxZQT3tEVGToJMYsxTk0QL/qXAJq33r4co3/jMViBIXn6PBhtZ7a2aXWUmioEbUvuk0u8+QWFA8GOM0KVrnmvc9jyKguB7eqhKWKFQume3jQr0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714493; c=relaxed/simple;
	bh=7OotvQARDmN4rPgr44i+RiKX+9Ty9vLHBQUAhZ1fa0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBi2nga8PiiADxMf/OrHB05narhZhqxLG85ScZNpr3saou5pGdjBgens8zU77Rsf5bHgwlvm3aiuF5vhmYGMNjCadf4Z+eCTahjVKpl0rxyh1fW+lejdwaeL/3q7+L7JFoKN0TJvTlhuPNBt3Amu7PPyV9LP+qtzIzoDHHx/axo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWkePAo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWkePAo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1EDC4CEE7;
	Fri, 17 Oct 2025 15:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714492;
	bh=7OotvQARDmN4rPgr44i+RiKX+9Ty9vLHBQUAhZ1fa0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWkePAo0rKqPhNlQcxaP2BpTQPUDPyK47gS8P6k2EST8ySpvZ+UmZW6FxHvYPMVO1
	 bMFTLuBJmwBK9ttsA5c0MwJNm82ifQzbQBG4UKgfDszkgC2SzAYXg3dpSxH/XDDfRg
	 sr3JGcP92fhAkgPjGfCWzWh4s6CpmBrJv7r28NSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 137/277] iio: dac: ad5360: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:24 +0200
Message-ID: <20251017145152.128716065@linuxfoundation.org>
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
 


