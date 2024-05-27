Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0115FCF0;
	Mon, 27 May 2024 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838616; cv=none; b=ob9/moX1YsFZn92j0lLz/9HcHZI7RwL9OYyYDv8S48THofyfBPwtuWWN5+epyHRt0WV0AiQn+//Q+oIqsaVR+HOM6vnFNL6KKg2fHZ/XSYhCOTh60z7PXGdYWgdcyciCVhB7zBf3LFvH//v1ryrzW3ZCW9GdJEuzQ/XCmjz8ebE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838616; c=relaxed/simple;
	bh=JaXQov4HeVG72utvQ6bHTC3hUYXkj7uM8dm0rF0ZOaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+Umg23eqve45P4oMFA9WPtLNU2QklwJ5++H1EpeQwr1QtjORVJuYvEmtv60cMqXBaGE8F4FWHC8vSU8dIC8AckgH9p+0ppUZL34f7mHooD+UmFKkxIIc7y6eTbAPpHnsMmUj1LVdiORFr+V/ZOSrsdu2bWs8UhQ2WiveqO+Elc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7ChPKV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7ChPKV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725FCC2BBFC;
	Mon, 27 May 2024 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838615;
	bh=JaXQov4HeVG72utvQ6bHTC3hUYXkj7uM8dm0rF0ZOaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7ChPKV7jZ+YZm7Deq2OmnJGiEbKBAIDmmjsIb+n8sfQcTSGPPcBWR/Fdb4x4Zw91
	 aWBf9zp5AzKxjchNj1IC5493X1WjSFWk1GcjTO3L+Qlf+q+cCGcewpqhxTpSR/5chz
	 noRinseFsJ7ygYnJDO/arjKgJdr1YbbmbqMZUBtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 461/493] clk: qcom: Fix SM_GPUCC_8650 dependencies
Date: Mon, 27 May 2024 20:57:43 +0200
Message-ID: <20240527185645.275969899@linuxfoundation.org>
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
index 67f1151a3d2b0..be35803c7a4bf 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1070,6 +1070,7 @@ config SM_GPUCC_8550
 
 config SM_GPUCC_8650
 	tristate "SM8650 Graphics Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select SM_GCC_8650
 	help
 	  Support for the graphics clock controller on SM8650 devices.
-- 
2.43.0



