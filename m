Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831508;
	b=iXfDrjAuwaRtmzwikuOk0S8bd03FONF7Q6cNqBrWQEnbHxbcjl+oI5hid8hdtjlIPzXc
	 6dYaQMXpSiqD7MtQBiymm3tPxC+4IVZyJrdhNaw99dt6jSvXCekiJ4IzzZuxWgy/J39s0
	 N1ifXCSnIHfwI/37dcjU7jz9JPLIIQ9ojRl7Ifo2kZgxqmgXyKA1KSydeGnAPTKoPzX4j
	 BN/1a0Kz8rpxRUPRAiy9vS/7DIyjVCF3+A2d2bJKLBBZY0rGCzSAx4jHfT/3+FAHLukTv
	 1zTD8jqnUKh9A/fHafjwOuE+kZwVnt9NsGDtArQvyE8JbrlML2mtII3ejZQY1AuCKNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCZSUgCisNmB8bhdfcm0U7nok6TPhyEJnEYqsGe33Oc=;
	b=qFmwwdMjMxL5sTItnpgD0HVmZqXObrMuLbTfqAZ3ccjm+yZOknn1SGVPcpy5NomFd+9Y
	 EooL4fPGm1o0TnqHyPVaevOUATFhWBiZnBpOIrU83lBYkr7noGtOGiRpcaV9bsklzQ9cA
	 wb3wE/YpVoEl5qqk1c5KB48BcCyZdC2KrayzAzgcMgV7hUv5iLeopDz66gLPq9jHwtkB4
	 7RwN9oUtQ5LF4wSEaE7+So0b+No3ETQrGPJFb7iCzipUqtbIN94wu9+A0OUNylRIzL+cr
	 hwcvOio/vr2RCwHM8l3P1X3hGUHO6PbQOF9OQaXltz75arFfPm8oc4M/9DxAmxSO9uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xChGdbXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8133E606D81C;
	Wed,  4 Nov 2026 22:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xChGdbXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4B51F00919;
	Wed,  4 Nov 2026 22:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831508;
	bh=wCZSUgCisNmB8bhdfcm0U7nok6TPhyEJnEYqsGe33Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xChGdbXD8nVjAlOCn1pchg359cCMSLJ6WLtxMQlQdSIh30zxEAtFEpsSJMMovRq4M
	 2B4xFxSn704doWFFMvHCpEW8hKYoZnXJnnGRVczvWsPLQP+j8AksdhttK+Hv6a3s/N
	 8dWQwwwN/IoIeHDDqO7jTHr4GrE6F8+sgXrRr1Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.18 0745/1005] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed,  4 Nov 2026 16:07:58 -0500
Message-ID: <20261104211104.336192908@linuxfoundation.org>
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

From: Weigang He <geoffreyhe2@gmail.com>

commit d1febef1bcfa7bbc401729f994c375b91a833911 upstream.

fintek_get_rx_ir_data() drains the CIR RX FIFO into fintek->buf[], which
holds RX_BUF_LEN (32) bytes, for as long as CIR_STATUS reports pending
RX data:

	do {
		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
		...
		fintek->buf[fintek->pkts] = sample;
		fintek->pkts++;
		...
	} while (status & rx_irqs);

Nothing bounds fintek->pkts. If the hardware reports data for more than
RX_BUF_LEN reads in one interrupt, the loop writes past the end of
buf[], starting with the pkts counter that follows it in struct
fintek_dev.

Hand a full buffer to fintek_process_rx_ir_data(), which parses the
samples and resets fintek->pkts, before storing the next sample. This
keeps the parser state consistent and drops no samples. The loop still
relies on the status register to terminate.

The driver does not document the hardware FIFO depth, so it is not
known whether a working device can trigger this.

Found by static analysis tool CodeQL.

Fixes: 9bdc79ea07d9 ("[media] fintek-cir: new driver for Fintek LPC SuperIO CIR function")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/fintek-cir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -340,6 +340,10 @@ static void fintek_get_rx_ir_data(struct
 		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
 		fit_dbg("%s: sample: 0x%02x", __func__, sample);
 
+		/* Process a full buffer before storing the next sample. */
+		if (fintek->pkts >= RX_BUF_LEN)
+			fintek_process_rx_ir_data(fintek);
+
 		fintek->buf[fintek->pkts] = sample;
 		fintek->pkts++;
 


