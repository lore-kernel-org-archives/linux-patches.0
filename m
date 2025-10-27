Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87953164A8;
	Mon, 27 Oct 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591291; cv=none; b=dEh6y2hama/CohDTaWET/+fYLEDWV5cShReKry0pbNTt/cwtyiHuaUNUmaJrijIc0bOIHmjD8iOFGJMrvnoVa6iFg0FCD0n5ZGTeodEo9XtV5rSevrKER5XEwLRgSpgY/aOYj2SY0ZMVCmZ9ukSmtN/1uLUMsyFog0e0XZ5Y12A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591291; c=relaxed/simple;
	bh=YWONyiX0Hz6rzpK8EAa/UbPryTyy+Mi7bvsKjG0eHRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APVv3tyXh1aOX9XQUn/I4aNezMJlQBwyztuglHoiKLGaWecbdEvB96lElL92jK+Wkm/A46b6zzQHnzl3Ue9gdU3/IbwOCZdrCjJZPRlDag1C5p/6wV6ZDkb9DZ6EBopCuCQR/cYiFXVJQdRWGqaka5SeU87SYUE2IQDjftD+YbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5Uhw0t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5Uhw0t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAE5C4CEFD;
	Mon, 27 Oct 2025 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591291;
	bh=YWONyiX0Hz6rzpK8EAa/UbPryTyy+Mi7bvsKjG0eHRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5Uhw0t6RylahW+36pceMnW3l8j8trV+40OW78jdnVCHYGBWT+76xY2eY+J7eZVjC
	 vvS6vygqNB3gGbQOZBO1bQc3p6dYG9MpHwaUNSX7zcARyodFsO+yJGiL6ZMBEn3n5G
	 kNXxYaSDLqByv3dQFguVbHfK96jpZgUCKKVjAICc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 140/332] iio: dac: ad5421: use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:33:13 +0100
Message-ID: <20251027183528.333449601@linuxfoundation.org>
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
 


