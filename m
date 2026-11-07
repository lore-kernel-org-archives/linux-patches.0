Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061527;
	b=pT3wmzUBa0Bj4TlKx8KzmCbGwjGMkr6FcUtNKfzIP3VgqkQDQ5cz2udbzqKEN9urNtLi
	 +sLoZDdwKpqYmNyfEHHT0LOyt3sjsGgZbBYUS57DnbZcBjDdXlxbGdA11wTaPa4yG+/Go
	 UYOt0yn3YQRIbCTPYVWCfayJXPiCIaVXiFzRusX/bg0ctVopOHZrcAVApQVxiYhHkcre5
	 8GRBOksYmmeFr7iV8Rl8dz9b+2XdOb1ReIMExFZD7KS5mrTIis9IejfqqVMTz/k3afrO5
	 qHWT51yRFZAE8nfrVZLh6B6K0hbnUDB5PLeDlzVInWIl47xXfO9xFwfLB++ka2FekYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rveA9HES3itPzhOdVep/18PpauqYotqxEuVKCU2sX8Y=;
	b=OD8+wy2jRU0r4osQvPuANYLk5OAiff6dweTboqaAM81ihwdGEzAmTBukZiMnlZpPCavk
	 FbbFuovIDo6C6S182JjVvJR2L+aiA9tN8NCQ/ufSbiIpXnvQzGeYihqUyRzTd4S1n//D2
	 mcq5YHxRMohDWE9FWu+Kw4K4v2jrP9YbrVJrYQOTwFxWXV3k+OWWk3IQ8ANLyzKhUfBBv
	 VsxqM8DtUJQK8q+gwUXUi+4T2yV//0tEMeaSTRlVNX8XFsba7nyZ+P+YBkAe3tNzGvwIf
	 fkIgI9qQzNHYBnHnULO9arQ4lteoxvLAfPdSekf5QbN2kfxNcKYqnSevZ5pdIj04Fjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emTbPYPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C114B606A326;
	Sat,  7 Nov 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emTbPYPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AC71F0089F;
	Sat,  7 Nov 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061526;
	bh=rveA9HES3itPzhOdVep/18PpauqYotqxEuVKCU2sX8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emTbPYPLTqsTik/8e0iDj+8YW983C2g31tp/BkWwJb4gKqeGt9TvI5mfNruIf1VS8
	 Hwu5JhUP2qCZAegXUZpT8Pl2aoS8FRtHz1hcrw1UZ6Geehq3E3aw8butsdBlr1EMXn
	 unf5C20HXgow99G1QRgffU5nmDii0AwubnEXpOjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.12 0613/1536] media: imon: fix use-after-free in display_close via dev_dbg
Date: Sat,  7 Nov 2026 08:43:49 -0500
Message-ID: <20261107135014.753692064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


