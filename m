Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052153;
	b=dT1OFZ/OTytqCxHTVAxKL6Elyh9WHfcR7TV5t8jwRr+N+Q4WcXRdk6ENnTS0GxjbjDQ6
	 hRVzjgy+FdzuSKk5+s7RnZBrRXQvt1xxbwY8kF1cFqp4urXTNo0yISJ9emsshCrpXahBY
	 jxdVkTj2BO+usRxwUjfiKyMEqLqPT75Ts/djrOe9o5+7D+5CMVE637C9U61IRBHs/uPCe
	 2F1fgH4anEhBOPNml1PZa4TCIV2xYvi1IeT5GtSfwYbuTRExvgBpGO51WitCbTqKpEX2r
	 koRqgSm11zvsy7vxxsWVzXSa2WiyPH2ICavF7gznaBLveiQxhK8gFU5FOsNxjKKyc0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/qqaTFgnjI1L4uDpMiAuW5PEXSQJz1K/I5dTCNMJtA=;
	b=jKH6L4hOblSy7EXzW+B+cJioest/dpv4BIIsVZz81RZ5l5A8Q2iAOVkMDlq/MPiyqWwX
	 CoHze6TxY/hGzFjJiL4gGFVboaN9NvDxXapNaBG4Ad9xmuNoORPHE/WuA08tKSg/b8rmG
	 c4wmQj1YpkGV7a8DIQY8s+Z4ERDqKHml3eY3ACGTRAzo2CD1doJztkiqtDXdDTkCWgyba
	 finGbotR+xK3nKM+CLYzFbDclf9iymq19K9EmpzCJSvKVsstJ9yAN9zzltd7Hif7WP4Vi
	 CI3I//vWpbrdM3Eyi0ajX+PIOOJ+l/0Vzmbfd49S2jJ0kSeKHiAGb0BZ9lNG6+BJoaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMUQDb4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442E606A31C;
	Thu, 19 Nov 2026 01:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMUQDb4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E3E1F000C4;
	Thu, 19 Nov 2026 01:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052152;
	bh=v/qqaTFgnjI1L4uDpMiAuW5PEXSQJz1K/I5dTCNMJtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMUQDb4ezyW/UJSsxDalUgvBWVDe7AoVItRPj0paSDSnZpkEoiv80SRxRKbH4YPVp
	 An28G/5fV77Zbv0J34WKjj9wG18QHPR6twhSeMjB/AxTFoswgO+l7EQmKjFmVG21v1
	 9hoe53Azh5GDNeNJl0d1p3Xoom8VURKKrzWuafYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0460/2214] media: au0828: Free URBs when starting DVB streaming fails
Date: Wed, 18 Nov 2026 15:35:36 +0100
Message-ID: <20261118150029.626573076@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit b8dd133d96a40012f4b67fd48d8ddd7306a3e024 ]

start_urb_transfer() stores each allocated URB in dev->urbs[], but sets
urb_streaming only after all URBs have been submitted. If a later URB or
transfer buffer allocation fails, earlier entries are left allocated. A
submission failure calls stop_urb_transfer(), but that function returns
immediately while urb_streaming is false, leaving both submitted and
unsubmitted URBs behind.

Make stop_urb_transfer() release every populated slot regardless of the
streaming flag and clear each slot after release. Route all start errors
through this cleanup. usb_kill_urb() safely handles both submitted and
unsubmitted URBs, while the existing preallocation check preserves the
lifetime of shared transfer buffers.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 265a6510629a ("V4L/DVB (7621): Add support for Hauppauge HVR950Q/HVR850/FusioHDTV7-USB")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-dvb.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index ead2fe0ed23bd..5d8436af8a695 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -163,9 +163,6 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 
 	dprintk(2, "%s()\n", __func__);
 
-	if (!dev->urb_streaming)
-		return 0;
-
 	if (dev->bulk_timeout_running == 1) {
 		dev->bulk_timeout_running = 0;
 		del_timer(&dev->bulk_timeout);
@@ -179,6 +176,7 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 				kfree(dev->urbs[i]->transfer_buffer);
 
 			usb_free_urb(dev->urbs[i]);
+			dev->urbs[i] = NULL;
 		}
 	}
 
@@ -200,8 +198,10 @@ static int start_urb_transfer(struct au0828_dev *dev)
 	for (i = 0; i < URB_COUNT; i++) {
 
 		dev->urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urbs[i])
-			return -ENOMEM;
+		if (!dev->urbs[i]) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		purb = dev->urbs[i];
 
@@ -217,7 +217,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 			ret = -ENOMEM;
 			pr_err("%s: failed big buffer allocation, err = %d\n",
 			       __func__, ret);
-			return ret;
+			goto err;
 		}
 
 		purb->status = -EINPROGRESS;
@@ -235,10 +235,9 @@ static int start_urb_transfer(struct au0828_dev *dev)
 	for (i = 0; i < URB_COUNT; i++) {
 		ret = usb_submit_urb(dev->urbs[i], GFP_ATOMIC);
 		if (ret != 0) {
-			stop_urb_transfer(dev);
 			pr_err("%s: failed urb submission, err = %d\n",
 			       __func__, ret);
-			return ret;
+			goto err;
 		}
 	}
 
@@ -249,6 +248,10 @@ static int start_urb_transfer(struct au0828_dev *dev)
 	dev->bulk_timeout_running = 1;
 
 	return 0;
+
+err:
+	stop_urb_transfer(dev);
+	return ret;
 }
 
 static void au0828_start_transport(struct au0828_dev *dev)
-- 
2.53.0



