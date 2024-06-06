Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14CF1BA89C;
	Thu,  6 Jun 2024 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683486; cv=none; b=sOWbJg/WXaPoVU5oK+mHrV40srzWd6h7hfmy2IEafoAcu9XI+LWB9fP9mmINP+nmZCuhk45jZjFxbyKAFT5OJs/v8b/dnHnltQL66G1GGgoF9roNalRkxJIZenNDVQ2wF07aC23nzJxcLVrNSFVyCqD2u1xEHERc4JBzgetVDbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683486; c=relaxed/simple;
	bh=nOoadrH0Ai7HfWRTYw5+C7hWubiCzZ33ZXcM0DpOAPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY++0yo1Afz7dM8xovvg0lvdSY/UBkCaIdJzN6Lgof5ayF87PnX72CEpSzdAbPJ5SQ4pD+q9c0Lh3CCXFA5sYorA48retIPIElq07VNsn3raz3VH07k1HX59AE1T6bQ7tW2nlWzP9WXNKzv+D+9NzpvgTfbHaj8CgkCzdslnPMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiQzm2ud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiQzm2ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A0CC32782;
	Thu,  6 Jun 2024 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683485;
	bh=nOoadrH0Ai7HfWRTYw5+C7hWubiCzZ33ZXcM0DpOAPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiQzm2udoQTyOzIh2c0RL39+xHdal2ZoaXIARfee57gLWrZJZ9BSH3nASRkrK+JLJ
	 iq/X6pqsj7IxVBiKH3+OT5/NcodLVnvqATxSqXtKCNmTj0B4xCQu2l1JzqZudx9n4X
	 aZ/UperIlbW+TLC9CfhfQG7M/2EoaeXFyqJJdgB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/473] extcon: max8997: select IRQ_DOMAIN instead of depending on it
Date: Thu,  6 Jun 2024 16:04:25 +0200
Message-ID: <20240606131711.031115010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b1781d0a1458070d40134e4f3412ec9d70099bec ]

IRQ_DOMAIN is a hidden (not user visible) symbol. Users cannot set
it directly thru "make *config", so drivers should select it instead
of depending on it if they need it.
Relying on it being set for a dependency is risky.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change EXTCON_MAX8997's use of "depends on" for
IRQ_DOMAIN to "select".

Link: https://lore.kernel.org/lkml/20240213060028.9744-1-rdunlap@infradead.org/
Fixes: dca1a71e4108 ("extcon: Add support irq domain for MAX8997 muic")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 4dd52a6a5b48d..e54e5e64d9abe 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -116,7 +116,8 @@ config EXTCON_MAX77843
 
 config EXTCON_MAX8997
 	tristate "Maxim MAX8997 EXTCON Support"
-	depends on MFD_MAX8997 && IRQ_DOMAIN
+	depends on MFD_MAX8997
+	select IRQ_DOMAIN
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX8997 PMIC. The MAX8997 MUIC is a USB port accessory
-- 
2.43.0



