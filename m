Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F828135D;
	Thu, 27 Nov 2025 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255702; cv=none; b=umVpm8vahV7lOZYdLQysEtVJ4qD4GiBPPOL+4632uOwFoXqkEB6WDbgzVPuxX+T6wpxxeGSE/871iCVK20K+BpDwPWJpiLKeKjII2AFK/7HuVb1Xu0JtM15UZk5IPl7GVWN1wzqNBax3OBlxksTkGsPnA9/VY396ixW8yR9+Hdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255702; c=relaxed/simple;
	bh=8lzBBpdqN+JbJlg3lqlMyx3QRHHbttl1Du9MGIuHEh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFlxbAoILKtVRZ7W52qbQLhVi3NmSwibgqZ5Ymjohw9SvooAc9UI8NfWfHytSAbMY4XzCbWtYMx8A15FPRqfhBML7RJzEfRg/sWASgF4dEkqxdScawd31DAfAfghNnnUPAsOIVHq5keC2/tqQUXKJS6d1J3eHKVsKLzkzmTDqJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rboFXib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rboFXib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EF3C4CEF8;
	Thu, 27 Nov 2025 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255701;
	bh=8lzBBpdqN+JbJlg3lqlMyx3QRHHbttl1Du9MGIuHEh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rboFXib0aef68QMCZsr3uNpbJugC9UUtY1Zh7Ina9lsAQTrr2NgL8SqwHs4bl6r9
	 9lT1mPcsySNZSmFuRyPTx0Kcc5DyWkYnEFzDYEARhzfDiG1lAbWO/eTIkw5xdQVYB0
	 bltQbCeLv6ZxGvIAkrbbRG6WEG1eOWIIKIaCtpmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/175] clk: sunxi-ng: Mark A523 bus-r-cpucfg clock as critical
Date: Thu, 27 Nov 2025 15:45:37 +0100
Message-ID: <20251127144046.033402336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 1dba74abf3e2fa4484b924d8ba6e54e64ebb8c82 ]

bus-r-cpucfg clock is important for peripheral which takes care of
powering CPU cores on and off. Since this operation is done by firmware
(TF-A), mark it as critical. That way Linux won't interfere with that
clock.

Fixes: 8cea339cfb81 ("clk: sunxi-ng: add support for the A523/T527 PRCM CCU")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20251020152704.4804-1-jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
index 70ce0ca0cb7db..c5b0d4a2e397e 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
@@ -125,7 +125,7 @@ static SUNXI_CCU_GATE_HW(bus_r_dma_clk, "bus-r-dma",
 static SUNXI_CCU_GATE_HW(bus_r_rtc_clk, "bus-r-rtc",
 			 &r_apb0_clk.common.hw, 0x20c, BIT(0), 0);
 static SUNXI_CCU_GATE_HW(bus_r_cpucfg_clk, "bus-r-cpucfg",
-			 &r_apb0_clk.common.hw, 0x22c, BIT(0), 0);
+			 &r_apb0_clk.common.hw, 0x22c, BIT(0), CLK_IS_CRITICAL);
 
 static struct ccu_common *sun55i_a523_r_ccu_clks[] = {
 	&r_ahb_clk.common,
-- 
2.51.0



