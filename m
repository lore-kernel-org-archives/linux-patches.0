Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044125;
	b=f/9//4hIKQgnYBISgQpOAaxWevGU9C9DrtO9obvdQHaMdms8fEx3xiUIA2tbnxsg3FYV
	 lAObl112H6Ymuvgjvv7mhI2GWE3lTOMpK5ZUi7sJYFKIT0lKVznhqYhHxR25XDk93jpDY
	 TMf1y7cpKGpJfkPktxC8NrV7pj2MktRzTnkvZ+Tpo92oNlGsoxlEzf9/8PgClOyL0Oj6a
	 ns+lKRg7fz1bZLzK4Y73vovHfzplGrCR3B7/xJv0W3eGqTyg8GtxJaZQ9aapXIrtMLtFh
	 Rn3unCIaCcIUw+d8WmHk1sLnYbV3CqpGiLB7SO5RfIqZBBUaC4bgyispsAbEBInrCkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dh3Roembz+yXOXP7bRGM1lo4fSmfbXilcRG+WOxBUwQ=;
	b=NOCPTJZKueaOV+FzMuUtBJpRQrHcJ7nsAxdPRFdgy0hyuPpKI4ZxC8464FSEiczIe+3E
	 FjZz/6niwG+rQBZ7yWuvS7EboC1TMKuLNIDuhem10XBivJhmT6ldczEhLTV2HAQ1OV0MX
	 3nvL6AueyHPkmPYXase6nS3YrM8uyMB33KMFCbqrOqAxI8uZdxpRJN7D/hWtGYnI+Mghv
	 acubg/evh55M+hOhu+8jCAvpbs8BPgziAZJb/qHFN57y1dLcGwKWXVBSN6rrGhwdDnw+g
	 fYsaxILNX9r/LlasZKJXoHegiYIH66P5d2MBONxf7LIcSQy4SUhOCkmMHnFRSPmH+7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okPzxOMJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C5F606A32C;
	Wed, 18 Nov 2026 23:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okPzxOMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FC21F000C4;
	Wed, 18 Nov 2026 23:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044125;
	bh=dh3Roembz+yXOXP7bRGM1lo4fSmfbXilcRG+WOxBUwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okPzxOMJOvALudhR1n+zqP8x0tY7I3/5ElAywmEbVNHUMRVKXlG+RsE8XOEfAvAY3
	 Ui8j3bMBnvtbM4ZLnsOFn6UokD9JlkYPQyUoEaGu/8E9fCVMSWhUSX1hTv7E4g/ICa
	 qdEC0sccNc9pPR9P5ChQX2y3l1459fNf93+E4irA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0454/2857] serial: abort TIOCMIWAIT on hangup
Date: Wed, 18 Nov 2026 15:24:48 +0100
Message-ID: <20261118150217.769574352@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit eb35b73e133686e5b999eb7130c4e3d22fe03089 ]

Add the missing hangup check to the TIOCMIWAIT wait loop to avoid going
back to sleep (indefinitely) after being woken on hangup.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0efcebcd9991d..eda883862fcdf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1251,6 +1251,11 @@ static int uart_wait_modem_status(struct tty_struct *tty, struct uart_state *sta
 			break;
 		}
 
+		if (tty_io_error(tty)) {
+			ret = -EIO;
+			break;
+		}
+
 		schedule();
 
 		/* see if a signal did it */
-- 
2.53.0



