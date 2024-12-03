Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B5123CE;
	Tue,  3 Dec 2024 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241826; cv=none; b=eQd3IA813fXaQt7cbTcpUPxM55Iq5NOBE30LY9/niFu/oNjfaTRAnQdBWLcQ+0bndFoHxv6QxOCbITiIIgqhhnlbMUpK5ooleveJ/6fAu7bRDQlF+Ex6izwFOz+JKwtRwCB9QDoyt07FflxV+IKyQncqTifARtz+RRWHcQlPhZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241826; c=relaxed/simple;
	bh=OUq1uUE4RCylziVipS0TpLKsForytiOZHgrIZ9YnrEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZP1E5QjQZaglE9a5YVTdYgU0yKOSCC5FPHAgHXrWA7wH86ORQ0cfHoadYSBJdGRyqRgPRKb89ChYoEggWLhCB7Lbu2NX3EKiN2V2llD2IxiCOyh5GtEL9w19+fZ99skx5hQUgPN7F4/aKtdGcWEGzwYWF0trhnlNjd9fHlXP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnpl9Ak/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnpl9Ak/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B4BC4CECF;
	Tue,  3 Dec 2024 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241826;
	bh=OUq1uUE4RCylziVipS0TpLKsForytiOZHgrIZ9YnrEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnpl9Ak/NxeBo5Gf/3RIR+eMZSC9zm1QaNQkmbwNsl+Ef/S8/xjkYNF+Wr7oOIScq
	 sZ9Dv/WhYDVvuUCyDKYzeX6dOVvLFVlZzjebWlrqG1x8pxWqvhEgwbqzA0zPNFASb6
	 IjU0SoLrr8zku7v+v9vwve31+GBM1xo0+JnY7B90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/826] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Tue,  3 Dec 2024 15:43:58 +0100
Message-ID: <20241203144803.689701955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 019f244395464..9c91ecdafc453 100644
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



