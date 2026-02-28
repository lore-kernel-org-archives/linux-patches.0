Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1248379EEC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301897; cv=none; b=D0nZBI8P+hbMrYi2BBoYItZAivynJnteB4nyH8FR3ZNhkh/P3y/QfX//Np++s6taxHnUGmO8HcvJa5bUrAAyWIQCJWmHqIlS5MTnVvdqNLE0yIbJa0u4c6zM4z2R2vUPc1J8nN2wMNMX4c2u3hpMJTOISOw1+W4OoW6aswYeO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301897; c=relaxed/simple;
	bh=v1wko6TrQGRM0xgrWwYqFmXuq9XGp18AjTjthsBNA0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAdeLNY0CvBxlLnTntn48Ksbd7YyPeUoKf/KAzsUvPxQwHRNPwF6iNE9N0SDMyreAxLkiM/BFKSGfrQ/wBtYFyfso14aJe8/OUKhNgOkX18hkCi0xgzqgKoelFhW4QClBEYnl2B7fhea8seSrn4nq52CHLmAfOITXg5LoszXl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCzJrww7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCzJrww7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC08C19424;
	Sat, 28 Feb 2026 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301896;
	bh=v1wko6TrQGRM0xgrWwYqFmXuq9XGp18AjTjthsBNA0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCzJrww7oSpP9S0HP3I73ikEiok42hISskqM07Bd/y4gLsAoHxBB13Ce7ttDcbr1z
	 vt3CCrNbqN89CBVy8fZpxqSj71RIanDBosLgq2xjUlsZ5AI55IPekwGjTE5t15BkVL
	 y+xI1dbFRPhuvUkPfC4Clq/Gu/N0mA7kJNtV5HfigT7sUOULpDGGH+30kLFa4CIaUC
	 6TaKfab4OjYojN/6sEZ8Guy9Tb7LN6Ar8hpVw/VeOMW8tB+thlHd1bfoqUdN/DSYlo
	 T8aihbB9vy2i79jV7xlHRuAcMmgOBO+ISl77EvJLc0MuS85Or81ZPVOX7uTKyvjk6g
	 rAEvWdQDwIMhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/385] serial: SH_SCI: improve "DMA support" prompt
Date: Sat, 28 Feb 2026 12:59:07 -0500
Message-ID: <20260228180011.1568201-325-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 09987529b8ba4..1e92b16b6b95e 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -667,7 +667,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0

