Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019854;
	b=mBSKn3+/hrOCwK9T6huOekvteJ9338R8z7KDy69fSKFnAwQc4ohgv9BUkuetdNjelN1J
	 R89Ple0y8gq/wYb0PyHvleu085ZiaQwcYnVYm9DVvpfKErCrguc0BLt0bPMEbQ2QqrIiE
	 bF0ZUxtrPTB6U2oPpr9k5wqaqChtLO+6BBBy07YgJakMiSwHgBlIJc82zp9qgteeo/FwZ
	 LEb8hbitXIjtgGwaHhtL91QF4mpy9vYUPki706h40OD7vgXIGnawzW//ekyKbqS8uCCqG
	 dRfx2SvavebuYyaXbpegsOUjSP4UtwKrSc28YUB2LRVSWV4Nu1dkPX7bHYCObEcpyAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OcerZlwnZIvfevzP7rjZB+A1BQqrtotkDtF/TGQJpPs=;
	b=cQVC0kxRU4V2FxuWMwQoLNRyjvu8kVf53rePTFkjGcN7pqxfUAnY3NUId0spk48u71yX
	 ScW409Hz/5eXIF3HuTf6Ef8ZmSqdMIwwS7nE1o+TDqm4YTwr4iI+lbZjrdAgWVUII4kWp
	 JLZZ9EKz2ejyBsRhkDrjgT9HbTeXqOMXYxTfrR+5nqwDnRUwYX0hCs+9XsSsr1h/WLgVR
	 CqE/vVcLryP3v263lxjLxgOYL/8Zn11t4fEK/5bVKmCG1WgEVwRdKUjX3okODdEOwNjC1
	 zd3S5cMkDiMnIUVq7glV4+JVQ3eZmxLf9P+zvzbvL3vQqNkS1lqjrXJE9jqnD/07Dew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HifXRKiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3320260A261D;
	Wed, 18 Nov 2026 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HifXRKiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4019A1F000C4;
	Wed, 18 Nov 2026 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019853;
	bh=OcerZlwnZIvfevzP7rjZB+A1BQqrtotkDtF/TGQJpPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HifXRKiPkBlP2shh2n5Rx2z2OnM0RSY40v6Q+eN9N+OBGqDlVHB5jgjEPFsOBEj5d
	 2aKldNAIZHOesJBPTss1JIsfptZqUvymzWPnjtqPYdBhMJ7XITb0/XO+pb7gYxs+ym
	 bmZ/FG8exhctamK4lGV+LOgqkfAF32ecLF34rCgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1742/2651] clk: qcom: gcc: Fix GPLL enable register offset for Nord SoC
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118150350.272866201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit e297cf5b7601b7a41693eba2d9bc8f036e417bf7 ]

The GPLLs in the North-East, North-West and South-East global clock
controllers on the Qualcomm Nord SoC were registered with a placeholder
enable register offset of 0x0. As a result the shared PLL voting register
was never programmed, leaving the PLLs' enable state uncontrolled.

Point each GPLL at its actual GPLL_ENABLE register (0x57010 for the
North-East and South-East controllers, 0x76008 for the North-West
controller). Each PLL continues to select its own vote bit through
enable_mask.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-nord_gcc_offset_fix-v1-1-230ffad2dae9@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/negcc-nord.c | 4 ++--
 drivers/clk/qcom/nwgcc-nord.c | 2 +-
 drivers/clk/qcom/segcc-nord.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/qcom/negcc-nord.c b/drivers/clk/qcom/negcc-nord.c
index 0db284edc4e41..ef9ff450bcd44 100644
--- a/drivers/clk/qcom/negcc-nord.c
+++ b/drivers/clk/qcom/negcc-nord.c
@@ -46,7 +46,7 @@ static struct clk_alpha_pll ne_gcc_gpll0 = {
 	.offset = 0x0,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "ne_gcc_gpll0",
@@ -85,7 +85,7 @@ static struct clk_alpha_pll ne_gcc_gpll2 = {
 	.offset = 0x2000,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(2),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "ne_gcc_gpll2",
diff --git a/drivers/clk/qcom/nwgcc-nord.c b/drivers/clk/qcom/nwgcc-nord.c
index 280558f15748c..1eb8e53139120 100644
--- a/drivers/clk/qcom/nwgcc-nord.c
+++ b/drivers/clk/qcom/nwgcc-nord.c
@@ -36,7 +36,7 @@ static struct clk_alpha_pll nw_gcc_gpll0 = {
 	.offset = 0x0,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x76008,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "nw_gcc_gpll0",
diff --git a/drivers/clk/qcom/segcc-nord.c b/drivers/clk/qcom/segcc-nord.c
index 51d7f83e21b6b..98b53311d333c 100644
--- a/drivers/clk/qcom/segcc-nord.c
+++ b/drivers/clk/qcom/segcc-nord.c
@@ -39,7 +39,7 @@ static struct clk_alpha_pll se_gcc_gpll0 = {
 	.offset = 0x0,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "se_gcc_gpll0",
@@ -78,7 +78,7 @@ static struct clk_alpha_pll se_gcc_gpll2 = {
 	.offset = 0x2000,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(2),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "se_gcc_gpll2",
@@ -95,7 +95,7 @@ static struct clk_alpha_pll se_gcc_gpll4 = {
 	.offset = 0x4000,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(4),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "se_gcc_gpll4",
@@ -112,7 +112,7 @@ static struct clk_alpha_pll se_gcc_gpll5 = {
 	.offset = 0x5000,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x57010,
 		.enable_mask = BIT(5),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "se_gcc_gpll5",
-- 
2.53.0



