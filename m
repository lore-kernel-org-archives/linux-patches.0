Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C57359A96
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302449; cv=none; b=gftueHF7IP2Uf7QrtMSTHMV5RFB5uBfAvMuLGm7Y6/RTcL7prVjXcZxhvqout1Dgpx+dstOmArpGhDHFDOAOOji0zwV2TpIUex8mqJjJGkmXUkuiD8yZUpNCD2jXwD873sJIkrmPnO9yvLU9+7hgupKdOcRCGccV3r/1Qx6nL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302449; c=relaxed/simple;
	bh=6eP2Y0M2FJ2siuxDo6sQi6OPoEBhPV3VAIsZlyeMmwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJFa8lPl141cwOMFWE77IfqynXsm3q57wU3UY8xcGIYBl+nfqQ00EK3S2i4xKXT6oCtjHWA3Exxx1PAmf3D4WkxXOyo8Idy0SFMCm5EcrWN8yaEikNtIqmfHVAv0kIETcrk6YRT7mUB2KH+7g0zy7QdEmHbqbTgMqn+zAB1QBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCshoAtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCshoAtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB27DC19423;
	Sat, 28 Feb 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302449;
	bh=6eP2Y0M2FJ2siuxDo6sQi6OPoEBhPV3VAIsZlyeMmwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCshoAtl8LplLFwfuGRfHOVf16ScYslcVJjF/uqnoGRNWRWsPJNejqOeVERIAkck4
	 FeuiK6omc0siyUkAAABezt4UoSKP8Wf7vuJc1MnxPKWDV99XD0iUFh5aqdlnnJj4aW
	 0RhGD0A/tTgWYOVjHV57holy1FI6BrTxFj/C4Xn25ncZ6tbehUD3shL8BC2Ri6fWIv
	 1Qry+mB82jWQtR019VDvOVNOxiTXegaKRGpWdGFSzvVR4MW5yaO0f9YUXaJEGG0XSj
	 QviyS0FxMdYM90EKbxsl3b5Nqm3SgsdT66l6t2gbXs8Agz4W1U3KznLV0HTbTN/0AL
	 IzrYVbuRc4SGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/232] serial: SH_SCI: improve "DMA support" prompt
Date: Sat, 28 Feb 2026 13:10:42 -0500
Message-ID: <20260228181127.1592657-189-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 3c45956a1d454..32b4db13fa963 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -668,7 +668,7 @@ config SERIAL_SH_SCI_EARLYCON
 	default ARCH_RENESAS
 
 config SERIAL_SH_SCI_DMA
-	bool "DMA support" if EXPERT
+	bool "Support for DMA on SuperH SCI(F)" if EXPERT
 	depends on SERIAL_SH_SCI && DMA_ENGINE
 	default ARCH_RENESAS
 
-- 
2.51.0

