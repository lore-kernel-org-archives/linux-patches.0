Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354DD3559F7;
	Wed,  3 Dec 2025 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778659; cv=none; b=WUYxEYUdCgodoDtmdr6PiYj3ZSoHxvbEvvNPrkY+nIQg/38kAYIXxHhUxpEoWHrg26IHSH1McRgleUhzUmzZ+0qqe5grPKqC9CpuxUA5V/Qs288mWuuub9iB4DltIJUzSgfziHHRW9EbVpe98qoTO1taCoiKbLX/IaADU6eipMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778659; c=relaxed/simple;
	bh=uSPUkCH4i7jDzYY0Qwo0hoUUbQSvX8iPyZX16YVb+G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phE2j5kQcUm+8g+nlx98MdB3W1+x7oo1HDaxM/pAl7lss2VCDPEaRcEgvRQOZkNyz4iBj2xkdULb7wtBa9v+X63SdqZSs25GHXwc+yjRCg1NZIAkaTgdWpIb5XXHCLuiY17eJw9EUPiEa8Zp1uSUOOExyZM8oeUgPZeZzweoxXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYulQv63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYulQv63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93361C4CEF5;
	Wed,  3 Dec 2025 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778659;
	bh=uSPUkCH4i7jDzYY0Qwo0hoUUbQSvX8iPyZX16YVb+G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYulQv63QF4x2av81aWsaKK5ZMgi+vIn6qn1l29rnxC2Znc8Grbg+dNwCTj0dd2qu
	 6GwLCul4xNJDGcLf3HZskji7sGL7u4w75dX2F3nxMdh8MTP3/Q3IDsSnCDOO6E0JW3
	 U5cx1hNivebfY6SpmZ3JR0KLhbIFYeABMPtCBXcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/568] serial: sc16is7xx: remove unused to_sc16is7xx_port macro
Date: Wed,  3 Dec 2025 16:20:22 +0100
Message-ID: <20251203152441.403317308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 22a048b0749346b6e3291892d06b95278d5ba84a ]

This macro is not used anywhere.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230905181649.134720-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c05bf6c0262 ("serial: sc16is7xx: remove useless enable of enhanced features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -358,7 +358,6 @@ static struct uart_driver sc16is7xx_uart
 static void sc16is7xx_ier_set(struct uart_port *port, u8 bit);
 static void sc16is7xx_stop_tx(struct uart_port *port);
 
-#define to_sc16is7xx_port(p,e)	((container_of((p), struct sc16is7xx_port, e)))
 #define to_sc16is7xx_one(p,e)	((container_of((p), struct sc16is7xx_one, e)))
 
 static u8 sc16is7xx_port_read(struct uart_port *port, u8 reg)


