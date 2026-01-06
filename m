Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E7B3644AD;
	Tue,  6 Jan 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722008; cv=none; b=vGXInAQkkzBvoWtnei1nOYycGnYUugvly3OkZIW5teX2ndCZFA9PhKQ4Jk+gObCNSFuARQdCSRpBQbeshhuwRZXgHax2pfsLdz6wT08X3h7Ii1GZoGrxGKGmRyiqGUDUB4QZu0HQ3NNgqOHuYMf7sybzxWSMqe0EE5WbXNe2S0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722008; c=relaxed/simple;
	bh=n8dTy3x2arQrjRywRtPNJ82lXfOl+kCQkEYsu3nQLK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3dDaNtdZS50xw8Tt9AfXpHSWVih2IV2UqKQhZpG/+byq6s6FyPsYTv+6rgqveFx4ETjewTKMAMrpptCh1fX3QknpNYasIT8VKtnZJQ5HL8CooXg73Z8WZfd/6o2Z8equ6wKjW0gaeWM3qSMOrQqXAITIKaWv/4FEHseGxB9+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gur4pw7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gur4pw7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8757BC116C6;
	Tue,  6 Jan 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722008;
	bh=n8dTy3x2arQrjRywRtPNJ82lXfOl+kCQkEYsu3nQLK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gur4pw7thSPlY3bmOPITSrn1MVQTpCbPbrowv5nb4C1AQz3/WLrHisoPg8cwkflcu
	 xFnONNGUtvF8blK+Eea83G9oWZusQ0/y6zj4aXRaZv6Z5BXTvXxjmOJ116DIO5U42L
	 /Qs0nv0u30xsyoW2JUfZjqyzZT9/UJSLwBZyOxxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 138/312] clk: qcom: Fix SM_VIDEOCC_6350 dependencies
Date: Tue,  6 Jan 2026 18:03:32 +0100
Message-ID: <20260106170552.834814578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit f0691a3f7558d33b5b4a900e8312613fbe4afb9d upstream.

It is possible to select CONFIG_SM_GCC_6350 when targeting ARCH=arm,
causing a Kconfig warning when selecting CONFIG_SM_GCC_6350 without
its dependencies, CONFIG_ARM64 or CONFIG_COMPILE_TEST.

  WARNING: unmet direct dependencies detected for SM_GCC_6350
    Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=m] && (ARM64 || COMPILE_TEST [=n])
    Selected by [m]:
    - SM_VIDEOCC_6350 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]

Add the same dependency to clear up the warning.

Cc: stable@vger.kernel.org
Fixes: 720b1e8f2004 ("clk: qcom: Add video clock controller driver for SM6350")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250930-clk-qcom-kconfig-fixes-arm-v1-1-15ae1ae9ec9f@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 78a303842613..ec7d1a9b578e 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1448,6 +1448,7 @@ config SA_VIDEOCC_8775P
 
 config SM_VIDEOCC_6350
 	tristate "SM6350 Video Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SM_GCC_6350
 	select QCOM_GDSC
 	help
-- 
2.52.0



