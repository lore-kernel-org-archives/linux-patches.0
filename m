Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B768215B7
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 01:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44689C433D2;
	Thu, 23 Feb 2023 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677116328;
	bh=bNLHDlH6yDQLmQ8YuQKYOawIa8uHrdxhLzACJX0hLos=;
	h=From:To:Cc:Subject:Date:From;
	b=lJGlf3wNUcHVR5UBeF7qNVwHURa2UoL5tpzkdnZkaFqNyt+56xvabjA9onpByclxh
	 Yx9UaaTFlV2NJ9eOUvd7tFQ54lGRN5+fEXxylimaEmuLgiGSTG+DYLzG7RjkfLBeTY
	 f7om8L3XsMzjuLjA/5K+J4QepluGokljcNxzK/op4jvXvBhqZqAaeuXiUb6rHn7ncV
	 7dR11RWtIUwXradvsLH/gBO6w1r5kAsVkpzr6geWmejrEH6sFXPEoEadNRntElwECz
	 5+Enuxqolk8xOU03NXZJK3KvxHPZTzQHpP1ADQ4JPV0X9ue9OCpB1iJifssP4wZFZ6
	 VrCO0g/3raE4A==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH] clk: qcom: apcs-msm8986: Include bitfield.h for FIELD_PREP
Date: Wed, 22 Feb 2023 17:38:47 -0800
Message-Id: <20230223013847.1218900-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise some configurations fail.

Fixes: 027726365906 ("clk: qcom: add the driver for the MSM8996 APCS clocks")
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/qcom/apcs-msm8996.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/apcs-msm8996.c b/drivers/clk/qcom/apcs-msm8996.c
index 7ec4022c5b43..3e91e9e6da74 100644
--- a/drivers/clk/qcom/apcs-msm8996.c
+++ b/drivers/clk/qcom/apcs-msm8996.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bits.h>
+#include <linux/bitfield.h>
 #include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/module.h>
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

