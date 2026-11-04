Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829442;
	b=zs8CS5br8GlwcREVUJ8I8JaGwr39BNWztW7OTwk/b38NLiEBpCLZ5y33vZhqK64WKwwa
	 F/vQNKILp+cMMwidA+r6UkkGfmPdVyppReDwL19+fUwSYqBugYG6ay0xjGSI3shyZw3SP
	 J4keI+YVB3AGrdbN69bBa238mug/KjQbBL5HGaKSFBv8L0jFdz29rf0jAPdQzk0uf9pTH
	 1CeT9cwqAw9xcqeneqZObWygofhCu5R+2DsGk0BecLt0pPKNxHLyjrvTsupSczRESYZeI
	 FA2j9DNjqUyhJ4OJ6ET+sZOkdPx5QmnMt3MEEImZ7wixCN1mR/JO9kTd7ZhGu+KQd+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gqL5MclRUPKw14/N3/KOXxyCA/CbgFof8xy2H7scsuk=;
	b=ZzELMQJHljuaWgghd5/WXGKooVglETbovUIlW5Br/CxeTQN/bNAU7Giy4z3rR/rkqLXT
	 XtJ3++d/E2hSf0QE8ue/MfkcS8taBZCjcpQUySpCxUwBpPmd8akFkbhtb6AyLKUsAlojw
	 uMwR8gE2NqidcpHsMM+Mk0t/Cw/RDZxQ3+H24VZxZrQqfQm13cxsa3JcIoMTpOpcXcFLK
	 swFwdX6TEACL6xIMU9BPNGeizTLv1sj/2qy38RSaddS9Ot+s5COT1ZkHh1xAXOy98AP1n
	 RP4Ip8qYEJzr76XxB9zcY01ZUTKuU7wlD34QZjTCkEjN9x4nllfE8Etd6DpHnvYgaJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCl3gM2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6C1606AE0E;
	Wed,  4 Nov 2026 21:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCl3gM2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9811F00919;
	Wed,  4 Nov 2026 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829442;
	bh=gqL5MclRUPKw14/N3/KOXxyCA/CbgFof8xy2H7scsuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCl3gM2khqP2lGJTNiSdfbe1gKWKBpn3VWZLPdDo8aOutIraNZAUmD1M4EBRAfKh7
	 t8pOSzf2Fx3D4Lp1bQkql+wi3b3hL4GgfpUsfGJ2qJmEpMjpemytdYoIp23zdvuh4c
	 tMuuC7zWTKOEfhKN5DokRpBQsmmAUfVM2Vi5V3t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Randive <aniket.randive@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0128/1005] serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout
Date: Wed,  4 Nov 2026 15:57:41 -0500
Message-ID: <20261104211047.264520649@linuxfoundation.org>
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
index 5d59a2cfab3e2..0807ca83d8078 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1244,6 +1244,7 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 {
 	int ret;
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	struct tty_port *tport = &uport->state->port;
 
 	if (!port->setup) {
 		ret = qcom_geni_serial_port_setup(uport);
@@ -1251,6 +1252,13 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
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



