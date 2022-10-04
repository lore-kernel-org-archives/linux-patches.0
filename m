Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2443533D9
	for <patches@lists.linux.dev>; Tue,  4 Oct 2022 17:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C531C433C1;
	Tue,  4 Oct 2022 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664904308;
	bh=sasLqGhQo4j9ufex5YiBIWLoMvKyuVWV0MBeqbDvZ3g=;
	h=From:To:Cc:Subject:Date:From;
	b=oVd0tnn6jqPG/B8KUJ83h2iIJ1F/T02MGE32o5XEctsGf1B7r9E/llZdihFLk43Yn
	 21s0GGw6HkwSg6+racMs/bf39cpHbjGuY4y8bJp6HYNLqaw/50thVE0xAJMvB8m5zZ
	 mIzTYDIp020NpFYgqZTAUrsp4Q0Jjk6FqHPI05QD8gOqh/o3FMuG+oaAP52LrT3Wq7
	 tNNRlLEyJUiTKicnli96kNYC6VYWo3aYNrASf8jfx1aRjksZocfwZv4OBq9lduNElA
	 5mT8DTa+SvQxp5q5CDlS/Kr6zQheuNcRmcYbGoTgelinx0edwSFGqHNTcZQmFbmeBu
	 kJ5Iln6MWQs1Q==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH] clk: qcom: gcc-sm6375: Ensure unsigned long type
Date: Tue,  4 Oct 2022 10:25:07 -0700
Message-Id: <20221004172507.1599130-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This PLL frequency needs a UL postfix to avoid compiler warnings on
32-bit architectures.

Fixes: 184fdd873d83 ("clk: qcom: Add global clock controller driver for SM6375")
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/qcom/gcc-sm6375.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sm6375.c b/drivers/clk/qcom/gcc-sm6375.c
index a3188c462a8b..89a1cc90b145 100644
--- a/drivers/clk/qcom/gcc-sm6375.c
+++ b/drivers/clk/qcom/gcc-sm6375.c
@@ -54,7 +54,7 @@ static struct pll_vco lucid_vco[] = {
 };
 
 static struct pll_vco zonda_vco[] = {
-	{ 595200000, 3600000000, 0 },
+	{ 595200000, 3600000000UL, 0 },
 };
 
 static struct clk_alpha_pll gpll0 = {

base-commit: c3db5128e80e1437cb08d0d41aeb7163004897e7
prerequisite-patch-id: eac168caa320346ed78dc95c27117106fc8dbc7f
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

