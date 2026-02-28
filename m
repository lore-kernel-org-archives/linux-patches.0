Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC87F39B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302618; cv=none; b=M6mdYDIjccDlIFy/2aEQHCFywgD0NBVfXe2VruV9uAyrEwJypqcGmWQOFacQfDs3xhqUFAbjhJHBZDr31dM8fIc9u+uLE3qIbqfB2Ru0iTfrNNN+fLeiBoqnDNwoOrSZfM4J4SaSPXfpYUFDI8XRaGMBcdGALxJdEnx9anKSsQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302618; c=relaxed/simple;
	bh=ygFG5ejMQf8+zJfrv4I4toJBrpyQA/I/RSFzwjzUGeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQeJxOc9FT+SNuc4vpHK6aWA6VCHv+/2iOjv8F5LRHJ0BUEU1PSifSo71CPCbUq/Ae8/Ys6tnpgus4JWm19MPjvijA04PFS4J8IrdH0IOPoI6RhCG1/fDre7YQFqlKnqDCiDQNfpert8VwKr8XT/ewi/X4qPAP3F+enGLCIaQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvadE/fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvadE/fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17689C116D0;
	Sat, 28 Feb 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302618;
	bh=ygFG5ejMQf8+zJfrv4I4toJBrpyQA/I/RSFzwjzUGeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvadE/faTkN7y20KYWxRguOiQU4UzHybrKpGj19aWuZZXzAMVTYBYTYXqIbknGKUZ
	 t9EMX25btBABKpZJ3Zd4e8XRlwzxJsfOw5VdlGwGS6Av1tNWJXg18gpRiTQiSKwCGn
	 nYTiyQ3wQZxOnBeeokxKsntkJrltVpBci2E+tGU3FPWaq4CA2Bus02Dq9Tf9aAIs5b
	 STjsF3mVidaiIjfbGz8mnBlT7OKR2/PNKU6W03jktAR3mSPbSfs9CTPZ8vDORVDmaX
	 cMvtyGgxdX5jfOGW41NjEujfX7GdZ1Vl1B76FskHbeZKxaBoLI7q3dNMm35aHsUNUf
	 1zmkW8WSweeJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/164] serial: SH_SCI: improve "DMA support" prompt
Date: Sat, 28 Feb 2026 13:14:35 -0500
Message-ID: <20260228181505.1600663-136-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 93bb95a11238d66a4c9aa6eabf9774b073a5895c ]

Having a prompt of "DMA support" suddenly appear during a
"make oldconfig" can be confusing. Add a little helpful text to
the prompt message.

Fixes: 73a19e4c0301 ("serial: sh-sci: Add DMA support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260110232643.3533351-5-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 824d1a14d981f..73db1b1306b03 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -680,7 +680,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS || H8300
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0

