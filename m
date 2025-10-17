Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730EB2DECBC;
	Fri, 17 Oct 2025 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716510; cv=none; b=c5IExLG+ztX8SjaDD2PBKjZlpIyq1BVk0EhJk3vsvy1gT2yep41Hbt4CJvqhaSxtbjeandx8GPrhMDnLKrnTU9tQ2lRAvA6oztVhcOE/+tXGW78vu377ABQFvBYzg1xCRXHBUg1VWKECQ9mbnpHtG1227xBXJfIv2tZqLcHJZVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716510; c=relaxed/simple;
	bh=4d5ymmunzL4+XPy0gXw9X0hvP9uSKIEsXyp0hyj9lr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsSig4XQTJ/fFz+7W6uWsnnSjC1YwDtyqjXgoIZnrJmYvN6/yH+R+V7nGNqLRkpaCKfQGC+feHW3bwqVe1oOV4lsFuzAGAG/AgRdFsEPK0YmyNQhNQZ1ecIWznUmAbdcPwbuUe0QX3H2GLrro+VhDaZrJVRGTnqmoRZYeSvca9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiDGwko9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiDGwko9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8D9C4CEE7;
	Fri, 17 Oct 2025 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716509;
	bh=4d5ymmunzL4+XPy0gXw9X0hvP9uSKIEsXyp0hyj9lr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiDGwko9cMPL51GwtwTNKxwhCjUwk4La3I5c8I6zLN3i3+QyDZX+rhF1AA79hdXPw
	 zFq/bniurYFeeU/DmD2AhQbIk39nnpZQx7L7est6oQ7/VOF9eL9fwxs1/1EsHWtySM
	 4+UAaEGgwXBIqjhHsBVOkET0a4ihBlejFA7q/Qcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 182/276] iio: dac: ad5421: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:54:35 +0200
Message-ID: <20251017145149.118766029@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


