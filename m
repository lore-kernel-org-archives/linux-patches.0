Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033650;
	b=FXBjIYoePbKPD/zBN8En2lZ7DDaCpwl0vEaPJuT5BihY8cdZeS1n3KfJ0ah48HTz8vJU
	 H6q9z5DMyeUQWMh4BtQepzDADfRVQ9SYXUbh/JN1NJC1z85+jovLqwKJASO7hJnKBSbz4
	 0lPYqCtmGng1zg+iTINVsiK82Nk9JkEw9JhINbqYFEP5LCSQ1XsFutPTnTB4x56uM0N00
	 trA36togCln/CfxJx+LsQ0oQzFioXmrsu8SWbJYNZBjyJHIpakvzCPzWUlE6CNDayQ0My
	 51IsIhD1w76KLlI8sHFQeora01zvajfgy23G27UPetALb8pjP9mzXswRNrR9AXXcmmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uAWqNOrSNh0DHN48DKdp+vuYjEM/CNGhDxiXw2XwFf8=;
	b=zOdMaMA7464oCcDgEUT7GDosy5a9RlyHjjE/KxCuW61xfVDFr/b5olHEj8/o+2z04t33
	 Cf/xCvLsuywJkzNHGGnJii8jBCmapCVy5FIyEAaW0FbcYr+wS3fBd3swoD9UzweXGg9Gr
	 OFIOaCSLWjMqLuLaurJacXXGOfpgQj7rksUl4daHTbEDtOSZ5b4psgN1CIKTvYxj3cqc0
	 /BIYDMooX3cA+se7KBgBThWXFLvqbBX0dFCj8+5NADsdw2p7yKb48bibWlgEdWXuDjjJn
	 rj3OrXvoFBmoPtCSOhIcdSVTsGO+zbxw8YAf0vvWdEt6SKY3ym43GC2OeTne73ipqtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qc8epkqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C34606A320;
	Wed, 18 Nov 2026 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qc8epkqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A561F000C4;
	Wed, 18 Nov 2026 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033649;
	bh=uAWqNOrSNh0DHN48DKdp+vuYjEM/CNGhDxiXw2XwFf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc8epkqCYLDRektLSPALx4JPsyXQgjn8aaNE9p9oWe9ZSQx5tuHoIaxeUklkJF3dY
	 wTX4Lq3MjBnBi2RRMnX8P/cxFmOlLYv0X1IU9D0+DwKQL4d6BP7GapUVzQRX+8U3B8
	 Vk9SGhdLUMaQLrul9qQEO7HuaGu4fZ9typr7g5PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Randive <aniket.randive@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0090/3318] serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout
Date: Wed, 18 Nov 2026 15:11:52 +0100
Message-ID: <20261118150316.843864545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 46145dda5e930..4f77b253b16e9 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1177,6 +1177,7 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 {
 	int ret;
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	struct tty_port *tport = &uport->state->port;
 
 	if (!port->setup) {
 		ret = qcom_geni_serial_port_setup(uport);
@@ -1184,6 +1185,13 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
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



