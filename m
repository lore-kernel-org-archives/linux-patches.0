Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5B1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F49C433C9;
	Mon, 11 Sep 2023 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441527;
	bh=RNTRAJ+oO9ZwMceK7tD6sQD6re5V2d8HREPn+uMCRb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdPl0v1Ly+ElKV6ENHNTKFKHnNf2blsFNduWDJjc7c+ZdaTk3Pw/UhXBuxaCodvQp
	 4bXQQBZkHmSp1JxhXg8xsLNfud3ipdLpL4UNPWqbX/Kc95Vbj2c3GiRztppbpKxA6d
	 lwLPlsmO7HjzaMaN0v1xS8havwxzwujdoikA+dx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 445/739] clk: qcom: Fix SM_GPUCC_8450 dependencies
Date: Mon, 11 Sep 2023 15:44:04 +0200
Message-ID: <20230911134703.594502272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 75d1d3a433f0a0748a89eb074830e9b635a19fd2 ]

CONFIG_SM_GCC_8450 depends on ARM64 but it is selected by
CONFIG_SM_GPUCC_8450, which can be selected on ARM, resulting in a
Kconfig warning.

WARNING: unmet direct dependencies detected for SM_GCC_8450
  Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=y] && (ARM64 || COMPILE_TEST [=n])
  Selected by [y]:
  - SM_GPUCC_8450 [=y] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=y]

Add the same dependencies to CONFIG_SM_GPUCC_8450 to resolve the
warning.

Fixes: 728692d49edc ("clk: qcom: Add support for SM8450 GPUCC")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230829-fix-sm_gpucc_8550-deps-v1-1-d751f6cd35b2@kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index ed7dc3349e34e..92ef5314b59ce 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -987,6 +987,7 @@ config SM_GPUCC_8350
 
 config SM_GPUCC_8450
 	tristate "SM8450 Graphics Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SM_GCC_8450
 	help
 	  Support for the graphics clock controller on SM8450 devices.
-- 
2.40.1



