Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064612;
	b=KOGQLhH8KVAFGkGshCC0+ZBJw0173hgN++zz7yHuQIK4eYQtFO66jnyv7dzPsVdP56sw
	 z7nto3uw07ULosO3axPOuZWxHLUVfcGlawiUKapRNFt/DWovwPdyvPiiSjvMg+Nse3+1t
	 H0cXps30NpvSftDqmM59e9VQvf/COGFdbe8jY7Tmn6ZTvEQ/dxfgxbcfXTzjxWTMYjgpy
	 tAhEmht569wRPgtktD3oKYKU1EY8XltI5As2NSRXQ1pDJaXpLsa5BQ2hkwq18A9SexoiD
	 Vnp/otFRu9EBaTi1joXnWXTC8H+I27vExrENT2zyvGOZ8oL/zK/QC/MSj3LC9hQhk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1USSPQctGoLFhdR+coFb72twaRlt/Zd5f8TzSyOgwg=;
	b=uQwMWuz0xbL/OV3LbDmgi3B2Mm5ZCY+HnRF+xvzvk1zNH04t/vIKf9DYsOtR4orjagP/
	 P/tBabdzgAgQAWZiAhUg1hhOtpPuubDIbhAkUmzYXMYWKZRd985+hNUtrvQmdA0CI/LoW
	 IKrdZ5jLrQSnjcU82ngG1yNXA244CyaQHCH74pptTX21CvIGC89GtpRqdOU9i2f3qxb2b
	 bOFubQEVptcB5aTvlRW93GSyThvb/Vi+8+UUgRf1y/IQSc6BqSyOc6MyHTuN10Zch28s6
	 q4WBLbwWJJCt0DuaVERBpNySQ9mYvaPG4m278VwJqw8pW+aXZSsGLBjJg+evzS25SNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0rXMNWG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69810606EE88;
	Sat,  7 Nov 2026 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0rXMNWG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2821F0089F;
	Sat,  7 Nov 2026 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064612;
	bh=l1USSPQctGoLFhdR+coFb72twaRlt/Zd5f8TzSyOgwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0rXMNWG7Pgev5bKqQMwApsXs1hn8NxhWr1DyWKcwG9QMlO2DxFfET/RUumXn8jNq
	 TlmEdKcRDAMmdrnph1BRtGe5xb1rMYK3NPfGicx92LOjGJdtFbeTthw/QXJho7Sjke
	 dsQI9SvwRyBqNotu8jNV62ejPR4wQuwBMqe78SSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Orgad Shaneh <orgads@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0622/1257] usb: octeon-hcd: release the USB block when initialization fails
Date: Sat,  7 Nov 2026 08:48:38 -0500
Message-ID: <20261107134956.477782427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit b8c063059f304abebc11039195f5b28298aeddbb ]

cvmx_usb_initialize() gets as far as selecting the reference clock,
enabling USBN_CLK_CTL and taking the PHY out of reset (steps 2b-2e)
before anything can go wrong, and its only caller frees the HCD and
returns without touching the hardware. Both of its error returns
therefore leave the USB block clocked and out of reset on a failed
probe.

Release it on the way out with cvmx_usb_shutdown(), which is the undo
the retry path a few lines above already uses. It cannot refuse with
-EBUSY here: the pipe lists it checks are initialised by
octeon_usb_probe() before cvmx_usb_initialize() is called, and no pipe
can have been opened yet.

Fixes: 22bce6d2b3fd ("usb: octeon-hcd: fail the probe when the USB core does not respond")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Link: https://patch.msgid.link/20261011072238.2381564-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/octeon-hcd.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/octeon-hcd.c b/drivers/usb/host/octeon-hcd.c
index 256e459ff6d8d..4d6558e5492c2 100644
--- a/drivers/usb/host/octeon-hcd.c
+++ b/drivers/usb/host/octeon-hcd.c
@@ -708,6 +708,7 @@ static int cvmx_usb_initialize(struct device *dev,
 	int channel;
 	int divisor;
 	int retries = 0;
+	int status;
 	union cvmx_usbcx_hcfg usbcx_hcfg;
 	union cvmx_usbnx_clk_ctl usbn_clk_ctl;
 	union cvmx_usbcx_gintsts usbc_gintsts;
@@ -872,7 +873,8 @@ static int cvmx_usb_initialize(struct device *dev,
 	if (usbcx_gahbcfg.u32 == 0xffffffff || usbcx_gahbcfg.u32 == 0) {
 		dev_err(dev, "USB core is not responding (GHWCFG3=0x%08x)\n",
 			usbcx_gahbcfg.u32);
-		return -ENODEV;
+		status = -ENODEV;
+		goto err_shutdown;
 	}
 
 	usbcx_gahbcfg.u32 = 0;
@@ -961,14 +963,27 @@ static int cvmx_usb_initialize(struct device *dev,
 	dev_dbg(dev, "gintsts after reset: 0x%x\n", (int)usbc_gintsts.u32);
 	if (!usbc_gintsts.s.disconnint && !usbc_gintsts.s.prtint)
 		return 0;
-	if (retries++ >= 5)
-		return -EAGAIN;
+	if (retries++ >= 5) {
+		status = -EAGAIN;
+		goto err_shutdown;
+	}
 	dev_info(dev, "controller reset failed (gintsts=0x%x) - retrying\n",
 		 (int)usbc_gintsts.u32);
 	msleep(50);
 	cvmx_usb_shutdown(usb);
 	msleep(50);
 	goto retry;
+
+err_shutdown:
+	/*
+	 * Steps 2b-2e above selected the reference clock, enabled
+	 * USBN_CLK_CTL and took the PHY out of reset, and the caller only
+	 * frees the HCD, so hand the block back before giving up. The pipe
+	 * lists cvmx_usb_shutdown() checks are initialised by the caller
+	 * before it gets here, so it cannot refuse with -EBUSY.
+	 */
+	cvmx_usb_shutdown(usb);
+	return status;
 }
 
 /**
-- 
2.53.0



