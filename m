Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623550;
	b=ZMSnCck5zPfYRXJSXWZWVeW361dO/S4b4nCfkSLTr/sGBR6qBNTgH1c5UYK/RwsgcG2X
	 5Se//1cXPqmHsCT/kpmI5MxhMDYL97nPd5DFg0GjYJDuUl0ihhXZfJY3qk1Kw82xb8xr1
	 ZaYQdqX1u7muBn8mLQIVwEORhjnQx0zBEpY4IR3oa+1BKvzDcIuehEc/2hjxIgctlcSUs
	 QQKkOuOCs8NlTCuB6NDzpewLRjDZtxhqp+pikaLSDM4EfP/6uSZvefgX/6OSI8LZA2LXJ
	 R0NP1qYZz1c5ra4EVHzpemqvlZCYWhGpQi8E+ASejrR0hpimcOHJ7JkvuH8UImH0wQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2dJLC95b30rBtFgJSK/zwo8MXsYbvV3zqks3RbYNaBg=;
	b=O2BBK7lh04elUlkar8Nwu3+7nuvrphb/smVd/yBvFsFTVUROT4XTZA8y1eGLBVCxnWU6
	 RR3KsHe1i276HWMGccDgHxqO6XZJZb5deX39ParwEP7cxKEeEgHFJbxYdjFDZ63y7DvQ7
	 tSrohZRIEmFGjICoa70kbhzkniG7/o0CXzfGsiToPhlgZlWgWp4Qw3P2hUQVCHmvX4zez
	 6dIRoqWLOKVtSmIHnmvjpLNxYnfTZa+ztN6HvEqUxADDCQsz+JxNTAJHfcbmuSVj9z+et
	 1djIIRZLeMZT9kGPNx3CNgkqTAQQrIE8FQMK0GdJdmugDGREn8IZMqrRTAI8g6Zew8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1oEHGHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F6606A31E;
	Wed, 25 Nov 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1oEHGHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E21F000CF;
	Wed, 25 Nov 2026 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623549;
	bh=2dJLC95b30rBtFgJSK/zwo8MXsYbvV3zqks3RbYNaBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1oEHGHHr22qoTv/eGWzxwfn6mQU1ZNA3QRSrYX1p7zDYyVGgmbO9IyfizKyj6HTb
	 uNcOW8CVmclxBXWCpOVoeOBaAlFYYqw/tnYTo3EH6iOg0YKuLEkoFwHXY0rsMMvucV
	 EHmIBzex4T189gKO4QZe3ipDexk3l6KojLrvFeXo=
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
Subject: [PATCH 6.18 897/990] serial: samsung: dont leak the tty on an RX IRQ
Date: Wed, 25 Nov 2026 15:37:44 +0100
Message-ID: <20261125143843.023925732@linuxfoundation.org>
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


