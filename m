Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214714;
	b=fM11MRM1V5oOx4KdXzfN23wqI2a+0pYCIZg9ttXezFZFNBw2yB9ZRm5prnPXj41eE1db
	 A6ycaCNvpWsVFH8ub+RyeFqwz2n3hZjpbNszRGNYoP46UAnBRXC9iviooMsQ+jl12JjoM
	 tj3S1CzHRAykQ/rQ0h08+xZKv0DJJMrPdC9VucRJpOlN9Bwnezm4VBJB7LOK/LdWulVnm
	 1SjdLP4gaSLs5KdUVltrP8k1/6CvSnH3e1wwQvBdWaz++qNrhGtJtjyEfK/iOWG7dx4Kv
	 2fCxAVVvklsKSeVBraPNdX18B5Xhd+ta5Yub5QBpRFZ1U95EZa3l9olkJc/zr+qxEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T3U30xPKUbGP1El/1YlwlB08oLvnaMQJ0TWHWnWl8x8=;
	b=1F26/0l87dtTlsCrr9snRtQT1nyWNXOzRBWoKPnbH8xCzL5fh9nlGzawIWt+uH1qc8fN
	 mGyM9/Mluy6AWjQGydmItH0rftIl8pbOPqdrG038xrMF08kkbxiIkX3e+u/tlZFHk2gSp
	 buMx0TCnkEJVP6St7QV5v7i9tI5QJWcrC1rZjiQhU62dujv2BF+kGbf1NY9/CMe1yme3v
	 TfQ1hFvKrwOLfWjMy+zZpI5YPx0qliRN3FpkLyLHAakMa8t70+bEoO5WuqOoX1Lrho0yT
	 kWxthVkHJ9TdvKk4GsXmRERr0L2r23IENxUG8rnukNIbjmvoA9KQLoVZzbW+XNj/WhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlDsHkol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE160A2609;
	Wed, 28 Oct 2026 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlDsHkol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8251F01828;
	Wed, 28 Oct 2026 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214714;
	bh=T3U30xPKUbGP1El/1YlwlB08oLvnaMQJ0TWHWnWl8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlDsHkolXl7wInC60VmsESYlj6KCyYMLqxM1uSRzkuMmOrwwcX1scIs03GK7jEpRy
	 GBg8e7a8anNL/rVVn4rHqNlc49TlHps1LrGz3zMvX5JAaTTE90Pf36yvhHquQScFEV
	 fBzp4WBBFsmdnDpAXfPEkkG5RzwymzgKZkOTLu1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0957/1887] usb: gadget: f_hid: dont call cdev_init while cdev in use
Date: Wed, 28 Oct 2026 17:50:53 +0100
Message-ID: <20261028170521.184305364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zimmermann <sigmaepsilon92@gmail.com>

[ Upstream commit 81ebd43cc0d6d106ce7b6ccbf7b5e40ca7f5503d ]

When calling unbind, then bind again, cdev_init reinitialized the cdev,
even though there may still be references to it. That's the case when
the /dev/hidg* device is still opened. This obviously unsafe behavior
like oopes.

This fixes this by using cdev_alloc to put the cdev on the heap. That
way, we can simply allocate a new one in hidg_bind.

Closes: https://lore.kernel.org/linux-usb/CAN9vWDKZn0Ts5JyV2_xcAmbnBEi0znMLg_USMFrShRryXrgWGQ@mail.gmail.com/T/#m2cb0dba3633b67b2a679c98499508267d1508881
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Zimmermann <sigmaepsilon92@gmail.com>
Link: https://patch.msgid.link/20260327192209.59945-1-sigmaepsilon92@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index a3e79121d9eb0..6d12e30f820d0 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -72,7 +72,7 @@ struct f_hidg {
 	struct usb_request		*req;
 
 	struct device			dev;
-	struct cdev			cdev;
+	struct cdev			*cdev;
 	struct usb_function		func;
 
 	struct usb_ep			*in_ep;
@@ -554,8 +554,9 @@ static int f_hidg_release(struct inode *inode, struct file *fd)
 
 static int f_hidg_open(struct inode *inode, struct file *fd)
 {
+	struct kobject *parent = inode->i_cdev->kobj.parent;
 	struct f_hidg *hidg =
-		container_of(inode->i_cdev, struct f_hidg, cdev);
+		container_of(parent, struct f_hidg, dev.kobj);
 
 	fd->private_data = hidg;
 
@@ -1000,8 +1001,14 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	hidg->req = NULL;
 
 	/* create char device */
-	cdev_init(&hidg->cdev, &f_hidg_fops);
-	status = cdev_device_add(&hidg->cdev, &hidg->dev);
+	hidg->cdev = cdev_alloc();
+	if (!hidg->cdev) {
+		status = -ENOMEM;
+		goto fail_free_descs;
+	}
+	hidg->cdev->ops = &f_hidg_fops;
+
+	status = cdev_device_add(hidg->cdev, &hidg->dev);
 	if (status)
 		goto fail_free_descs;
 
@@ -1246,7 +1253,7 @@ static void hidg_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_hidg *hidg = func_to_hidg(f);
 
-	cdev_device_del(&hidg->cdev, &hidg->dev);
+	cdev_device_del(hidg->cdev, &hidg->dev);
 
 	usb_free_all_descriptors(f);
 }
-- 
2.53.0



