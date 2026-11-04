Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831937;
	b=bKDJVJPrCBUXDFCoAMo3TGaOLNv4mk9YHQeDCbJeoej544fF26hoNDGhQeSAPbELv9/O
	 9oM9b1fvHu1Yg4KRCxjW+NHMfBM3l9mYg35dkGtVhZ5uzttVKXMl8eF3WLlkq3LjM1gda
	 TI1ZXK29a5o5HsW+FScC191bBECHajgBhFt7d8e5g3zxAsXLi+t55mEKuQ9sS/6erOZAP
	 QZiwjTshmBNzaTbRjoS/jQTSSSyzmbiyDB6lg91yVwDEgDQYyCgmfOBDmy5zB3Ck4Lkfh
	 DGiibVbKGC6qmNrHYyTDlSBdVOTDCR+YwZm0eIdivYQcgsc/RKU1eAFtMdY1Q1j7mOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3L49HTQ3eZ68PNgqLiJRe5Tb07E9sCgIXJCkIl9x1DU=;
	b=LGkDHxL81A2a3YUigkAuAFpvz5uJdiGeKMct3ljuzE6f4WL3nFQ3WUrqRXJwvdHu4bn5
	 x/wx0rmcVu/eJwmJVGmn0NBSWGb9sY2TpHvU5/1yaFY3J4MbvsbEg11B6vSJtOAOxLQ4y
	 wb0FgHmBE5C4BMV0n0QsrbxxY4G7RFKhZ7Y1rmUrgMU4lwcaB9tvh0HyFzk7K7/iJUU7f
	 X3VCM7mP7jCjEuDRvAUJtpty5Pc63cMfQyc+GvwDSXjrmIvmEDQpSj1OuV8naZ27mFnrd
	 IRfBpMMNBRvBeaLr0XDwR3WucSbdkA7g+oVl2kO5Ag75WXnj09PIamh+pk8TVqlas8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wzh088CD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F35E606A328;
	Wed,  4 Nov 2026 22:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wzh088CD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA861F000C1;
	Wed,  4 Nov 2026 22:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831937;
	bh=3L49HTQ3eZ68PNgqLiJRe5Tb07E9sCgIXJCkIl9x1DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wzh088CDu3TCpJv6izw+wVh7CbJ2hq6FqhJxYoAyLiSwGQFkzjN6obcMzoU2rCSDp
	 J4f/tHVaP7NtkhcjW0xNvRdkN5rt0K2CQjoiZD/wf2tDmL35o6T7e/0qnG8YFjfOQj
	 NuL+0fVjWcWnDPJLN2U7HV3td01+t1i/0R0JxTdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.18 1000/1005] media: rc: Fix build failure with CONFIG_LIRC disabled
Date: Wed,  4 Nov 2026 16:12:13 -0500
Message-ID: <20261104211111.033619858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1981,8 +1981,7 @@ out_lirc:
 	scoped_guard(mutex, &dev->lock)
 		dev->registered = false;
 
-	if (device_is_registered(&dev->lirc_dev))
-		lirc_unregister(dev);
+	lirc_unregister(dev);
 	device_del(&dev->dev);
 	/* registered already cleared above */
 	goto out_free_table;


