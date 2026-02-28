Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81683346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302222; cv=none; b=VS19y4npbYNvEamAdfCcMHKQFjXvRR/boKGG5Uf/kPB/MEuvr9FQZqUV/MuE3tGQygEkLedbpn1bDj6//f95pWRoBP73btVGFnVOSj4BTQIDTj5j13O1MYRNgHDLD0kpMm5/S/s/mJcK88lEY+OB9TNu7UgZ/4/25VZ8tRHe0OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302222; c=relaxed/simple;
	bh=Mn/Rfw9rdowLqczWKkJoYGSDaAhuWCaiNa0+RZinHhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnZ4chbTwdF9ceJIe2AZ751e83CkwZOXoBeJmANWv2c55KrLPKzAN/Kxvy+teK068XqpaOKgoIspEUWVrLRTYwYL98C2D1wnVxwZpwDHF7ofdWbYGG2QgyQiIbuTGcMpER5KKTZWdGhej9Nm+qnIlghIE42HUZLP2HS1Vl5bSGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKcmbITc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKcmbITc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F75C116D0;
	Sat, 28 Feb 2026 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302222;
	bh=Mn/Rfw9rdowLqczWKkJoYGSDaAhuWCaiNa0+RZinHhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKcmbITckaNUwrK8g350FHIMgmbu1KmjZeNLvdQS53qV+TA3/0z7PsXuG04lourXQ
	 T+O9bthaXat6oyesREwa2FaWBKZ/TYf3KOMwPVn7kjyB/c4ShEXVtbMHZtagiFjpv9
	 iF6Ty+rcjd1alqWfeseNc3E75dV643PNjjdoY9IHgQQ5R8I3RbzFNRRYV/c7FCqbkL
	 zHwrvGe4yfeXIhMI3NuZXFT+lCYx/guwRfkx+bfII8IUdBnY88e7cajmFF/VV8UY6n
	 C2dmxlFrCmYsLU4kbHK/YVMFgggcFcmngkSxKBEX9/m2X/W5PwMoT/r9rBBYxrZvLs
	 ADafFlG4Z4sPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/283] serial: SH_SCI: improve "DMA support" prompt
Date: Sat, 28 Feb 2026 13:06:12 -0500
Message-ID: <20260228180709.1583486-230-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index ac74b491ba50b..2b9b2235e29d6 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -661,7 +661,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0

