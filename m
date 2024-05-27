Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F471863F;
	Mon, 27 May 2024 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837331; cv=none; b=Ka7+SU9G0Zqgt3dc4/KsaYg2O8eGLlTECKrjwMnBomkVciN6Dfp/uJZXry7Y39iNYPOyeuenhVsxPI/4BLAkEB5yAvdMdC4A8Bh72hCKJ08AxuytFJWJ5zDffNhVmxq1m15ZQjs9b+nC9lQ2CfjKV2U5QFAPgxr/4/QSI4hCmUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837331; c=relaxed/simple;
	bh=vg5erlRTLEPyenOg4yZaopLLSCtPM93tCQtSlJ5S3Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlrfblfIUUW0em+kCNrnZIQjcwiJQnJF3Wy/MozSHFaZNyLxXNdGhTGjeysBSSgaWdI/jbFuzF3rvgRnjOdeuTPtSXmdsjA0o7ohoeX9M/co9clO71zpbKUKyQJkZ0x3pJKupo2BoQVrNUvVlyPQON1UtK95zHDuDqOFFsv81eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUaNEYGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUaNEYGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC37C2BBFC;
	Mon, 27 May 2024 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837331;
	bh=vg5erlRTLEPyenOg4yZaopLLSCtPM93tCQtSlJ5S3Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUaNEYGnWkiBzYJ6/xw8JanBl66xTbjxeWhMy9gur1TqUJiyv+opSSvOB3TNid4+y
	 QXKUSNWDablAePRZWr54FbLFK0bb/G2xwl88vpwnXSIdBESUTD0vZLktMak/k97JyQ
	 xnQk/nsMib8amowcZLMGBVpwNytXH5hB6M2j/Fjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 398/427] clk: qcom: Fix SC_CAMCC_8280XP dependencies
Date: Mon, 27 May 2024 20:57:25 +0200
Message-ID: <20240527185635.033724960@linuxfoundation.org>
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
index 8ab08e7b5b6c6..b9ff32cab329b 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -474,6 +474,7 @@ config SC_CAMCC_7280
 
 config SC_CAMCC_8280XP
 	tristate "SC8280XP Camera Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SC_GCC_8280XP
 	help
 	  Support for the camera clock controller on Qualcomm Technologies, Inc
-- 
2.43.0



