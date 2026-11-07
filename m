Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064883;
	b=HYqDM4IcVlVMoz8Re7HtVEAfuMvfKdWLN5prxNB0U2pm9SJoGJMc8Ia40jvq978/QtHD
	 KfKiMQC9DMR3q/R126yrLSq6yyZsHtVaSVT2bfBaaKL2c3J3CzjNRtGgUCYlLfJo+nCdj
	 hrcNr+UNXC8a/uj8QJxmuOgQcCVvYYp9AmaOD45A8lzS8D9pyVYvxD8xrpY8dEkdEOh+j
	 5P4GGSwzEZpRaJgiXAVVj8v5Tj851sFT/jLiTfvEXOEugCIQsiTRbEej551mGAAzIrSUe
	 wx0ifMe9yzuMiDYURmHW/lIj+WzlUF3SGsgK6mev++DAV6z0UdpO2ZmneNa86uz6oWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ocNq6GBm0W7yOzCDNPHw7triwCzrfAVmpNcHNacpOfg=;
	b=ebLQVMJ0jxzFA8JuFI3Rf6sWLlrXVCVP1ZLYa2azlWYj95CA7zW1ThcPsoX5iUVFQH6s
	 f5aoB1bGI+5t0oZBT7UDnT1LIrQy1p8j4TJYGxeo9Wx08oPFqG/RzzduPLbqwWbT3IQYB
	 z8/pTx990dgFSR93hiE39a2+QxpQT+B8jaLNXTb9yF1Wz/GyH7BtV7l+7CkmF5AfZ2zeG
	 FSIhonqH6syDQkaGTX1BE3Ym/05U4v7P3XhpSireJhDgzcTV92Au18Wg5npZgXVf1FkcG
	 Rk+WstSKaETrGr9gl1Rk6DJKO4q3Uxnaf4831UTQbpvHQoTtCVDPd+TJyFmvyIReAOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncoB7wLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FFA606CE5E;
	Sat,  7 Nov 2026 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncoB7wLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77291F0089F;
	Sat,  7 Nov 2026 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064882;
	bh=ocNq6GBm0W7yOzCDNPHw7triwCzrfAVmpNcHNacpOfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncoB7wLbu/DujPIc1nEouWSfz3+jdtIPX/TYSHc62PTS4QsE1uEZuI7SKUKGZs80F
	 lcavhf0kgJy/0N/YVB1kgFx0jAw62osS7UhSIWRwx9Gg/nIww/mls01oloLVNh19Dq
	 xiYu4+J1VeenmLRxDooAnrFtve3iwq3bbrcz80OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0757/1257] serial: pmac_zilog: push received data to the port that received it
Date: Sat,  7 Nov 2026 08:50:53 -0500
Message-ID: <20261107135000.194268897@linuxfoundation.org>
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

From: Tim Douglas <me@timdoug.com>

[ Upstream commit f3dc727da3af64abc12b625bbf1eb68d55d882cc ]

pmz_interrupt() drains both channels but, since commit 2e124b4a390c
("TTY: switch tty_flip_buffer_push"), pushes the flip buffer of the
port whose handler is running rather than the port that was drained.
With both ports open, data received on the other port can be left in
its flip buffer until something else pushes it, so its reader may not
see it.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-2-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index e3a9193286954..f49d6052d11be 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -444,7 +444,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	uart_port_unlock(&uap_a->port);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -469,7 +469,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	uart_port_unlock(&uap_b->port);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0



