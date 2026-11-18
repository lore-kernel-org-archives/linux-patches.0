Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051747;
	b=tgWGAts6b0iY/EYieU8VttRMWD2yEFIt7D487XRQL9LgCEE4NDjWBHFxfVyFuXxJclw5
	 1RmD5FMVRvKmpelbScoL8PDg31ry0O28uUaNhtYg6QznVrSeRT2ekw3WqdfGgprUPFsZE
	 WBivApOawlx2mIfvfXqp99kWxLjcaay6ic6KXMfd3R0I7kBJMlVfqNTHphHIRg5oQrQj7
	 3hj8LPTNCdGpde6kkaN8PWeeTdNCXm5KDdaGqLODITV1v/Y2YCKKk81dIUBKxQsZyjrQw
	 oa492snqzihpqASwmjn35sUnvGB21r66kLOXALVnok2BMuI7PudkwcgqlwBGpS0NzFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N45vI9o9ZpFpElO53HjlHF7GIUhCeuK0aaKaTNmiR1Q=;
	b=pb+cM/DrK7QwBKr1BR12jqoDsPP13WcGhRKJoSYJ1nIf+Ek+jH+kR68XwQxsWD3k81Di
	 PT6mQM78ZAiH9M90XGzcaq1Vtz4MagUFzzd7+KVP5yWyaFcU1/rPxlISfZ37WJ+XUuWsN
	 5t899Zeew8GO8TYa1rFrpUzNKtKMYXpgiItqZczHBtT7DaGX2/LN3ehpDq7OylkCdAKVs
	 EugyQeXIqvvSITQBX+QtM0HRB0yAHz5Cfdhdm5xJEf+n5PAe6vQE4b+8WRfMEOuoxxOPZ
	 U81PrwVhr6zf5oP8eKW5P15w1jOWe+tIsw4Qby/BKXxgoLJGN7fSa1+4shT4J6rz5uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6izOe1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DAC606A31C;
	Thu, 19 Nov 2026 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6izOe1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AF61F000C5;
	Thu, 19 Nov 2026 01:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051747;
	bh=N45vI9o9ZpFpElO53HjlHF7GIUhCeuK0aaKaTNmiR1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6izOe1EMvU7i6ZQ0/ECr4YoB9xrYYpOhin4pGXkzz//mICw1pCDiDps8HXlqQfEC
	 fBtD7+PxG6SXjxVQa+r+UBsyOpnKjY5V8VhTg+jdi61BDqQWMtvInd+rLXUFG80k+v
	 G61Hm8A7hZY8lhrdv9nCF29lEcjpiZMBIWm9TrFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 5.15 0319/2214] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed, 18 Nov 2026 15:33:15 +0100
Message-ID: <20261118150022.984364783@linuxfoundation.org>
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
 


