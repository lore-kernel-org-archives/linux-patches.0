Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620415;
	b=LeBcOBNE1/Bq733+8FRgOtf0LA/+VPqVFBvzrIOi4TlvCAvBP/IO5vrc/A4mPir8f1s6
	 RqKUO0kus9D6dEH311dVS2VIfRfPckHERj+lrHhf3uGb/O977nZ1npxmm0G1HzHHMxG4h
	 256zkK+zyFhH8fHSO2XpasDLfe5IR85EiIgyr2mhWpAZ6Tpe3DvQUI5irk+FMMLUNpgX9
	 uCn58p9oxskIr/PO7nfLKHGoZXQryvNFyjCNulPBbRVbrgpZWSgNTohCGe1WTfr09agWc
	 YB5++32+qzeRx+Oe1bi6beqDudDK0sHe6Q+EABz4XxtWuQtUWckAzT5p7Qbp00ouAAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBo7L9t3my2ztiIgPv9wUZ5f2zs5Hiy1RZCVjKdL48c=;
	b=bRm3vd605gZebcWD1dAWaFxPToZHeas7nGeQaooMFjceRxlXx32rrSwsZkVQ+BkaaUR2
	 O/xo+KnnpEAfkFcYjF2RxdCCpOjNt8+EyrY4x2tOeX3D65im6DRIajRkgDHhy1fEEBnH1
	 5fn8Zztl4wLM7v6QY/Z76F+mWNBfx90j/9eBwsQ4NVkG8yCLYipAexOkEZ9P8qVYMsdzF
	 st7E0/4qFey3X5aNPyRca1XklnrMZZLbI2wjeeXAJfmj0FHXc1rwW9T5SHoH8DnXAHilU
	 aPQIp1/tp9xiU3TcwT0tem9J1f/fHzL2tU6Xo/Ku0GW7e/OfnFLGr/MkHVARcloIz/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA7YmRXZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886B606A321;
	Wed, 25 Nov 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA7YmRXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F861F000C0;
	Wed, 25 Nov 2026 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620415;
	bh=sBo7L9t3my2ztiIgPv9wUZ5f2zs5Hiy1RZCVjKdL48c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA7YmRXZThvc33XRUtxMaY+pgtmFMQ7IXly8XNN+1frmBbWHiJNQH9PM2SrAM3ILU
	 qkIjjzanFbtFgYAlCJf2hpwTpX28TkDlPA2O5fgXfLFbQsh9K/eoays2auw75ewG8d
	 9q62ou9KDJ43klmURFE8aASaBHi37RSKie0tXoR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Robert Baldyga <r.baldyga@samsung.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0910/1005] serial: samsung: dont leak the tty on an RX IRQ
Date: Wed, 25 Nov 2026 15:37:28 +0100
Message-ID: <20261125143843.010667666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 7ada442f5ef77f8d53f608a0141a5e88a888ca9f upstream.

s3c24xx_serial_rx_chars_dma() starts by taking a reference to the tty.
If the interrupt is not a receive timeout, it switches the port from PIO
back to DMA and leaves through the "finish" label, which does not drop
the reference.

A port with RX DMA changes to PIO on every receive timeout, that is at
the end of every burst of data, and comes back this way when the next
burst starts.  So each burst takes a reference which is never dropped,
and the tty structure is not freed when the port is closed for the last
time.

Drop the reference on both paths.

Fixes: b543c301c2c5 ("serial: samsung: add DMA support for RX")
Cc: stable <stable@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-21-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -736,14 +736,13 @@ static irqreturn_t s3c24xx_serial_rx_cha
 
 	s3c24xx_serial_rx_drain_fifo(ourport);
 
-	if (tty) {
+	if (tty)
 		tty_flip_buffer_push(t);
-		tty_kref_put(tty);
-	}
 
 	wr_regl(port, S3C2410_UTRSTAT, S3C2410_UTRSTAT_TIMEOUT);
 
 finish:
+	tty_kref_put(tty);
 	uart_port_unlock(port);
 
 	return IRQ_HANDLED;


