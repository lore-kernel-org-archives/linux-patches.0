Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F43438A8;
	Thu, 17 Sep 2026 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661005; cv=none; b=o5tDKwuTKsb8pa/AlJiU1n2urk8bcOFTrk53tWkdXMKPnK0anHdkEWdMY2IgUzeyihiIEf/De54E6KNIy67EsetCzfPGwtfH66CTxzmCCDRN38J7PhX5GaMzPF2s8dWuShIcTbrh4XMkl60BxlYR1fXjw7Ot0RHaogPeA6P1/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661005; c=relaxed/simple;
	bh=3YJkzjdh1Hpn7OE9BY2KQPstwCYF4hw+J81MU3s0qwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sg/g/s/zsBasfDFv4KMip1yRiKXg2O8FsXSh7ufuGqan+xWKfQ9t70LJSq2k1/CZ5lyOirVbc6ZPHFHIZsClC+8o1ymWDgfRMykfPHlIWYiIhsAMoBMXkNE6fX33Q+rWM8tQ28cNecgRC7cbdA+/xFq1kevN5mU+7/SHu+PTIbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgzHz80P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgzHz80P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9A41F00893;
	Thu, 17 Sep 2026 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661003;
	bh=jjaQenFmpJwtCoPC/3sfMHOgo5VDfcJoaGT7hsZJ0A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgzHz80PGadvqd1B06lCFeIUMYxgcJ2S6wE7XJ0u3dGGC9OcLUSwUGCAhIp/KRIeZ
	 3beDw5fucO5FM1W6aFgVMPzUDJWA/uOj3ZM3H1uu2CFU2iwyoD6TqXwYncNNpp+OJi
	 2UNinZw//tW5Fkr5gArXlpdQb90qIpBpwawe3Mpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0033/1250] clk: clk-axi-clkgen: Add support versal timings
Date: Thu, 17 Sep 2026 15:57:08 +0100
Message-ID: <20260917151552.831843545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 0aef2f0db6db22c2a441e067d8e8458106fb0483 ]

Add proper VCO and PFD limits for versal based platforms. For that we
need to add new Technology and Speed grade defines.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-axi-clkgen.c   | 5 ++++-
 include/linux/adi-axi-common.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index fa5ccef73e60d..26f76a6db8202 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -521,7 +521,7 @@ static int axi_clkgen_setup_limits(struct axi_clkgen *axi_clkgen,
 		axi_clkgen->limits.fvco_max = 1200000;
 		axi_clkgen->limits.fpfd_max = 450000;
 		break;
-	case ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2LV:
+	case ADI_AXI_FPGA_SPEED_2 ... ADI_AXI_FPGA_SPEED_2MP:
 		axi_clkgen->limits.fvco_max = 1440000;
 		axi_clkgen->limits.fpfd_max = 500000;
 		if (family == ADI_AXI_FPGA_FAMILY_KINTEX || family == ADI_AXI_FPGA_FAMILY_ARTIX) {
@@ -546,6 +546,9 @@ static int axi_clkgen_setup_limits(struct axi_clkgen *axi_clkgen,
 	if (tech == ADI_AXI_FPGA_TECH_ULTRASCALE_PLUS) {
 		axi_clkgen->limits.fvco_max = 1600000;
 		axi_clkgen->limits.fvco_min = 800000;
+	} else if (tech == ADI_AXI_FPGA_TECH_VERSAL) {
+		axi_clkgen->limits.fvco_max = 4320000;
+		axi_clkgen->limits.fvco_min = 2160000;
 	}
 
 	return 0;
diff --git a/include/linux/adi-axi-common.h b/include/linux/adi-axi-common.h
index 37962ba530dfc..e7ba393061ee6 100644
--- a/include/linux/adi-axi-common.h
+++ b/include/linux/adi-axi-common.h
@@ -51,6 +51,7 @@ enum adi_axi_fpga_technology {
 	ADI_AXI_FPGA_TECH_SERIES7,
 	ADI_AXI_FPGA_TECH_ULTRASCALE,
 	ADI_AXI_FPGA_TECH_ULTRASCALE_PLUS,
+	ADI_AXI_FPGA_TECH_VERSAL,
 };
 
 enum adi_axi_fpga_family {
@@ -71,6 +72,7 @@ enum adi_axi_fpga_speed_grade {
 	ADI_AXI_FPGA_SPEED_2    = 20,
 	ADI_AXI_FPGA_SPEED_2L   = 21,
 	ADI_AXI_FPGA_SPEED_2LV  = 22,
+	ADI_AXI_FPGA_SPEED_2MP  = 23,
 	ADI_AXI_FPGA_SPEED_3    = 30,
 };
 
-- 
2.53.0



