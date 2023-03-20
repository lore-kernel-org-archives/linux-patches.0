Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221491C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CC8C433EF;
	Mon, 20 Mar 2023 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325676;
	bh=gbkODAwK/OWLYiSLQQ1vtVK4wzka5QYbDWyqUr7xv/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1cSk3gib5aaPBrfSNymTVNeSpNlTikl2QIr5TXhVYUXYXWaKlT4fPVMQB+oo+LKO
	 zCgTAad/Gkf9XmmMKUfnTxjB0zibaIpRHHGE/1G9sdT9UeRi5BfxuynihI5A8hhqew
	 S3G8bo8YOpyRoUXCfFI0lag0n+1EC7XNfHh2WZTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Oskar Senft <osk@google.com>,
	linux-serial@vger.kernel.org
Subject: [PATCH 6.1 121/198] serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it
Date: Mon, 20 Mar 2023 15:54:19 +0100
Message-Id: <20230320145512.624841943@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit f8086d1a65ac693e3fd863128352b4b11ee7324d upstream.

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: 8d310c9107a2 ("drivers/tty/serial/8250: Make Aspeed VUART SIRQ polarity configurable")
Cc: stable <stable@kernel.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oskar Senft <osk@google.com>
Cc: linux-serial@vger.kernel.org
Link: https://lore.kernel.org/r/20230226053953.4681-9-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -253,8 +253,9 @@ config SERIAL_8250_ASPEED_VUART
 	tristate "Aspeed Virtual UART"
 	depends on SERIAL_8250
 	depends on OF
-	depends on REGMAP && MFD_SYSCON
+	depends on MFD_SYSCON
 	depends on ARCH_ASPEED || COMPILE_TEST
+	select REGMAP
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-


