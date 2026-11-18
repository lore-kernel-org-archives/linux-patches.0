Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051696;
	b=kPgKnJrJbJk0K4WOpBvXXDRbC2ms9wUUCWkKqvfhfXZicuRGScN3OERs0BmfE3IxkDH+
	 NjcOCvkyNO/TIXHrCRAG615d5Dpe3xsu68aX6tQK70WcXPfRifrd4A0Da+GF/oygcoUun
	 T3y4S9Oi1atJB71suki8GuNp/qXk9q432Qa9tyr4LP8LeU87WVFWIpME64w+ZsDZTQYJD
	 LwehKgMpo4IaUuTaKskrtoQNoKX5Lsw5HTTEBYIGZAkDVt9cUubgQ44zJry6FlfMEJjZO
	 VAE0uThFT1qD/8qJubOp04pPacTOPmeYmFUFCJUz8+StK35FYNZL0BrgDT3qiq/bZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ja5RLB/UQ4Jh9INZUj8+eqQoy3sdwbIB6hvjTLUvW7I=;
	b=ygr8Hod7Bi2JGEuo1o0Cb5C4knn5trc/P9eVXaXxPb9jZFBnCWyg/5jEzE3PUkmysLDq
	 NA3dMu9lSU8pdXs01Yz82D8qOD2RFWVv4knSHci+62qn/rjL1v+KnNmHY8R430XWm+xZC
	 p9B2wtBfeXQxjXmq382fH5RtVBw009rP9LPrcv0o0A/2/MXrqjoBq3wvB6Mz2Zl4igIjA
	 21sbAoHMt9oZilqid7meTPeISkfWwgQf1Ept69UQ7aRfjMhkAFaDRLccvsOhOmZ/N4CSN
	 Wcoxg0maarL/xDfyoKT6FTS8LsVAefjhWvLTsAbw5z1/DXLj0eKV+jUFkwZemtHjLlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vm5xN8H0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE0606A32C;
	Thu, 19 Nov 2026 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vm5xN8H0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0611F000C4;
	Thu, 19 Nov 2026 01:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051696;
	bh=ja5RLB/UQ4Jh9INZUj8+eqQoy3sdwbIB6hvjTLUvW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vm5xN8H0bNm7q9xjsBN0P7RkHch63pHcwtYlddwm5GYXf9otu1EgHUDBCt8pOzu+s
	 Wbez26BI4xpVKs4OKTHknFs6FQyZEajX3ju46o79ijQ6pLiFujY2sD/93z+lEgqSKn
	 Ff9xdRpW3SsEU4Wez3tTdSMl8+F/XKxk4SCdxwBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 5.15 0298/2214] media: imon: fix use-after-free in display_close via dev_dbg
Date: Wed, 18 Nov 2026 15:32:54 +0100
Message-ID: <20261118150022.115656584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -497,16 +497,12 @@ MODULE_PARM_DESC(pad_thresh, "Threshold
 
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
@@ -582,7 +578,6 @@ static int display_close(struct inode *i
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
-		dev_dbg(ictx->dev, "display port closed\n");
 	}
 
 	mutex_unlock(&ictx->lock);


