Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE14F7CCF;
	Wed, 30 Sep 2026 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784255; cv=none; b=YiTo4nadFbjZ1SHO3T+rUsMdGFWL3rVmQPbtoBLBCjyHNsLuCfqn0/3TXurcv4NHbCrmbrC4kFI9tZesk5gtybdSoICJHRl6uddY9E9ySjsfD4IB4C1+uvGiaOaJGM2ake1jORKK1MJTQKCBLWJEwapA5Dc5iRYekDc6gr9GqiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784255; c=relaxed/simple;
	bh=ZNvLEjxLcc7VDfrjNL1WaPZkbWrq13xBWHcXcQk2QD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDLafXqhujk9J21I93rjfcA+IMBfUZJMmLf7Y5mfqdFEkf3vamhuwmqi7h3gKz90M30NAN9w03ZBirEmJ1FiAiFHFh/zK45ZHc9PYeFFyREUftNZCX70phXtYtT33kr5cJgf9o4n2/6mo/Xk3jh6oJDt2pdSw/N2a4vHQ7t3Gtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qppu+Yeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qppu+Yeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350F71F00893;
	Wed, 30 Sep 2026 16:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784249;
	bh=BdXwS3ZJDT7wMxwgShPnEkh3UU8DlurGAnbZniJ+2gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qppu+YegPtU4VwrUI20j2HT3mL4oZ3G6Mfhf0caaZHv9ma/RKCDQuZFlR4bOtoos9
	 UMO8QhDVF0nyT93uWi9LXSN/swVYLk+s/dnD8+Nr4pPLXjWkgqcbJwwLmu9cH3I54b
	 ZAbcCl7hvz1SME+E6P0rNEK+3yT9SmQHaocxtaLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/982] clk: socfpga: agilex: implement l3_main_free_clk
Date: Wed, 30 Sep 2026 17:13:45 +0200
Message-ID: <20260930152418.722979202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74d21bd82710e..2408f9f33312f 100644
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



