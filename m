Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F14A33AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302754; cv=none; b=qsyjc8SD6fsFonzFY5eSYTR0eTDfMTXp2ytFewrgGCuF7C+A6G9pbigGODogH+WkiNJyvXh45eZtYy1U9QwHs6La/xOjt0j0c093kUp3I9QRBo5YUEsSDE49uAuc/zDpuSnoP/1fOHH8hKpizggwz0sGBHOKar6VcBC5M7KApTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302754; c=relaxed/simple;
	bh=Of39pFptb9fdiEmjzWO4zSPxA11tebADrasgfD5Ed+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh4m40qK7xIH+t14xAEDrNzys9WjHDL++jUqGCk1HnG65MplJIaF5uIdq+f54Pke/Zc4dxW3/3s09JRUbIpnX+vOynTzQG40Nh05UO8ZIIAAmka/D2PXN/KAzZxWjau7iqbO6MJM4MGJIr3gYBwdK7YONnfYLmWZzjE63E0pNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+ehYyHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+ehYyHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C035BC116D0;
	Sat, 28 Feb 2026 18:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302754;
	bh=Of39pFptb9fdiEmjzWO4zSPxA11tebADrasgfD5Ed+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+ehYyHSIW5TAGEVyqNBaEvLSwIwUixL4oA317gcyjV2SJHAcvmJ1WFJDXyWzkF/s
	 hfezC/pJ3bYzYMPMOoWSc09yciB9Pr4cvAjwEFiDLR20+jht4JBSJ/3XIRGdFoEYxy
	 NChMjZcNJ7MPb5W4k2mw/4by+P2lpFlyFEinvgXK2Cvnl4+BOGqMyTKN6RwbdLp1eQ
	 sapQrsrPMFTFYj2i/zYA9T/FEQ364mkpC8Rty7FMmTb4XA2ViisFiRBx4iCk84JE6+
	 t90JgvuoJbgfqjTGiRMtx73fcP4PbZl2yU+/W4tTaLIw22IksG78nNAgwu39ZTMyyx
	 Z2IcXGxXIW8KA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/147] serial: SH_SCI: improve "DMA support" prompt
Date: Sat, 28 Feb 2026 13:17:11 -0500
Message-ID: <20260228181736.1605592-123-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 324787c2616c5..b8b0af95925ed 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -701,7 +701,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS || H8300
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0

