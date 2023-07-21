Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCC4200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6F2C433C8;
	Fri, 21 Jul 2023 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966253;
	bh=5w/SXJvSSN0lvDF8NdC5CubC4dBvV/ZW1pOyj+a4LPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kM+yaOl1jeDbwBIJzP6U5C0xvi51YfrKCSJN4w4yt1gfU+MZGdiekki48xAGxF5mK
	 myb70UDL1RvYAq01vQy+O2+05DNGmxFvf7rPTijopf+Ael8tHOnxV30uBiasjipAUP
	 Hdc2HTYjnVbor2m0TsBBQ13vOJ+7ZJRQ+eIKz+dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/532] clk: qcom: ipq6018: fix networking resets
Date: Fri, 21 Jul 2023 18:03:02 +0200
Message-ID: <20230721160629.459530347@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 349b5bed539b491b7894a5186a895751fd8ba6c7 ]

Networking resets in IPQ6018 all use bitmask as they require multiple
bits to be set and cleared instead of a single bit.

So, current networking resets have the same register and bit 0 set which
is clearly incorrect.

Fixes: d9db07f088af ("clk: qcom: Add ipq6018 Global Clock Controller support")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230526190855.2941291-2-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq6018.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq6018.c b/drivers/clk/qcom/gcc-ipq6018.c
index 5c5d1b04ea7af..cde62a11f5736 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -4517,24 +4517,24 @@ static const struct qcom_reset_map gcc_ipq6018_resets[] = {
 	[GCC_PCIE0_AHB_ARES] = { 0x75040, 5 },
 	[GCC_PCIE0_AXI_MASTER_STICKY_ARES] = { 0x75040, 6 },
 	[GCC_PCIE0_AXI_SLAVE_STICKY_ARES] = { 0x75040, 7 },
-	[GCC_PPE_FULL_RESET] = { 0x68014, 0 },
-	[GCC_UNIPHY0_SOFT_RESET] = { 0x56004, 0 },
+	[GCC_PPE_FULL_RESET] = { .reg = 0x68014, .bitmask = 0xf0000 },
+	[GCC_UNIPHY0_SOFT_RESET] = { .reg = 0x56004, .bitmask = 0x3ff2 },
 	[GCC_UNIPHY0_XPCS_RESET] = { 0x56004, 2 },
-	[GCC_UNIPHY1_SOFT_RESET] = { 0x56104, 0 },
+	[GCC_UNIPHY1_SOFT_RESET] = { .reg = 0x56104, .bitmask = 0x32 },
 	[GCC_UNIPHY1_XPCS_RESET] = { 0x56104, 2 },
-	[GCC_EDMA_HW_RESET] = { 0x68014, 0 },
-	[GCC_NSSPORT1_RESET] = { 0x68014, 0 },
-	[GCC_NSSPORT2_RESET] = { 0x68014, 0 },
-	[GCC_NSSPORT3_RESET] = { 0x68014, 0 },
-	[GCC_NSSPORT4_RESET] = { 0x68014, 0 },
-	[GCC_NSSPORT5_RESET] = { 0x68014, 0 },
-	[GCC_UNIPHY0_PORT1_ARES] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT2_ARES] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT3_ARES] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT4_ARES] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT5_ARES] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT_4_5_RESET] = { 0x56004, 0 },
-	[GCC_UNIPHY0_PORT_4_RESET] = { 0x56004, 0 },
+	[GCC_EDMA_HW_RESET] = { .reg = 0x68014, .bitmask = 0x300000 },
+	[GCC_NSSPORT1_RESET] = { .reg = 0x68014, .bitmask = 0x1000003 },
+	[GCC_NSSPORT2_RESET] = { .reg = 0x68014, .bitmask = 0x200000c },
+	[GCC_NSSPORT3_RESET] = { .reg = 0x68014, .bitmask = 0x4000030 },
+	[GCC_NSSPORT4_RESET] = { .reg = 0x68014, .bitmask = 0x8000300 },
+	[GCC_NSSPORT5_RESET] = { .reg = 0x68014, .bitmask = 0x10000c00 },
+	[GCC_UNIPHY0_PORT1_ARES] = { .reg = 0x56004, .bitmask = 0x30 },
+	[GCC_UNIPHY0_PORT2_ARES] = { .reg = 0x56004, .bitmask = 0xc0 },
+	[GCC_UNIPHY0_PORT3_ARES] = { .reg = 0x56004, .bitmask = 0x300 },
+	[GCC_UNIPHY0_PORT4_ARES] = { .reg = 0x56004, .bitmask = 0xc00 },
+	[GCC_UNIPHY0_PORT5_ARES] = { .reg = 0x56004, .bitmask = 0x3000 },
+	[GCC_UNIPHY0_PORT_4_5_RESET] = { .reg = 0x56004, .bitmask = 0x3c02 },
+	[GCC_UNIPHY0_PORT_4_RESET] = { .reg = 0x56004, .bitmask = 0xc02 },
 	[GCC_LPASS_BCR] = {0x1F000, 0},
 	[GCC_UBI32_TBU_BCR] = {0x65000, 0},
 	[GCC_LPASS_TBU_BCR] = {0x6C000, 0},
-- 
2.39.2



