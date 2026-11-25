Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623617;
	b=QzeIDiZGy1RM9LFo2EjRy9+L1pdCUX6Ga6Z4ImrTFxr//62LJABTL0OdcQPuIYy1S9oe
	 55sliB28JgzQTzXgA/eL95yX1K4U38SlNEmKWWshAPep4Zm8T8mTFBtV/xLpTBPEURAN8
	 PFvZ3z151S+KKKXbTB1bnc9Xk8L89le/udd5aHiEgfQq20+Ln/LB7pvOCIR5Lc+/VP4dt
	 GZzhnhY2Ur7SDFgvyemPiKH3eSxLhiiN+HCmX9aP38gSolp/5so4Ha/IW2xDinnuniGsL
	 2u17RFyH+6MkvF4prQY00QY3tVYEee+jH9HmRmRRpanU5zqbrTKpybHbGYzzfNbtDkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOCSKdAYcSOjfsOCqvGqwe0D9RG2z7ENy3Dz5I8VcD8=;
	b=cXchKfywTfG0WEOKel9iGD+5iVETrPItdy8+nnPuv8+Et3zauR1r6tvjrTD10g5SJc76
	 RlFvcvJR8E3/n3/qS5x9pvimde306L5jTEhar/q9SnNM0/pkAXcF+KE8xZa4cZbUSA+5u
	 lY4cq3v+xYMsFsA2BnlFj7gcfSghIlaBPhcpZeHluHw+Fdw1gTAKQeBLA47k0t1hbwPaC
	 yNDm0vqTk8Oq0qPIPx+kKFk+EmJxnb09HFBlTVWRrWxrif8x3uxbT/dTcbKXTOV73aoiA
	 9Bx8cK1JSqIXp90aHxl3l/DOGo3psdFvnN8d41u05qzZr2cpT1IZVrgsBkwNAITFDHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r7Ny2nHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFEF606A321;
	Wed, 25 Nov 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r7Ny2nHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491E91F000D4;
	Wed, 25 Nov 2026 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623616;
	bh=GOCSKdAYcSOjfsOCqvGqwe0D9RG2z7ENy3Dz5I8VcD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7Ny2nHVKJSYESwd/GLyC0wE4qu+RltVAeHJLPty2dtxPb7Yg12K0itVkzRGA7weu
	 SnA0aIj6RM2BbVPmmEUjXJjjcBMicf53Em9dESYjWA3GvYJX0OTHVKA6Ya6ys5jn0h
	 4YKLScKY/yU+KM3UoK4qrz52lgmyowvGc/Uck5vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 916/990] usb: dwc3: gadget: Issue no-op Start Transfer only for stream endpoints
Date: Wed, 25 Nov 2026 15:38:03 +0100
Message-ID: <20261125143843.460671680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit e616d91e02881983e5dadf6980c4aa08123800b3 upstream.

The function driver may re-enable an endpoint before the End Transfer
command issued on ep disable completes. The no-op Start Transfer issued
on ep enable then fails with "No Resource".

Only stream endpoints need the no-op Start Transfer to initiate a
stream. Other bulk and interrupt endpoints start their transfer when a
request is queued. Skip it for those endpoints, and move it to a helper
to be reused.

Fixes: a97ea994605e ("usb: dwc3: gadget: offset Start Transfer latency for bulk EPs")
Cc: stable <stable@kernel.org>
Reported-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Closes: https://lore.kernel.org/linux-usb/20260227121236.963-1-selvarasu.g@samsung.com/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/227e97e30d26a017c92d7008a8633c01f955d088.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   97 +++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -906,6 +906,54 @@ static int dwc3_gadget_resize_tx_fifos(s
 	return 0;
 }
 
+static int dwc3_gadget_ep_start_noop_transfer(struct dwc3_ep *dep)
+{
+	struct dwc3_gadget_ep_cmd_params params;
+	struct dwc3		*dwc = dep->dwc;
+	struct dwc3_trb		*trb;
+	dma_addr_t		trb_dma;
+	u32			cmd;
+	int			ret;
+
+	memset(&params, 0, sizeof(params));
+	trb = &dep->trb_pool[0];
+	trb_dma = dwc3_trb_dma_offset(dep, trb);
+
+	params.param0 = upper_32_bits(trb_dma);
+	params.param1 = lower_32_bits(trb_dma);
+
+	cmd = DWC3_DEPCMD_STARTTRANSFER;
+
+	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * For streams, at start, there maybe a race where the host primes the
+	 * endpoint before the function driver queues a request to initiate a
+	 * stream. In that case, the controller will not see the prime to
+	 * generate the ERDY and start stream. To workaround this, issue a
+	 * no-op TRB as normal, but end it immediately. As a result, when the
+	 * function driver queues the request, the next START_TRANSFER command
+	 * will cause the controller to generate an ERDY to initiate the
+	 * stream.
+	 */
+	dwc3_stop_active_transfer(dep, false, true);
+
+	/*
+	 * All stream eps will reinitiate stream on NoStream rejection.
+	 *
+	 * However, if the controller is capable of TXF_FLUSH_BYPASS, then IN
+	 * direction endpoints will automatically restart the stream without
+	 * the driver initiation.
+	 */
+	if (!dep->direction ||
+	    !(dwc->hwparams.hwparams9 & DWC3_GHWPARAMS9_DEV_TXF_FLUSH_BYPASS))
+		dep->flags |= DWC3_EP_FORCE_RESTART_STREAM;
+
+	return 0;
+}
+
 /**
  * __dwc3_gadget_ep_enable - initializes a hw endpoint
  * @dep: endpoint to be initialized
@@ -971,55 +1019,10 @@ static int __dwc3_gadget_ep_enable(struc
 	 * Issue StartTransfer here with no-op TRB so we can always rely on No
 	 * Response Update Transfer command.
 	 */
-	if (usb_endpoint_xfer_bulk(desc) ||
-			usb_endpoint_xfer_int(desc)) {
-		struct dwc3_gadget_ep_cmd_params params;
-		struct dwc3_trb	*trb;
-		dma_addr_t trb_dma;
-		u32 cmd;
-
-		memset(&params, 0, sizeof(params));
-		trb = &dep->trb_pool[0];
-		trb_dma = dwc3_trb_dma_offset(dep, trb);
-
-		params.param0 = upper_32_bits(trb_dma);
-		params.param1 = lower_32_bits(trb_dma);
-
-		cmd = DWC3_DEPCMD_STARTTRANSFER;
-
-		ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	if (dep->stream_capable) {
+		ret = dwc3_gadget_ep_start_noop_transfer(dep);
 		if (ret < 0)
 			return ret;
-
-		if (dep->stream_capable) {
-			/*
-			 * For streams, at start, there maybe a race where the
-			 * host primes the endpoint before the function driver
-			 * queues a request to initiate a stream. In that case,
-			 * the controller will not see the prime to generate the
-			 * ERDY and start stream. To workaround this, issue a
-			 * no-op TRB as normal, but end it immediately. As a
-			 * result, when the function driver queues the request,
-			 * the next START_TRANSFER command will cause the
-			 * controller to generate an ERDY to initiate the
-			 * stream.
-			 */
-			dwc3_stop_active_transfer(dep, false, true);
-
-			/*
-			 * All stream eps will reinitiate stream on NoStream
-			 * rejection.
-			 *
-			 * However, if the controller is capable of
-			 * TXF_FLUSH_BYPASS, then IN direction endpoints will
-			 * automatically restart the stream without the driver
-			 * initiation.
-			 */
-			if (!dep->direction ||
-			    !(dwc->hwparams.hwparams9 &
-			      DWC3_GHWPARAMS9_DEV_TXF_FLUSH_BYPASS))
-				dep->flags |= DWC3_EP_FORCE_RESTART_STREAM;
-		}
 	}
 
 out:


