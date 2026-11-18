Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017014;
	b=lM6uu2Qw+QiVZBJotriu8bP3xCxDeAQEQIVy0aAMikT+xhtZdTxSA5oR/MOgm4aj2sVA
	 G+aaKrHH/hD3yoUEEqlAiL1fnB1oZY4oJFUeXzYZFg3RHZ11+VwPv5aDwsAp3maZVzpWr
	 kzDG14MK89XVWERGtPimZ34uDPcf7qlgMT3dDrSwAxgjX5+3aVoDybjuOvI33sUbyVPoA
	 jAHod5VHFJqj5GL8mBrs7JIASzUuOWLC4PHGhOQfKunys9A3+lOTo/d0XZlVK7wW0xx8K
	 KVYlzCoIn096r5N0iGGYbufdnysmAkZsOHfzgezWWLXmnvA819DzOICixxcZv7cS60A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoWVIuXbHlyPvbOQwqQhfDyZ1q9lZCVboXwy9Z+bb58=;
	b=NlWGtN8Lf66LBaUq/QmBQuWB2f1aNFlpW2rFaqcTsXR4z2VWSz/R2hj8Z5DpIsxE7BYA
	 unuDgX1izsoAtY/VlE0k47eSxswsgMjZMTeqYm1RWlGL4LYWdHUFzBMguMQpHE2jBM93f
	 1DqzgGe0/hF7MjHobkQFPsJa5vBYHLZvK6tevoXFdVbYdYVCOQDUN6Z4XNNvoCMgbdVFG
	 qNZvrFRyS9tSFsiTGUXGZprz9ibXjvnHXcV9tDxNi6S7/cQiqKGsN6b42kZF00i0gf2NX
	 G2vnZDxl0QQlbWtH3SANsBTzCtm5P5RBDNHMH0vW4QBeswwbKS57lBqrZAdWxC3Witw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNLhVUJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53157606A32A;
	Wed, 18 Nov 2026 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNLhVUJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671061F000C4;
	Wed, 18 Nov 2026 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017013;
	bh=OoWVIuXbHlyPvbOQwqQhfDyZ1q9lZCVboXwy9Z+bb58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNLhVUJPpycQ8CF21TITzLYWSiI8Rw9K9TC+88RjYPyoEVm0OQonPfSreLFtt1QsH
	 NtEcsWVD2X93NSPpyhOz5T6B61FB1tccH8B57FnK+dcAbvdSpNoH1nhp/zLKCqGl8R
	 cBg++Oiux6tch7eSOmfl0MTRNn3hc6xQVSCU53cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Crescent Hsieh <crescentcy.hsieh@moxa.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0731/2651] serial: 8250_mxpcie: set the driver data before registering ports
Date: Wed, 18 Nov 2026 15:32:51 +0100
Message-ID: <20261118150314.185009469@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 27ca9a81485f179aac83d25fcc3234bc927fa17a ]

mxpcie8250_rs485_config() looks the board up with dev_get_drvdata() on
the PCI device, but pci_set_drvdata() only runs after the registration
loop.  Where mxpcie8250_setup_port() presets rs485.flags to
SER_RS485_ENABLED and the flag survives uart_get_rs485_mode() - the
device has no firmware node, or its node sets
linux,rs485-enabled-at-boot-time - uart_configure_port() calls
->rs485_config() from inside serial8250_register_8250_port(), and the
callback dereferences a NULL board pointer.

Publish the driver data before the first port is registered.

Fixes: d21a1509c623 ("serial: 8250_mxpcie: support serial interface mode switching")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Link: https://patch.msgid.link/20260901041519.114737-2-lilinmao@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mxpcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_mxpcie.c b/drivers/tty/serial/8250/8250_mxpcie.c
index ce873fbd62e93..c0e3517d4e4ec 100644
--- a/drivers/tty/serial/8250/8250_mxpcie.c
+++ b/drivers/tty/serial/8250/8250_mxpcie.c
@@ -542,6 +542,8 @@ static int mxpcie8250_probe(struct pci_dev *pdev, const struct pci_device_id *id
 
 	mxpcie8250_init_board(pdev, priv);
 
+	pci_set_drvdata(pdev, priv);
+
 	up.port.dev = dev;
 	up.port.irq = pdev->irq;
 	up.port.uartclk = MOXA_PUART_BASE_BAUD * 16;
@@ -578,7 +580,6 @@ static int mxpcie8250_probe(struct pci_dev *pdev, const struct pci_device_id *id
 		}
 		priv->port[i].rx_trig_level = MOXA_PUART_RX_TRIG_DEFAULT;
 	}
-	pci_set_drvdata(pdev, priv);
 
 	return 0;
 }
-- 
2.53.0



