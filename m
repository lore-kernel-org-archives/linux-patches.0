Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23EC145B32;
	Thu, 13 Jun 2024 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280148; cv=none; b=VOqplTyFEkhoLuZiUh0kHa2Uh7CLvRSKC2f+YpXV/t1viu/BrWdxHkKojBfB+RS5QSaBLA9uAExCT7FbJ9UW4FM8AVX6Ie0GZ/JX8tvfFxFxuT+Wr2+Ys2iJbDH7N2b7h/6/SJ6ievvof/gA2V4vuVsidTZ9ANPkYTciEXtPPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280148; c=relaxed/simple;
	bh=1A9lW8hynRipUfSA1ltRo6AS5y6Rpt0D5bwoJP7Zh8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0oGVWIFpgVyC4wx4Z26a3Ql4lswBjzkHvsx3Y8i32h3o68lOHt7eFIQqUIwEphWTGqr0f3aEI6UwZe9XUSeTYOwJkduRNWilVhWLYhwjmPh2zgLFbyY/wP9dFSWHMrzCRTxSY/0rXcNs/SrKSr6XqBUX23de6UJrJ1Xls3XGkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaRvboW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaRvboW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDDC2BBFC;
	Thu, 13 Jun 2024 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280147;
	bh=1A9lW8hynRipUfSA1ltRo6AS5y6Rpt0D5bwoJP7Zh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaRvboW55ULMUsG4KTCLXMlMLaTWX/DRmwsdV29x7Iv0SkfyJ0LOfsCXbSWASleu+
	 TPjiQ463Mctuwapuju5KKkZORk4Z5VBoAwlJ85HDj4POUh6j5H3AGgasZjHIHvyVgE
	 fU0hCyml/nz8WcOJFyeJnh+Am8D7IsQ911tKFKKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/202] extcon: max8997: select IRQ_DOMAIN instead of depending on it
Date: Thu, 13 Jun 2024 13:33:36 +0200
Message-ID: <20240613113232.316477394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index aac507bff135c..09485803280ef 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -121,7 +121,8 @@ config EXTCON_MAX77843
 
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



