Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060675;
	b=Tx69OSPtJJfFaVtWNBISLvd9SS5ShxdCg1T1DEdQPu+6vpp7jl8qS0GPmP1X6GfYypgP
	 fmsqXQVYVf8O3wtK6C09xG0ZfjoBhubqaT2ntwxoFo6S7C3ZBzsLDHHg3Vv+0Izip0Rq+
	 L3wqQ1fuFvvZByx8CQOEJOWrui5vbCaQkfhYufZfDSMy2QKO2v0HJC+bjK2JwHGFlBp6M
	 mU6V9ti5F1z4cRsuXdTxH+4XH7Jjh5/rZ2R8jMQLbSKFIuzkm3AyUTUtJ37X8tNg3tCog
	 +d4AG97bRlG6WZXA7CHiUjzheo1E3q05PJH9CZ2uvCCdCYPGzp/FPECi3nD9YzYPH5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ivbit3SAc3bTmHKkyssr/OnOiZwAw9sh+4zYqqsvMJk=;
	b=RGHcTBerCkhqJvGcStJlkLjOF6037AHW8r6GuiMDVr1RcuV5k7fmICJpLukmNqqPlRrI
	 XGKXy3u6jRAIzKO/wQxJRJeXq4aQzG63v5hfBogPQwfAvXNXlzSQgOlNtGhvt29pvT55/
	 Yyj+aVbkV1klDFYFhe4DaJcJHDX8ChAUCXQb+YHx4W2A9hKX9o9M1iwJ89zS/jvfe1hyC
	 uGDC/nrlKnhRBNvN/qVYM30Uq+igFGhqZiiHNx1/AdvYylR7ByS7wcvSqNQ1Pxg7HrlKH
	 yJ18hZIn7AbfPce0VwlOCJq024c3F8wRrBtQFVxsJbImgHgldqqvdpL8P9Jghe5Z4uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTkccfDo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8961D606A32C;
	Sat,  7 Nov 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTkccfDo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBF41F0089F;
	Sat,  7 Nov 2026 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060675;
	bh=ivbit3SAc3bTmHKkyssr/OnOiZwAw9sh+4zYqqsvMJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTkccfDolevV9o74KDklndB85bcnsy3Ij5zIgPm0zusodKlO9xGbpzSaVSDUE+6Ps
	 Tq9zBj+5kDaDd6598NZDfsJJM/X8zCUVEW1pa7Xcw/gG1z2Rf+dMdZudAvv52adgHq
	 MGVW8e6B5OsDqTgYvXIH0BAEvCVkIBXil8pA9lLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Randive <aniket.randive@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0109/1536] serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout
Date: Sat,  7 Nov 2026 08:35:25 -0500
Message-ID: <20261107135000.735432793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aniket Randive <aniket.randive@oss.qualcomm.com>

[ Upstream commit acba38e675dd66f52925cb9edf9ed8db16335875 ]

During system power-off, systemd closes the console UART and blocks in
tty_wait_until_sent() waiting for pending TX completion before
uart_shutdown() can cancel pending TX operations. With the default
closing_wait of 30s, this causes a watchdog reset when systemd is
responsible for watchdog feeding.

Set closing_wait to ASYNC_CLOSING_WAIT_NONE in startup() for console
ports to bypass tty_wait_until_sent() on close, allowing uart_shutdown()
to cancel TX commands cleanly. This change doesn't impact regular ports
functionality.

Signed-off-by: Aniket Randive <aniket.randive@oss.qualcomm.com>
Link: https://patch.msgid.link/20260706093749.836121-1-aniket.randive@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index e02d988da16aa..e12be40ec4896 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1207,6 +1207,7 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 {
 	int ret;
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	struct tty_port *tport = &uport->state->port;
 
 	if (!port->setup) {
 		ret = qcom_geni_serial_port_setup(uport);
@@ -1214,6 +1215,13 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 			return ret;
 	}
 
+	/*
+	 * Skip the close-time transmit drain for console ports so that
+	 * shutdown can proceed without waiting for pending TX completion.
+	 */
+	if (uart_console(uport))
+		tport->closing_wait = ASYNC_CLOSING_WAIT_NONE;
+
 	uart_port_lock_irq(uport);
 	qcom_geni_serial_start_rx(uport);
 	uart_port_unlock_irq(uport);
-- 
2.53.0



