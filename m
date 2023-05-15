Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB1FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75F0C433EF;
	Mon, 15 May 2023 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172580;
	bh=niW5dJMdUA6KXbnQ2D65IL3XQVNhfO9t3jMRjmvWlDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEYVa83AK+zNyc2N5Gs6KWhJ1PV4uASmWym4vNtEZx7UQsgD2fKlyA/ZLkYhrqgiZ
	 j3L2gr2TxXb7dxZ6BByiyZk3eAIjjhMUbnnxJrVG3ZE5aBxdF6pKN/ZkLXb3n3dUMY
	 FAj1Vr+D8Y9yYuJ3qLA4fDx+BFq/N1/V0ZNHCua4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Jeffery <andrew@aj.id.au>,
	Corey Minyard <minyard@acm.org>,
	openipmi-developer@lists.sourceforge.net,
	Arnd Bergmann <arnd@arndb.de>,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/381] ipmi: ASPEED_BT_IPMI_BMC: select REGMAP_MMIO instead of depending on it
Date: Mon, 15 May 2023 18:27:23 +0200
Message-Id: <20230515161745.486438171@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

[ Upstream commit 2a587b9ad052e7e92e508aea90c1e2ae433c1908 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP_MMIO" to
"select REGMAP_MMIO", which will also set REGMAP.

Fixes: eb994594bc22 ("ipmi: bt-bmc: Use a regmap for register access")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Jeffery <andrew@aj.id.au>
Cc: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <20230226053953.4681-2-rdunlap@infradead.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 07847d9a459af..f443186269e1c 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -126,7 +126,8 @@ config NPCM7XX_KCS_IPMI_BMC
 
 config ASPEED_BT_IPMI_BMC
 	depends on ARCH_ASPEED || COMPILE_TEST
-	depends on REGMAP && REGMAP_MMIO && MFD_SYSCON
+	depends on MFD_SYSCON
+	select REGMAP_MMIO
 	tristate "BT IPMI bmc driver"
 	help
 	  Provides a driver for the BT (Block Transfer) IPMI interface
-- 
2.39.2



