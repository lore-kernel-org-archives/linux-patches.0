Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB151863F;
	Mon, 27 May 2024 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837334; cv=none; b=sxpWjNMMN9AX/GO5w9COOUPgOPdUT/Ub+m4bV3fZbLppZaPe0S4D3IeGqRcURdGQ7qGgK/40s/1rPIeuJ15kRk7dxYjvjJ/n0zYSGxTCHH3azrrFmEBZBV5RP3BSrEr0FMxzhQ3ZkGc6Tc8W2JALiEK0Ghw7bsE1Iu/ej/yB1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837334; c=relaxed/simple;
	bh=g2isR0jjffFD6EfSmd9dVW/ZpViYbza+TaqAG4HeEYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb2XDuUgoc8ooAR/hqB5QDINzcNzbdkGiPDQ8inyNd3h8HYYBRWORY3UTbS702O1MWbL3f+Uc31XJAYk5bnjkLD1NEjRl1txcg1KYaczKyBAV5YvcK1Eff1e7AXkKCXi6wKH/7rSTrsHPi/jZK0KRxVJoITUXY39bRxFFh9Id6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIonqk2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIonqk2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB08C32781;
	Mon, 27 May 2024 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837333;
	bh=g2isR0jjffFD6EfSmd9dVW/ZpViYbza+TaqAG4HeEYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIonqk2uKFj8E+zR7csNsiUvcWicpbB9XftU6XyOZw1HpAUNEFg1NxdIWOG6ONtEY
	 jk3cRB7Bn2hvFX3mWkZR329dVLjcBrClbbkV+zpfYNYwhLM4X7u3wBL9D8fas6n0EX
	 ncVatEsojFSMSbYTB8f1HjDEeC23mZfULRjIIUJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 399/427] clk: qcom: Fix SM_GPUCC_8650 dependencies
Date: Mon, 27 May 2024 20:57:26 +0200
Message-ID: <20240527185635.066925135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 07fb0a76bb757990b99fc2ab78ad7d1709cc441d ]

CONFIG_SM_GCC_8650 depends on ARM64 but it is selected by
CONFIG_SM_GPUCC_8650, which can be selected on ARM, resulting in a
Kconfig warning.

WARNING: unmet direct dependencies detected for SM_GCC_8650
  Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=y] && (ARM64 || COMPILE_TEST [=n])
  Selected by [y]:
  - SM_GPUCC_8650 [=y] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=y]

Add the same dependencies to CONFIG_SM_GPUCC_8650 to resolve the
warning.

Fixes: 8676fd4f3874 ("clk: qcom: add the SM8650 GPU Clock Controller driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240318-fix-some-qcom-kconfig-deps-v1-2-ea0773e3df5a@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index b9ff32cab329b..1bb51a0588726 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1095,6 +1095,7 @@ config SM_GPUCC_8550
 
 config SM_GPUCC_8650
 	tristate "SM8650 Graphics Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SM_GCC_8650
 	help
 	  Support for the graphics clock controller on SM8650 devices.
-- 
2.43.0



