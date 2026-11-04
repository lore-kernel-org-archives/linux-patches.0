Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831460;
	b=pGD9O+2mqtBFzilXUYTDSsynWP7HO8rp0Zc0zMTvZbiv8cUoj1ZCNQXX4f61aQFcXQMO
	 OsTGBQadv+sfY6Bo7/+3AtCeO2dai7RwjJ2FinHoUxv/+sqB4nsPH3d85bJNI1tWKkl9D
	 zMAeLKuljtbgxFGt+nXwPPtSMV9uI8/Xk4LueSSAy41eGUi2JyH07wG2wPjioNZw6Ut7T
	 JREX/RclkKQnoW80oubSzfopwPDm97wmogH7hmMaXOQbKUvpTvVruPRj7LYwLWp6YUy5z
	 As5WlF8r5//I5N70jT/dHLatUActWQyVYHB3+CkZrpgZzZlJGVPFw0rpA0crqICxhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=upbZCLkejFXdIrvPpwnMigf1fKYC0sCPk0EwGAkxX+U=;
	b=SL7yQYOdff25tvKT+Woa6WruEdEAyE0CBpQDJbaKNGcIu/KI+QwOg2myvekK3qwPieXS
	 XhGbK5DdzonL7+vrIaeNE2oh7S/rCJuJCpOW1sQyKDJqrqXIRuM27c2/bMEP+nq0vC8Nf
	 Kwhup/nD+r+fAenygeVbPYJ8knm7CJtpxMn+s4lY5ELjsDipTsV2QldezWLig+zwJ1tRl
	 AhRxKq6DsZ6uRvVDKyPX17BIXE4RyayzVFKug9EeBCIGI+eYLHWeoUzUCGoKN5+mxaklp
	 kdAAvWXG2/Uez8nA0bfx2a2nCYBY0OrB9zkvgcnLG3NsKSrXgDo4PAC76qQW97HC1mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01sjJk+G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF26606AC17;
	Wed,  4 Nov 2026 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01sjJk+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6881F000C1;
	Wed,  4 Nov 2026 22:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831460;
	bh=upbZCLkejFXdIrvPpwnMigf1fKYC0sCPk0EwGAkxX+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01sjJk+GEbZoahVWApSXNnh+VV4bfbTFqEk7zGhT55v3JNgqsskxlqBVWcxOdtFeV
	 sqC9GRbf32aNk3InG7Nq+TRKnO73w6hzxnLjJuf0/SEPbV1ERhNcayv0ercEXTyTmf
	 Ad7rLk1THVdKQgqP8Xse4Pe3/4W7jqyX5dXOk9tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.18 0677/1005] media: imon: fix use-after-free in display_close via dev_dbg
Date: Wed,  4 Nov 2026 16:06:50 -0500
Message-ID: <20261104211102.600370191@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 118a3590a4080c71c565265b05b3f92e814d7647 upstream.

ictx->dev is a raw pointer to the usb_interface's embedded device.
On disconnect, usb_disconnect() can drop the last reference on the
interface and free it while a userspace fd for /dev/lcd0 is still
open. When that fd is later closed, display_close() dereferences
the now-freed ictx->dev via dev_dbg(), causing a use-after-free.

Remove the dev_dbg() calls that dereference ictx->dev in
display_close() and free_imon_context(), rather than taking a
reference on the device.

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bfac891bdd42eb708fc
Link: https://lore.kernel.org/all/20260918054851.26083-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260928121230.35359-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -492,16 +492,12 @@ MODULE_PARM_DESC(pad_thresh, "Threshold
 
 static void free_imon_context(struct imon_context *ictx)
 {
-	struct device *dev = ictx->dev;
-
 	usb_free_urb(ictx->tx_urb);
 	WARN_ON(ictx->dev_present_intf0);
 	usb_free_urb(ictx->rx_urb_intf0);
 	WARN_ON(ictx->dev_present_intf1);
 	usb_free_urb(ictx->rx_urb_intf1);
 	kfree_rcu(ictx, rcu);
-
-	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
 
 /*
@@ -577,7 +573,6 @@ static int display_close(struct inode *i
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
-		dev_dbg(ictx->dev, "display port closed\n");
 	}
 
 	mutex_unlock(&ictx->lock);


