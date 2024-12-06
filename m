Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B207753A7;
	Fri,  6 Dec 2024 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497710; cv=none; b=tYutQZlE+srtbvAPr9upzkE9Gn7j2P8CzB3y4Cn19K6Vae1W57/M55GtQR9n8QM6BCnVp3G4rN3zuHaPNAjppLrmMriquNGV1ObQfPaDBdVu6f3TvyI1b6Fs5UHWcjYh2TBEDx5We++F1rih26YjsELV4pgcw5dlevWgauuY+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497710; c=relaxed/simple;
	bh=+01wnaOqAmqcCeU4xOoNj5fJNJEcA8cZg4aeTfh92w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oflWE89yIhOAPjSsvGGJhELxxorF+R0Oqfv7KjVI922sMcipP9IFnET1QPMWgZtwOecEwUDfeXxrOhyWdh4NLZFmjeMgb2BjIxjMKs8aeA2NLz+IT8u+OjlraoX0kXDQQaf1nRZyDjd0wCwKG4Yb43suVWD0MUOVZhUIuSslZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYsYW3vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYsYW3vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376DBC4CED1;
	Fri,  6 Dec 2024 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497710;
	bh=+01wnaOqAmqcCeU4xOoNj5fJNJEcA8cZg4aeTfh92w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYsYW3vIz60D7o3CSK/G7MyBFyNIllMD3jTldUbGGgXJGc/D2rq27qTyj87CZFi9i
	 flUhNkkrHdIWOmq1D6WLx4HvRVNcR1bKShsgqQZh4pJ4DTkRGX0uFlm2zjU1mH4RbN
	 NYpTDtGNyo9gC8DFDiMjNINBr1t5R2+qMpfioDjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 370/676] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Fri,  6 Dec 2024 15:33:09 +0100
Message-ID: <20241206143707.799544899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

[ Upstream commit f212140962c93cd5da43283a18e31681540fc23d ]

Fix a typo in the CONFIG_M5441x preprocessor condition, where the GPIO
register offset was incorrectly set to 8 instead of 0. This prevented
proper GPIO configuration for m5441x targets.

Fixes: bea8bcb12da0 ("m68knommu: Add support for the Coldfire m5441x.")
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mcfgpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
index 7abd322c019fc..295624d01d3dc 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -136,7 +136,7 @@ static inline void gpio_free(unsigned gpio)
  * read-modify-write as well as those controlled by the EPORT and GPIO modules.
  */
 #define MCFGPIO_SCR_START		40
-#elif defined(CONFIGM5441x)
+#elif defined(CONFIG_M5441x)
 /* The m5441x EPORT doesn't have its own GPIO port, uses PORT C */
 #define MCFGPIO_SCR_START		0
 #else
-- 
2.43.0



