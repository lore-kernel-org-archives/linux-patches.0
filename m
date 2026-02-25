Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A82D29C2;
	Wed, 25 Feb 2026 06:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002677; cv=none; b=VxYCOETmk4dxuwfXK2F6sqcSo/FWJnUVCimFLdVTNyNDxGoglia7fOGLmCQrvFHXJ5N9NVk78cxxlx2JSjhwnm20IVs35qSMTTTHyuAaUGa4X/kHLVdYy85qGrjNqk1xTbSweXH5/7VQ9/LktSOOAsattJl6fjijlD37HlxcTtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002677; c=relaxed/simple;
	bh=MmhvGXGBWglk74OjZwvfxwBh0MZHhxH2tcBq2mYM+o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD/VfSQgM1SGULUZAepj8cAoG2pF7rRC7tMONlfIAziFpHajrpvxJCogbH/0aLbRHd90u6vfqgtS5Uk2l5D4BaiZz37CjHFHd8MVqyLKlKNgKabooXFO3Lo8waulWiZ2NNsrUGi9N5ZYqabv05IqS1ZRQaxd0ZI40SnNoS/SynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm6dbPw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm6dbPw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC075C116D0;
	Wed, 25 Feb 2026 06:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002677;
	bh=MmhvGXGBWglk74OjZwvfxwBh0MZHhxH2tcBq2mYM+o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm6dbPw9e2QquJKcCOgygrJ0XpHoKNwOX0UsNLVQLjtBAj4S15zw+xxwa3v0APuph
	 BnPGOipBCifDZuTcidwQOh8+j6RQKNJxh7KCd18OOhsWTiUq0MXkd6R4Bs3SDjT02D
	 4SuXRRQ7xqC1UDOJWmK5SS7I+eF4sWUpLqQQVPmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/641] serial: SH_SCI: improve "DMA support" prompt
Date: Tue, 24 Feb 2026 17:23:08 -0800
Message-ID: <20260225012359.709248629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0981288d19c2c..2b9c8b39d68f5 100644
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



