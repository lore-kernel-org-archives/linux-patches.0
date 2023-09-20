Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D2215AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3584C433AD;
	Wed, 20 Sep 2023 12:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212218;
	bh=jvpHrKor9TLWx2ouDUZaIDrG6Bks4UQ/z3UUhDuCWNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFFlTucM0yGUe33NrGy0SdplTguXm6Mn7Z894nj/3T+HC0HZ+0AEvHTmSF4iioZcB
	 4ZwcabUU3s3t3sK2OM/7CKTrtUvDjuh1yGRR/2/YqW8Kf2032/uCrLZbZZNBo4GT2y
	 nlOIXWtupOt+KdF6Zks8PVzhMztaKUOUXt72KowE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mack <daniel@zonque.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/273] sc16is7xx: Set iobase to device index
Date: Wed, 20 Sep 2023 13:30:33 +0200
Message-ID: <20230920112852.469435811@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit 5da6b1c079e6804a81e63ab8337224cbd2148c91 ]

Some derivates of sc16is7xx devices expose more than one tty device to
userspace. If multiple such devices exist in a system, userspace
currently has no clean way to infer which tty maps to which physical
line.

Set the .iobase value to the relative index within the device to allow
infering the order through sysfs.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Link: https://lore.kernel.org/r/20200901120329.4176302-1-daniel@zonque.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2861ed4d6e6d ("serial: sc16is7xx: fix broken port 0 uart init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 453cdcc9f3223..1ff48f827b2c3 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1264,6 +1264,7 @@ static int sc16is7xx_probe(struct device *dev,
 		s->p[i].port.type	= PORT_SC16IS7XX;
 		s->p[i].port.fifosize	= SC16IS7XX_FIFO_SIZE;
 		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
+		s->p[i].port.iobase	= i;
 		s->p[i].port.iotype	= UPIO_PORT;
 		s->p[i].port.uartclk	= freq;
 		s->p[i].port.rs485_config = sc16is7xx_config_rs485;
-- 
2.40.1



