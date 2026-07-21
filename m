Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE4E44AB62;
	Tue, 21 Jul 2026 21:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670848; cv=none; b=RXFRvHEUhqzUNaG2UhU7fT1uNUrZHNZ+m+upiGiShnvenkeoSCy5VtsW/TH3nTV3AiFzQljxnIH4dh23yL0kX6BchrqXcv0C/50GA5zHCNCwAHY9RpnlfJ4QAaiK6SeB1KVkM8Uf2Pvo3Sa9PsVTWbxWRPnin8ThYuNtGyAL5Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670848; c=relaxed/simple;
	bh=m2HsMrqLwFxpd0nbwMatU9Ixcws5SIkvcGS1cztY7Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKyVAdkmFCDrc+0yg5DGZZ46LlkpRlHTnru3nrgF8bTuCYGWI+hPG3eLqpqhDp5tDamhdWGM5Rzs5yG4fOrm7ijehak2KOIx9p7DGdyWrGWKfY9xvogV16so6CeJBsYiATaDK1d8amS51no2dh+3uISqU2g2kgWGP5ZXQMY+/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4jk/Vwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4jk/Vwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8472F1F000E9;
	Tue, 21 Jul 2026 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670847;
	bh=jY8VYWmSZ3fPL39pAVXgMMqqp0FFlXXmiuPNWyuz5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4jk/VwkXS3tnjHsVdiFJa07nqAbtJS/Gs2r1+lDuSjf2WJVKk2hoN7i5wCm8IqTa
	 8l4zAUHJrsb0FC53J45WcKCCGVFcMV10Ir8LcAFMFvM788s45ZqCk5lkA0IDtRDVV9
	 zHHS1fEoziLTeAmTni3n5sQWtap6G1rCm4GFdz30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Abel Vesa <abel.vesa@nxp.com>,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/843] clk: imx: Add check for kcalloc
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152406.097050621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit ed713e2bc093239ccd380c2ce8ae9e4162f5c037 upstream.

As the potential failure of the kcalloc(),
it should be better to check it in order to
avoid the dereference of the NULL pointer.

Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220310080257.1988412-1-jiasheng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index d4cf0c7045ab27..be0493e5b494e6 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -173,6 +173,8 @@ void imx_register_uart_clocks(unsigned int clk_count)
 		int i;
 
 		imx_uart_clocks = kcalloc(clk_count, sizeof(struct clk *), GFP_KERNEL);
+		if (!imx_uart_clocks)
+			return;
 
 		if (!of_stdout)
 			return;
-- 
2.53.0



