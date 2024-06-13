Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F51E49B;
	Thu, 13 Jun 2024 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282289; cv=none; b=jL3dw22lcHGyMbTOnBPDKiuRpZFVzlSvJ483MfTSFiEc+Ye9F7dYgc7IZszHZQZOiwlVloMJeAQfcR8O+UweWTUfsxtGdBgp4CoH37znK6G+2xhtKvrTH8kaF9E0+/Rgw32v0yRhsGCvom5jSub5miUX5A7vdHHxvPz1hx2K+HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282289; c=relaxed/simple;
	bh=x93EXZVY+d7mmwuJ/l6VAunAp0xrIxnA3XM3wlmjdpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SftQvIEp+EhLHzIckRLLtOMKxXY5ui7vzhnPSOtMYA+8Q8MvHHE69KU4Ubk8vfi1XxYsWYGhB42P0I9sYqyb7jn930x+2J2D+Phk7DeEmQGZ66lsdqdyM7CNSF2MGluz0ZM6UEqEo6pBvyOiDy1HkaGMQzKNOqo+FeerUL6LXo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fs7x02OH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fs7x02OH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ADAC2BBFC;
	Thu, 13 Jun 2024 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282289;
	bh=x93EXZVY+d7mmwuJ/l6VAunAp0xrIxnA3XM3wlmjdpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs7x02OHs7oI3jTgvjjFhzLHcGg21PYMC+Ah7f6zgNB5nqf7GFMBqhIaZOaQx32h9
	 XkHyOIvd2TP17t5zTGujAksK19I5sEV1LgBnJH8KbwKWbtVxJCNXrFA/WiSmZugOS0
	 z1AfUb4Efnw6PIfqidbZ/Tqun9TFN11Qnm6l2N4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/402] extcon: max8997: select IRQ_DOMAIN instead of depending on it
Date: Thu, 13 Jun 2024 13:33:04 +0200
Message-ID: <20240613113310.998406518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7684b3afa6304..ba0542ef4d888 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -113,7 +113,8 @@ config EXTCON_MAX77843
 
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



