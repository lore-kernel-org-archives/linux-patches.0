Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547FA15FCFB;
	Mon, 27 May 2024 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838612; cv=none; b=Rlbj03V0RV2AQkDWAwgsdTgd3hADp4rIUl3EK3IsZcsrTkHII/7n5gThIy1gse3/Irf3DDEN1GW+4bYIf7UpQOXAQDL79kUh3cesMenSJGdm4wIyVZow/qS5lTAKRMH0ZOPAn6T3kjkPZb6+DWTXmWJUhpOY7UD3GIutqoe9kAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838612; c=relaxed/simple;
	bh=/4Vvo/aXdERodqZwGYrPCHesqpsErddK5X2A+8ptGbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDJpsTWrYzz0+XOYvFA+HirR9L/tiIgz6eILBNXrRHTk20Q77Ki6PtmNVd36yrSY0dVzUr9vnH1mcfg8H601MK33Rz2Nhl88cWiWLNnZniOlt8tflK5ieBiGMMIP2pxkdGfetxa2RgegaKypuZLSZnSna4tZ4FyAYOKfAMb9+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya2riV0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya2riV0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE13FC2BBFC;
	Mon, 27 May 2024 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838612;
	bh=/4Vvo/aXdERodqZwGYrPCHesqpsErddK5X2A+8ptGbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya2riV0BFbb64TutzDA5DIKQCMsOb1EtIiqR80i4LWysFAFrMuOvhfmFkAGvnmqOj
	 IKErTXG8FNoELnURdvtGZbar30Y9/xGcvNDy1LTAa9DlWjv35Z1uOheJAco96epVsG
	 eZMwM3CfFt6CWo1L6gdWkp/pnFKV4q9JYnW1/rF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 460/493] clk: qcom: Fix SC_CAMCC_8280XP dependencies
Date: Mon, 27 May 2024 20:57:42 +0200
Message-ID: <20240527185645.245446255@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e00f2540a581f8b8c165e5ae8afe52e4ad038550 ]

CONFIG_SC_GCC_8280XP depends on ARM64 but it is selected by
CONFIG_SC_CAMCC_8280XP, which can be selected on ARM, resulting in a
Kconfig warning.

WARNING: unmet direct dependencies detected for SC_GCC_8280XP
  Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=y] && (ARM64 || COMPILE_TEST [=n])
  Selected by [y]:
  - SC_CAMCC_8280XP [=y] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=y]

Add the same dependencies to CONFIG_SC_CAMCC_8280XP to resolve the
warning.

Fixes: ff93872a9c61 ("clk: qcom: camcc-sc8280xp: Add sc8280xp CAMCC")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240318-fix-some-qcom-kconfig-deps-v1-1-ea0773e3df5a@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 2a9da0939377a..67f1151a3d2b0 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -439,6 +439,7 @@ config SC_CAMCC_7280
 
 config SC_CAMCC_8280XP
 	tristate "SC8280XP Camera Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SC_GCC_8280XP
 	help
 	  Support for the camera clock controller on Qualcomm Technologies, Inc
-- 
2.43.0



