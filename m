Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024257;
	b=o4CRpPbG3oO9mGCl7J6AYIPRiIlCA4t5Ay8GKrhqYkcAU4PC2aefigebwKdZrf0dhbtG
	 MVW0tdRENkmjBunU0CVuEZ2yfSQQc8dcOeUbZdE5dSyAJDE/5LAVReCywZ8+IJO5rbaXM
	 4ffjbxzBIAzhlwaSi/Xd4ymnVOI+fBihRRXWnput3NklvNiPUmneVpo4PXCzA0YVvVApA
	 QnU8Ny3FhrHKhJ4X0TFyJn2j7IzQQ2mainsBauFPeLXg39T+Ya//vVmJCqmTKdkr9WD8V
	 VW6w8fmAS4WGHIOQdIC+AKk5E9gZxRpUV+cegxNPuRT8nykUbINHqFqluPlhq4l7xCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=17Lgp37W8xiZeqGfaEYx9lfHEbAR7RXU/i1EirHji2g=;
	b=pqICRNfUHhRuDls9cPnZAhu2JiAy8xv+gxK6DfVeLaSGesxeQinY+OmL/acughdbEqoX
	 YizI0Lo6jdlqplplMMtHm6wBd2150zpxy94yvPmAhSAv3dwvJGMPgWkHyAGKebPiq69a9
	 qHW9uaCeVYhGwvC7OQlw6Et/DUeviV0Pds20Ysn3li903WlQcl9w1hIuePMDedb4Sw0u7
	 r7FQ6i9vXNBxub6a4+aazi8jH0DZVaAOjt14e7o8wbVggRQ5L3Vn7gZEv4o3hkWMeJWLY
	 o0lLdFeB3gZZvXIe0GFpLEpd9CpHCkOuxBiVSPOwKe9jKsJXPOIeQaZ/UG/daliNYsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRDk1PHQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BAC606A33B;
	Wed, 18 Nov 2026 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRDk1PHQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0E1F000D3;
	Wed, 18 Nov 2026 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024257;
	bh=17Lgp37W8xiZeqGfaEYx9lfHEbAR7RXU/i1EirHji2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRDk1PHQMwy8OAHjMo1FiyMHathMX0dD5iCtHStd3Lqt433QV7X5W9owYkhoScVGF
	 5Z+q9gnjrSVVqmM9C9Ch4UjYHfp0GUw9VvPJDCg/YAvYWI25rKb1c4pOEXUihwHo3O
	 b2zecBKlo2CdOTDgFlhNWw67jD1jsuwmD9bgGXyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0662/2151] serial: sh-sci: Unregister UART on sysfs setup failure
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150145.953316739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c5b33c86d86da3ccff8c05e2a28719e3ec933f70 ]

sci_probe_single() registers the UART port before sci_probe() creates
the RX FIFO tuning attributes. If either device_create_file() call
fails, probe returns an error without removing the port from the serial
core. Device-managed resources are then released while the port remains
registered.

Unregister the UART port before returning either sysfs creation error.
If the second attribute fails, remove the first attribute before
unregistering the port. Keep the existing probe failure policy and leave
the successful initialization path unchanged.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5d23188a473d ("serial: sh-sci: make RX FIFO parameters tunable via sysfs")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260911031500.5745-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 96f70581d6ecf..20a833a80baf4 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3740,12 +3740,12 @@ static int sci_probe(struct platform_device *dev)
 	if (sp->port.fifosize > 1) {
 		ret = device_create_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 		if (ret)
-			return ret;
+			goto err_remove_port;
 
 		ret = device_create_file(&dev->dev, &dev_attr_rx_fifo_timeout);
 		if (ret) {
 			device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
-			return ret;
+			goto err_remove_port;
 		}
 	}
 
@@ -3755,6 +3755,10 @@ static int sci_probe(struct platform_device *dev)
 
 	sci_ports_in_use |= BIT(dev_id);
 	return 0;
+
+err_remove_port:
+	uart_remove_one_port(&sci_uart_driver, &sp->port);
+	return ret;
 }
 
 static int sci_suspend(struct device *dev)
-- 
2.53.0



