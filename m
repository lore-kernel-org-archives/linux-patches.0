Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CEB4FE2D7;
	Thu, 17 Sep 2026 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667602; cv=none; b=bDxC7bUjARR2k61llgX0Bl2Zdw2kUVRAACDxH+quiACY9BTvT+MlqiRlr6jtacdGgVheZUc3pATSXzhAYxyg5c1zwE2ptWoPWANnfgx6NFnzNoI1PhtBCOMMYCzG7t6O4cNx6qMSumo7So5F5okK8tFPwxItYSSrhqakSKawSaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667602; c=relaxed/simple;
	bh=ytHtNiE1BnNPHl74szif3qqhoESD4ugnKWw0Iz5g+mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkrWUHtI5LX3aC6PEt/8Oku9HhpgL2umT1432URtTioQM6H32XeXIkofUmSkaMqOy/JK2IqnTU9BqRPjw2eUhSJVh/amt70Btv4YVjHQSdPrl5D3z2F6QVPPzEu3mKVPPiEI+V1pQmF22UE1ymn84LrTVsmIIOH1rk08Ul9b1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXdGKTEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXdGKTEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DA31F000FF;
	Thu, 17 Sep 2026 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667601;
	bh=QzdR2wy1e8hPvR4Mf4xg3X7zhjEGzb4LMEV8aLH4ye8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXdGKTEpBNKL10hxNJsttZquUQdeOo0u+Cxoq3SHOilYu/jmIaKr6scPSZpyXW3bC
	 z89cBp8LsQqGI2hzEMlaF0JDOq2tU3xzvGl5tf7lyRa63kk0sC/D/ig9heHoIuWeYG
	 yaYRRNb0obf81qcJq+acDiV2/DmtbzKlnruxUZuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0147/1102] clk: socfpga: agilex: implement l3_main_free_clk
Date: Thu, 17 Sep 2026 16:01:30 +0100
Message-ID: <20260917151543.217467294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>

[ Upstream commit 1e7f56205813a2c48cdb3e9a4b0a24f49fd9a548 ]

The AGILEX_L3_MAIN_FREE_CLK is defined in the dt-bindings header but
was never implemented in the clock driver. Per the Agilex TRM,
l3_main_free_clk has no divider or mux and is a fixed 1:1 derivative
of noc_free_clk that clocks most of the interconnect datapath.

Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-agilex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 8dd94f64756b9..2bdea1997b5ef 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -259,6 +259,8 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
 	   0, 0x3C, 0, 0, 0},
 	{ AGILEX_NOC_FREE_CLK, "noc_free_clk", NULL, noc_free_mux, ARRAY_SIZE(noc_free_mux),
 	  0, 0x40, 0, 0, 0},
+	{ AGILEX_L3_MAIN_FREE_CLK, "l3_main_free_clk", "noc_free_clk", NULL,
+	  1, 0, 0, 1, 0, 0},
 	{ AGILEX_L4_SYS_FREE_CLK, "l4_sys_free_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0,
 	  0, 4, 0x30, 1},
 	{ AGILEX_EMAC_A_FREE_CLK, "emaca_free_clk", NULL, emaca_free_mux, ARRAY_SIZE(emaca_free_mux),
-- 
2.53.0



