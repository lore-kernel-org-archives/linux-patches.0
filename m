Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017069;
	b=WmzVOnOdECKDaHCtZbWuCU21aTJUAu9pmsXWrX0yuQCF9xX1TEYtfI2VNPUT7+dYx/m6
	 qwSIggXSIflLiYbjDVd6Q4VNWdzfUycE6lFcTxp5sN3euEwaDUhLcVrK/8V/z1qm2XjSc
	 1d/47ClRHWL+idS3O8Ydhk7PcOrXTTl+hr9pDegbsQB/2cntcbekhJc6sPZzBSGT8V05g
	 yUT2N4NEJrH3g9j46dL8z97l1qMfXF8HK4iGE24K2TqzQyWRx03seaCetDjvPmqv9Hjez
	 45En9cQ8Z+ErX0F7Nw16XoCt00Z3qq5NHQ7zk9RlD79Ha9VEAzAhlIZmMBcqg+9gZNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kEIo6mZ5s96M8cgItsPzwVQPb5eJZRXRMHT0DPVoAcM=;
	b=baS4LALr4zHJWWgSGQheo4b3H0PAnBMFPFiaJUwMXiUAlAxRgQkPZwnj+fjgjgVm5Hs6
	 GlGgL2yQI1s0b8+eyRmiYa5+xpRPzFM0A94NimT59dbptpXmKmiKZfspoKoCxKVSQlzpX
	 Ag0PxXDeZxNOV2yGQyoUgIV08IxKLLZCDztEzqlkw3j1pfzzJtDdSgaWekksDxqTs2vUi
	 iChIqAA3/Lc2XGI21a2M4gKpeCqr2D73Hb71EQKyoq6MbNn+SngV8MfhXLEUhr1vKCaP2
	 jxjJ+qLW8X1Wm27wIHu9GoVXf4A1T/AIIy0vyn0axxXsERG4zDgC+4Mb6gzm66HYhnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoBaefOL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D03606A33B;
	Wed, 18 Nov 2026 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoBaefOL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7692E1F000C8;
	Wed, 18 Nov 2026 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017069;
	bh=kEIo6mZ5s96M8cgItsPzwVQPb5eJZRXRMHT0DPVoAcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoBaefOLo4tnjztoi1eTe4io+6oahGbvU2kdLtKwPfweh+NFbi6WHR3qKU1FJGU+D
	 A16tkhUBs/1TKZqxDqHTXU7/RwyAZomwNSzXe5oz48rtI3gDUj+dXGCTOxzi1arGng
	 f216h6RFq4pNhnRTdTdmkRCzNxDtLbNt0ScLSaoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0736/2651] serial: sh-sci: Unregister UART on sysfs setup failure
Date: Wed, 18 Nov 2026 15:32:56 +0100
Message-ID: <20261118150314.368514622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 92193eb26abf5..50ae9aae6b614 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3937,12 +3937,12 @@ static int sci_probe(struct platform_device *dev)
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
 
@@ -3952,6 +3952,10 @@ static int sci_probe(struct platform_device *dev)
 
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



