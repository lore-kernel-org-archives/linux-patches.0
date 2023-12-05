Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7BC6FB1;
	Tue,  5 Dec 2023 03:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+i0rxk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9677C433C8;
	Tue,  5 Dec 2023 03:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747083;
	bh=jth5mZsWPKZUn30URO4WIQD94s+u0PNfGtGy7pGQtLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+i0rxk45sNkrP0qz1frZa102AGTJwgDh0N4QFZ3JXo0s9+u79abj52L3UTLqCGo8
	 lbBZFsSyRjDg2cdgMCWvE/zL3kf5mYdrHfD8e1A1pfcMYLR4U4dSvABHyB1vbmJFSC
	 IBGKlYooUiwQkURj6tJ3uS4PlRsZC1YJYUes+/Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lech Perczak <lech.perczak@camlingroup.com>,
	Hugo Villeneuve <hugo@hugovil.com>
Subject: [PATCH 6.1 053/107] serial: sc16is7xx: add missing support for rs485 devicetree properties
Date: Tue,  5 Dec 2023 12:16:28 +0900
Message-ID: <20231205031534.654451887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit b4a778303ea0fcabcaff974721477a5743e1f8ec upstream.

Retrieve rs485 devicetree properties on registration of sc16is7xx ports in
case they are attached to an rs485 transceiver.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Lech Perczak <lech.perczak@camlingroup.com>
Tested-by: Lech Perczak <lech.perczak@camlingroup.com>
Link: https://lore.kernel.org/r/20230807214556.540627-7-hugo@hugovil.com
Cc: Hugo Villeneuve <hugo@hugovil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1556,6 +1556,10 @@ static int sc16is7xx_probe(struct device
 			goto out_ports;
 		}
 
+		ret = uart_get_rs485_mode(&s->p[i].port);
+		if (ret)
+			goto out_ports;
+
 		/* Disable all interrupts */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_IER_REG, 0);
 		/* Disable TX/RX */


