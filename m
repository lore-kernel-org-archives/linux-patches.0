Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA632D0EE;
	Mon, 27 Oct 2025 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590685; cv=none; b=WfXH+57NDS5uCPFNL6ZC5INLi6U9ma+f8IgTZqxlJl9Xrlcic6BhuUHX9nIRnAl77awiGH/kF0siZUtzc7n7i+uYoCAtFZoa2Oa5+Se1UYwVGS8aBubRj2zvBvBfJf6d093Yq9OfMSLSU46CqQ28dazDpE9xxmJ5RrwyiO4uq5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590685; c=relaxed/simple;
	bh=IddfhD1aMjzt7NJjJe654+NZD+XPW7LyAYUqKEJkX/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDH0c81JDekdHfN4GFlE3Ce0VMeygaRUUhUmGrHONztwhG1r9eZ0woepZK66kSglIlgEPeTMIN0lWB2BOrJNnvyYlbYDVSmsBy4LVMeW4KFrg6Zai75Jpm9ik8fq502vQRoraDGwBj8kosmRzMR/fpSoi0+ccMg4AitavN0Me08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hn8M+Ico; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hn8M+Ico"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E2C4CEFD;
	Mon, 27 Oct 2025 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590685;
	bh=IddfhD1aMjzt7NJjJe654+NZD+XPW7LyAYUqKEJkX/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hn8M+IcoqwlAPeXlSZSPhJ12MdbYoQVzm6JrDGQreLnQ2SDhnm7NsYjMSYxtp3S0o
	 Z0Z2f4Gnd9TU4QDzorfNX0NNysjYcW6idImm8snlCIkW2rJ7I/atl7fMRY8eFQmI+y
	 6rjR3+7YkIyMdP7miwpDtWvw/33jBN+tFBoOhZGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 109/224] iio: dac: ad5360: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:34:15 +0100
Message-ID: <20251027183511.910908935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -259,7 +259,7 @@ static int ad5360_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5360_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&indio_dev->mlock);
 


