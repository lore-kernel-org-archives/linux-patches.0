Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D531B83D;
	Mon, 27 Oct 2025 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590610; cv=none; b=CoMEfqdmAQhszAjHXz34ZBptDSURDsw9QdO3G8Y2wsmWtiwblJt9MfmGaDpyZCVa1fqahsVQlF37kY58Mk43DnO9GwdoNGzaawgXR4HxDpFE9Fl2LX/iMBRti2TVghvD/yqWbfLUpdQmEPZPhXVdzn5dNm5UKIA8v6HsmCREYkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590610; c=relaxed/simple;
	bh=gRmqGkhDmP9XJCu6idN7meka35lenvcQVU8gs9mexYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ7ZZCZfsLLSTH9Wm+jCaK4e7vklg+ZsQV8q0BWT0n4jhZTYbrFnEz2YtdqK0TYxC2Z/Mqvx1OzmJH7vyYnK/L10WbucGNgAVStYyShz+6VhNK6xDVbHBQJJSwEPiXIJgRzUSq6R83j9C0YyqRRiMqcO+LE1lidXEVhScXCGGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZd9zNh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZd9zNh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF01EC4CEF1;
	Mon, 27 Oct 2025 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590610;
	bh=gRmqGkhDmP9XJCu6idN7meka35lenvcQVU8gs9mexYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZd9zNh7ffz71vUJQSnKRsoMHNnqxKE/nMovGtQwZbR1yETd5FgqhrZLINMMbW3rA
	 gSwIXWA9ywL6M45trXI3WkEWw/JGZJBIxrh6efMeWEHY7PQc+BQa0LAaI7F+4PSYnO
	 fBUsM6U5LOAMsc6cP6/ysu4hcl5UYS8tY28SqqIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 110/224] iio: dac: ad5421: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:34:16 +0100
Message-ID: <20251027183511.936229439@linuxfoundation.org>
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
@@ -183,7 +183,7 @@ static int ad5421_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5421_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&indio_dev->mlock);
 


