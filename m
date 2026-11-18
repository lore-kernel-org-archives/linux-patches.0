Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044612;
	b=2bLcybAxpUbi5/VtDGZYYkV8EiAAIlcJKvPS+Pbx1eBJI8q0ucDu4GcsLXCDye1b6eTu
	 8TlRiBxlBEBUKQlp6IxW81ht2qEDRxpQTvLXWB7vcCbCpzo39WrJBaCnVc+eTsRflgDBX
	 VKlV63mmOi8R6bP5WgKkZOA6OR4cr2U0EIb5fftR9Qgti2rrrExSkj77WZhSqmauHxbK1
	 nmWTyUwlHIFfinnQcnf7OTPNxac0clgtDXzLp0YOJL8LQV+7kaVmlEdTrHuhlPeo39MYH
	 0YcaIRPNKhe3GoULOz9h+tFBnkpqRTUzyWABN2zUB5lwKRLtDoaQFliAiuAx8iYk9bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFxg+0cQhd85QDQQ/1P0mL9nYYOn2kjaOjGJbbc4rKw=;
	b=x8z8FXwm079SUF+/VthWDTwozVnot/YL8Ji+awC9y9K9rsoU3fUHvtrT9cg994EIKOE3
	 3xXAXk1OjOCMjWghX/5Cz1letBjVacO/lYLNS0CmbRb4x3a0M9q0irBzZkO3D0kVm0VXc
	 QDBl2gpMhODkifzUIN7pEf97BUkaIRHln4V72vmLKCydQ7eGbcVnAj5cOOsjZnA9ttd8m
	 Gom6GB0x8GHzzQZRJZwSQj3tiIkQYxU4SVOT6Py1mNpUztjRTcRI7J/TSPrhQNjMEaiHo
	 +XezisJhbuL11VvKzauiwwhdUPyS+nOEn0H0rOV/NxlTq56gspQaUBsasD5gOLezNMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ul/+dxwc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38BF606A32A;
	Wed, 18 Nov 2026 23:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ul/+dxwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EDF1F000C4;
	Wed, 18 Nov 2026 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044611;
	bh=UFxg+0cQhd85QDQQ/1P0mL9nYYOn2kjaOjGJbbc4rKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ul/+dxwcX55j9nAtZU/sd8aB8rI2PKm5HAAjQ1N2ytbAUUrMn5OB8JETY7iue+aVZ
	 XlgESvkjLlDyC/D2TBmeWZ/k1vqgAPAOIRuGzDJmYDZeSZXpFrZ3VJmqhE7vLDRMp9
	 fq+38RvMKxyYLIGjcJjBaVtSJA6DnG3qpWZNoEfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.1 0569/2857] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed, 18 Nov 2026 15:26:43 +0100
Message-ID: <20261118150221.974071305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
 


