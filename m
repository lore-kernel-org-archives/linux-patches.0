Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E41503BDA;
	Wed, 30 Sep 2026 17:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790774; cv=none; b=H7d8Fq0IyT8dp/QFXh8drrhEtLaJNFT1xDK0RkJ5n3Omodzy6v7Z4DpDo6WfS4o/4Mscs73KVJtPi/fx+pVa92sTBb2Bz2HKfdtJ5d7I97YwwG6UIbPVt96VLSgP2/keUU0fVDYc3IPLt5jtfgpQ0jSna3P6KSipU+b92TFoaYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790774; c=relaxed/simple;
	bh=q/0TzjMo/B9OPfjstF2TfjPyFv3IY8hcbd+JNONXcQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aViv/EhZr0IvpvDEzOWbzoVVnoUZPQCTRCosluQJARLbh7PzJ0OF+F0QIO8lAa9zchMgpL26HibWBR6SoQQxFMTFthzHHBSetAE7bBQFk+Cbx74iyOBROQcKSNjioM+GjhYYWdKbnKTfeFwgMipF75thcYNDFqI4enl3O2LtxhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlTUDCcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlTUDCcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC671F00899;
	Wed, 30 Sep 2026 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790773;
	bh=5HsqUOuHYZwjEuSgoIy/KTW/gyjapEIeTSo6MbR46zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlTUDCcPdcDY0P++yAUYq7XVL3x1IJAoSaxctxKGMrTyWESE3cIYH3YgWWCL9TGdT
	 XQ8t8k0rTtwvauprldsOKqlAFthyOS0IMCRuxMTqFYGuSDSK07qk4KH4znBBLfOEV+
	 egVCpj1iY5An+UHFuHRPGN5/VwvkM6SRzP5zHWNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/752] clk: socfpga: agilex: implement l3_main_free_clk
Date: Wed, 30 Sep 2026 17:18:57 +0200
Message-ID: <20260930152359.614983135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index bf8cd928c2283..55a0623d75511 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -260,6 +260,8 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
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



