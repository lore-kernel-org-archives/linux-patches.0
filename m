Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035821;
	b=S2cxmTFRvMSk8Qd8ylksd3hXCffX6aqGiVMzVl7WfJhZXdZvA3ZrR4l7yKRuu4mOIoMb
	 IJyIPDUBTFiq2B5xPtB+L0eZi9L1GAbReCKBa2D/xM6aVv/ozl6BOT7slypv8VYr35phQ
	 ULzXJFO1OxXIed7qzxzohSIIEV40MZYd3crmsGv9MEwFtJVAajnfl4wvsTEEYJBWT7dgd
	 5lXIXZU7Vmpd9rmSUTDU55+BHat3U/gCjcihlcjAw81J/W6/1Uu5EHephPstwKh5ejiPt
	 oj+7S58vKnZn90UJTQ4/YA62AmlFmy1t8hf+Bgb95HMuBui21j5tcSMkeS13tV++AnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/agb8ji9zuHhLNADyfw8pOctEg6e75SJIevDqAsgarU=;
	b=VPO7xlcwV0/bk/UcbhWkc4lTBMxnoc0KTdiz4ycZJOqxYk3oDsv30HQZAtZ1fc+mLnlj
	 SAH05Wo26/eTXxK5cdDQXiFgjozYZWbHJb4FIATJngidceuiKHRhybCKVRUdJxFz2rjCQ
	 4CYQXPIPRepZ6i9A45vYsIl/9ZZRl4xakMaWh7joMXLqtAZjQqhQkpqkl0kJy5sl9P8cq
	 2OM4xqHc8l49C4M+Za6DbjOPZ+5PxCX7Bub3OyjnPsZpnE5IJ1Zwssc56AW9uIP33q0+p
	 /FbiS8vNPx1DIFkHTGEMTJwVPezKXuMXSRbv71zP0f9OdVRNN5F9Sq7+q4f61PPwzyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dz6RSOOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D7606A31C;
	Wed, 18 Nov 2026 21:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dz6RSOOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB601F000C4;
	Wed, 18 Nov 2026 21:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035821;
	bh=/agb8ji9zuHhLNADyfw8pOctEg6e75SJIevDqAsgarU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dz6RSOOs3W8Gy1mr8Ywpp/HFEEwNYH/03eI9fsx7qeaZGlRQYzzIISIfO9MADUvVo
	 PoSA7O9jc2PhDB3E5/bTox35AVtl9C8hoI+XABMwdY7kILFIQebT3hFDcXbMQfryq0
	 TDXD6mR9YcJM8ZzLQCT/icTQy/nMw2V8Vh/vgkUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0832/3318] media: au0828: Free URBs when starting DVB streaming fails
Date: Wed, 18 Nov 2026 15:24:14 +0100
Message-ID: <20261118150344.087153672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 425d73fc2233f..f2e8e79314bb7 100644
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



