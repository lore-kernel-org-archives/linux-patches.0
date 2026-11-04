Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829257;
	b=HGnr/ksJpRD+0USbG0tf/CEJiYDzBcsQGPp+fpzyQrxPFywgn7fLcsnsalflxGpQMzKN
	 snZF9euCLbbR3W2dvJjVjg/Fll58k14S+ABwDy/c21zgC//PgyRU7AQjj8I+Cp6+F7wmt
	 ArAWXYfiPyBdUEfXQyO49GBzEtdWs9iLA7cXxAPPLRY72I7t+Qa8tVwuRuG9Gv7FxHoIf
	 PQEeNgYSVuUyhiYeNuz4X2Dt0x/dv5IaeQaboe8hQ4TPKsaVypT/g2wa9nG48nH5LENM/
	 I2IedKnJxzHfbyugbeTodP7RhcG8LdtjTAh1ChXQRfUMxm29Ttu8HuNOG0RsRPN8w0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wnD5ippteU66R/O+zqz2PhIN4UrCVfpIUXmKgIkci/M=;
	b=IHdccogi44U/wS5f5L3Q8cZY1hbKb1WTWJrS/9mqhgON+ofpBL+gq88v2HS6uBcAMvM3
	 AVDSY3Jd/roX9Zrz9WiB2OSRG+gZpOngfvsAi4VUu4gEHY4e6FcRkfL4WMUFP2XqEtdKR
	 YbEayxLbTs6tuR6Z0/Fpnir/FotanDZQvWQvg+Di9KXeiboDyk7asX5yqYu/V/52DmF0b
	 IEuX4YCaaRDto59lgxQM39+EILxin5LbrUmdmpImw/YvIUHzkW/6QrwgLz3BIyuzxCz4n
	 1WbNYUdFek7R5frJP1Ij6Mf175rkVStl+As10N72NCttrsOUjxbGlR7judoB05xxDEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7kO7Fzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0014606A845;
	Wed,  4 Nov 2026 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7kO7Fzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A201F00A02;
	Wed,  4 Nov 2026 21:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829256;
	bh=wnD5ippteU66R/O+zqz2PhIN4UrCVfpIUXmKgIkci/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7kO7FzjQRsk7IeMrpPP7TFADGueZyalSzBoX6q8YD7q7aTZXM647F13nmbH6DR8d
	 vsGPX9YW1hYwr6laTBtPu8fLyqJTCruKocZ0sa6oHheXYJdB2f4CKQf5GQkq09fLGA
	 XYuyQViU9Hqlqbm2a5fWv/lS6n6cJALwQWPh9DpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 7.3 546/547] media: rc: Fix build failure with CONFIG_LIRC disabled
Date: Wed,  4 Nov 2026 16:12:10 -0500
Message-ID: <20261104211053.917670495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 0c795849fd70d6bdb99aea5dd08d9b43128612f6 upstream.

commit 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error
path") broke the build if CONFIG_LIRC was not enabled.

Fixes: 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error path")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202609230511.Em5Osw74-lkp@intel.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    3 +++
 drivers/media/rc/rc-main.c  |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -775,6 +775,9 @@ void lirc_unregister(struct rc_dev *dev)
 	unsigned long flags;
 	struct lirc_fh *fh;
 
+	if (!device_is_registered(&dev->lirc_dev))
+		return;
+
 	dev_dbg(&dev->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		dev->driver_name, MINOR(dev->lirc_dev.devt));
 
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1986,8 +1986,7 @@ out_lirc:
 	scoped_guard(mutex, &dev->lock)
 		dev->registered = false;
 
-	if (device_is_registered(&dev->lirc_dev))
-		lirc_unregister(dev);
+	lirc_unregister(dev);
 	device_del(&dev->dev);
 	/* registered already cleared above */
 	goto out_free_table;


