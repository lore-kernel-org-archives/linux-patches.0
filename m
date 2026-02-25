Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736B248881;
	Wed, 25 Feb 2026 01:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983457; cv=none; b=kadnCbVO0yTAZNb1QEPVjt3ZdnLVykDQFIinCoqZCkQn5BDQe9a5lCAYZUSvlH/sqjffM3mrxcsfcaN3t03GcvPNAAd+cQwnQLkkQO+9khuLdt2fNwKvBBJ9uftIeekn05kvT9PJPKvMn27nKm2fkORlFI7fuN8N0unVSwwcCeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983457; c=relaxed/simple;
	bh=5tdvi6AmnkSWj+wG7cmnUHVi3SkCL+fdzmJH/SLPai0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhRAuOCZ66rlDzv12Ar2hLz9Iz1g+f383mAIwLpKZWgGv9x/xuWQ7dEVk6B28Z0Lmnvs1f4j+SzxFA9RUqCcv+b6uABqbINOuVV9BvAX8c9J8Oilz66sHi0/7LX8uGESUqtQcaxNSN+9yyygzV19NLH1QNaCQEfNy2y2yPvdC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JATUCx3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JATUCx3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083BBC116D0;
	Wed, 25 Feb 2026 01:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983457;
	bh=5tdvi6AmnkSWj+wG7cmnUHVi3SkCL+fdzmJH/SLPai0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JATUCx3qZZrGtVkKr+I1y/a4Mg24eRWHKKr1e8yAI7uX2qsYFd6+eQq/eMwRp6vrL
	 toh8Ct0wpCs0V0znajUikG4vKLacmXm2RGs4PuL3PmdsOO1a6lsQbaKP0nnHc7B89y
	 +SLv7r2G6GA5NQhv7bCV1rqua8MFxMQVKx+kUEag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 571/781] serial: SH_SCI: improve "DMA support" prompt
Date: Tue, 24 Feb 2026 17:21:20 -0800
Message-ID: <20260225012413.808948105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 98a946096be3c..3d06c65c2f491 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -671,7 +671,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0



