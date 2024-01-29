Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543B15956B;
	Mon, 29 Jan 2024 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548428; cv=none; b=Au6Jjz0P390PSU7wC/waTCQN1ErKAQMBex+1/Hj6snMpgsVQOETepbvXYCTYVnNlHnJTIDCdpMMvvVRJhUsyU4UWZtiXtUsGsAlYTvAWoH1GOoOg3JZ0XRGvTo1tvm0u0qj5hHnmdDvKebHyAAYj3/a0wug39P2ONfTnTmSp4+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548428; c=relaxed/simple;
	bh=IKiOZy/pUox9L8A29Bx/vGSQ4D+bppvvVvk4qYOPdic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+Runw1FRJ1eAYWR8+wuK/ZdTI9zrA84zHz1Ew/uYvCNx5Ezu22oUHa59wXE3JfkEpKO4tPFAvUPUJbbjKqWr7g1/Znr3coQ7yy+QrVVHmYcI7pb2OCMKU02ibL4JkramZAZ0/Lx356B5SertemJf5REQH2m4O1+KY6ejQVf5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WLUhBtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WLUhBtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAC5C43394;
	Mon, 29 Jan 2024 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548427;
	bh=IKiOZy/pUox9L8A29Bx/vGSQ4D+bppvvVvk4qYOPdic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WLUhBtRnJKirMdrCmKxFUcsFU3EM4LNMv6aqIBpkgUjSK3SYYq2aw5C7+xRY/Xv2
	 hoJ3IOZKx58gVD92qPcM5yRcHfZ4Jf6n8GbT8MZj2aIlUZ+/6gnhtHLbpCm9qGpKDl
	 CDw9325Afw96eQQ9tQXpUbwKoUQetZNUbVwwKwPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/331] serial: core: set missing supported flag for RX during TX GPIO
Date: Mon, 29 Jan 2024 09:01:09 -0800
Message-ID: <20240129170015.118932597@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit 1a33e33ca0e80d485458410f149265cdc0178cfa ]

If the RS485 feature RX-during-TX is supported by means of a GPIO set the
according supported flag. Otherwise setting this feature from userspace may
not be possible, since in uart_sanitize_serial_rs485() the passed RS485
configuration is matched against the supported features and unsupported
settings are thereby removed and thus take no effect.

Cc:  <stable@vger.kernel.org>
Fixes: 163f080eb717 ("serial: core: Add option to output RS485 RX_DURING_TX state via GPIO")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-3-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 021e096bc4ed..bde5b6015305 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3630,6 +3630,8 @@ int uart_get_rs485_mode(struct uart_port *port)
 	if (IS_ERR(desc))
 		return dev_err_probe(dev, PTR_ERR(desc), "Cannot get rs485-rx-during-tx-gpios\n");
 	port->rs485_rx_during_tx_gpio = desc;
+	if (port->rs485_rx_during_tx_gpio)
+		port->rs485_supported.flags |= SER_RS485_RX_DURING_TX;
 
 	return 0;
 }
-- 
2.43.0



