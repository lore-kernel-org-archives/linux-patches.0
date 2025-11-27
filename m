Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E195213254;
	Thu, 27 Nov 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255708; cv=none; b=aKBBGljfi9yZ6NzWJjZVD9VONf4bHKGPVT8iRWtTu94ykIIjtyBBbYyXy4TqMh01siq/AT38Z8pQSNzkPICpIBKUF+R2J61alyqgGDIlM/30MErjNo8REUifF16ltc+JfJLa4UJrag0TkqY1W0Kc6ksenm35B10bt4aUQGsZ8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255708; c=relaxed/simple;
	bh=9Tws0BiIFDIV9JcywIK7MHstCX1FeRfnt/drZFW+sK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXEYtjBrVtP0Yj5IVWrreo8zPH+2tzpkDOavO6YvE8SUz9r16kZveUSbEMVqSZMz6Y27C4zzih/BHldinJlPyBxFDINUqNyRmaQC2SB8TSRJegNpY5s/1FuukXEiv+InTdcOvtNS3MbVXXpNPqfEBD/0G8VwBLhw1ugdyPmMLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsJ7tQVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsJ7tQVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348DC4CEF8;
	Thu, 27 Nov 2025 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255707;
	bh=9Tws0BiIFDIV9JcywIK7MHstCX1FeRfnt/drZFW+sK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsJ7tQVRFAs14pL/F80MxFJg4l2XUml5TTx/WxW8m9JKHCPHVltc4GsFaD2Tdz+Un
	 I7+JY7r7WyEVUUfo1XAW1b0RHHol5yYkYzSObXder216/Tf6StZZ5dyQrI4JnvAugV
	 CspB3dbQlkbyrGLaw1B5RrCSuhIztopsg9CnUCQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/175] clk: sunxi-ng: sun55i-a523-ccu: Lower audio0 pll minimum rate
Date: Thu, 27 Nov 2025 15:45:39 +0100
Message-ID: <20251127144046.105499506@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 2050280a4bb660b47f8cccf75a69293ae7cbb087 ]

While the user manual states that the PLL's rate should be between 180
MHz and 3 GHz in the register defninition section, it also says the
actual operating frequency is 22.5792*4 MHz in the PLL features table.

22.5792*4 MHz is one of the actual clock rates that we want and is
is available in the SDM table. Lower the minimum clock rate to 90 MHz
so that both rates in the SDM table can be used.

Fixes: 7cae1e2b5544 ("clk: sunxi-ng: Add support for the A523/T527 CCU PLLs")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251020171059.2786070-7-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
index 1a9a1cb869e23..9e0468fb012b6 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
@@ -299,7 +299,7 @@ static struct ccu_nm pll_audio0_4x_clk = {
 	.m		= _SUNXI_CCU_DIV(16, 6),
 	.sdm		= _SUNXI_CCU_SDM(pll_audio0_sdm_table, BIT(24),
 					 0x178, BIT(31)),
-	.min_rate	= 180000000U,
+	.min_rate	= 90000000U,
 	.max_rate	= 3000000000U,
 	.common		= {
 		.reg		= 0x078,
-- 
2.51.0



