Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064706;
	b=u7z8oEtTXIHGL60e9FXNwBeZ9qcmHod8Zvaxryy6Mnpy1Mb1WT2PKYzjStYfQEF85PPg
	 Zrb9KNuwBqfE0Bsmt57sTWAp556uS5nrghB8srDwEYXEs9ijl5ZsPFew9XP2lLNZqn/qf
	 ++4rNE6vtYgGW3iNGQVjmpuHL2E4TACAsF2M0h0FaeKVnS9lxTlvlg0KX68Gdbm4N827Q
	 QG+msnlRnb1kSj+uUNWPzs+frRxwEydFQG9h3fQ2XVrYLe80AldgFlHBWO7IBxvfTOPAg
	 XL5W06gIzo6FbEycPRr9xsar9+y4bj3Pd9RU9CJOoR8+9voNKE6jFuLQtnHUYSzxJ+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wN9xOdb2UvkgACehkVDQOSScNVNT/PZEGevRNEYjljY=;
	b=zepyiGXCBUEf33tqwGV7GUBSFtIjdiepYPSJsCFAb9lTKfvbocqmOv4ahC+cAzhE4QKK
	 D7q1UxSKptkhPmJGY6hIk7onY4mdb5bmBLEcoTrIvVSZdbJ7Web5540Z1FFRR/2Fs3wAV
	 PUJ1LXW3GFcb7bpFc4jqBfRURUXXNAtVOxpaUSmCqgZfQdzvbsbQEwkm8XsNSxZr5pOrw
	 JRi4rMnDrfXGj2ZhQYRNcgAc3mifHLdsYpWdOgNH+P6K6kwJ1DL8qSDuVPrZN15Iy0xsw
	 wlLoyXO95bXgyt+zEyd3FUj9nZ5cbWMOX4PrB6SKhrRRzdllSv9YXLFQB6xKHeyKyFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxHgY0ru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA39E606A335;
	Sat,  7 Nov 2026 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxHgY0ru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515321F0089F;
	Sat,  7 Nov 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064705;
	bh=wN9xOdb2UvkgACehkVDQOSScNVNT/PZEGevRNEYjljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxHgY0ruLyz7Ac6GuORxvmou84kgTGkuEN8gbYb/sD0LX/o9SaBWpNCRJMJ/gTflU
	 /tZk6arjrhBr6y/cEL8pdZ5vx54CUaZk8q4ZsV1swD8dAq8iNPHUDZzY8Yrn48MXor
	 q2i3R9E9ln3rXSyX27FWpvC+uJgcGIIQdgXdRrRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Fuzzey <martin.fuzzey@flowbird.group>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0692/1257] serial: sc16is7xx: fix data corruption due to unexpected xon/xoff
Date: Sat,  7 Nov 2026 08:49:48 -0500
Message-ID: <20261107134958.375567469@linuxfoundation.org>
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

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit 8bb50e95c0abd44607bc60a43032c1dbf7470d5a ]

The hardware supports automatically sending XON/OFF based on the
FIFO status and that is already implemented by the driver.
However that capability was not announced with the UPF_SOFT_FLOW bit.

When the port is opened with the default of XON enabled the driver
configures that in the hardware.
If userspace does not want XON/OFF (which is normally the case) it will
use TCSETS to disactivate it. However the serial core optimises this
to only notify the driver if someting imporant has changed, and for
XON/XOFF thit is only if the  driver declares UPF_SOFT_FLOW.

So we end up with unwanted XON/XOFF in the data stream.

The problem only occurs if nothing else needed to be set by termios,
ie if the user space requested values are the same as the default values,
except for XON/XOFF.
Since the default speed is 9600 this means that the problem only occurs
when requesting 9600, otherwise the call to the driver will be made to
change the speed, and that will also clear the XON/XOFF.
As 9600 is quite rare these days that probably explains why this hasn't
already been seen.

It also only occurs on the first port open after boot since the subsequent
opens will use the "logical state" set by TCSETS but not communicated to
the driver the first time.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Link: https://patch.msgid.link/20261001100534.1225894-1-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 296079c16fdb9..7ddc8a38adab4 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1516,7 +1516,7 @@ static int sc16is7xx_setup_channel(struct sc16is7xx_one *one, int i,
 	/* Initialize port data */
 	port->type	= PORT_SC16IS7XX;
 	port->fifosize	= SC16IS7XX_FIFO_SIZE;
-	port->flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
+	port->flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY | UPF_SOFT_FLOW;
 	port->iotype	= UPIO_BUS;
 	port->rs485_config = sc16is7xx_config_rs485;
 	port->rs485_supported = sc16is7xx_rs485_supported;
-- 
2.53.0



