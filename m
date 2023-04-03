Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6416FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8591FC433EF;
	Mon,  3 Apr 2023 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531883;
	bh=r8Cp+2NSen49DdgR8bZsF0UXc15pZZ62TTZa8Ha3dw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcxW30WGdiUckvPny27GvGQFQMr5UAqyAaQ0N8Hy31rVnfR0++mTxNwkBbnRA6NnJ
	 4eX258q1YAzD79FOcT8R+EBWegUhzX80lzWCNcVamxLk//Z7OmgWD08qV78YjQq7cB
	 Bo/F2FZU8p1EEfnEk+sky3tN4uS3lD4WZoy7Ms/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Oskar Senft <osk@google.com>,
	linux-serial@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/173] serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it
Date: Mon,  3 Apr 2023 16:07:11 +0200
Message-Id: <20230403140414.822948724@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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

[ Upstream commit f8086d1a65ac693e3fd863128352b4b11ee7324d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index dcf89db183df9..b7922c8da1e61 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -254,8 +254,9 @@ config SERIAL_8250_ASPEED_VUART
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
-- 
2.39.2



