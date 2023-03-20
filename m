Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE14A1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3A7C433D2;
	Mon, 20 Mar 2023 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325871;
	bh=4dgyGaiHkVLcwecfj5mvgWM9vlM+Ly+omg4kwrWyhgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWxhsbH9NxPPkDB3Uq9/x+QBrVax4h+eNXQ73xGQx+bf3d6JwZXiIUWHRFn7VxoJ9
	 p1LFDENB57TmIfq8PulmCR0e7SZDo7KtOhrAMOxquBdYj4TZdV95djZqA69QUHaSJr
	 ufLO4231ICB/J2DzTMajOGkIGcZAHkZv9NFi+psQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tom Rix <trix@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.2 117/211] Revert "tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency"
Date: Mon, 20 Mar 2023 15:54:12 +0100
Message-Id: <20230320145518.236894579@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

commit 2d638be71155b2e036aca1966b6129e2d661e91f upstream.

This reverts commit 5779a072c248db7a40cfd0f5ea958097fd1d9a30.

This results in a link error of

ld: drivers/tty/serial/earlycon.o: in function `parse_options':
drivers/tty/serial/earlycon.c:99: undefined reference to `uart_parse_earlycon'

When the config is in this state

CONFIG_SERIAL_CORE=m
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y

Fixes: 5779a072c248 ("tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency")
Cc: stable <stable@kernel.org>
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230226173846.236691-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1313,7 +1313,7 @@ config SERIAL_FSL_LPUART
 
 config SERIAL_FSL_LPUART_CONSOLE
 	bool "Console on Freescale lpuart serial port"
-	depends on SERIAL_FSL_LPUART
+	depends on SERIAL_FSL_LPUART=y
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 	help


