Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755774E324B;
	Wed, 30 Sep 2026 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782496; cv=none; b=KNkvyc8r58W7/eTyR/iU8h/GDej/3vl79E2NXTP+r1DO5RkyvAIbQ/myvbu3YLGCu2VNboIb+LwE/sHBs2S7ZIumeq0Yq1icHM9xh6GJoVr/ytfCgEm+gLB5kDAHb/9oEx146c6idjHy/zNazNKnZDGm7C/4bE9h2m4lAfQmuVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782496; c=relaxed/simple;
	bh=C5J2xsg93/XPEOfgJgj1PpyRog+zZU+R4yRILYxWUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0JAPpHUov6v/ynngtXpkwHDy0G9kVeHy2HKhiQ4aZsfEZk/jolgV+ORaCqkQV9byxPyZsVsO1U3Wf3Y452thz9M2ZtjfY1YedfIhDzs86tFwLfg4QrlJmh9LTpZ73JMBbzfZ3axyxxQEG8tr6+xgQ/QCK2kRzsHD/zDGJz/jUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnbnrRHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnbnrRHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777651F00898;
	Wed, 30 Sep 2026 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782482;
	bh=5RfNlNHeCmuDaVICUEDsP2q4ww8PdfRSYJ4Y5AkXPOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnbnrRHQli4hQftoC99cMm9aU0ljRIA/O4I6LZNdDFlreLUK4lXIOovABLIzs67aV
	 Ccd1xhGAGdVc+7BJnDTWty3SSPKdVOqt+3YzJln5ICThIpHScc3twWnnq1m7/y9bcc
	 DqbNWLg7jX4OwupqArIwMaaS5KiEjMZ+egjpKeRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/595] clk: socfpga: agilex: implement l3_main_free_clk
Date: Wed, 30 Sep 2026 17:19:13 +0200
Message-ID: <20260930152349.026147130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 225636c2b5696..2ac87dcee45e4 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -247,6 +247,8 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
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



