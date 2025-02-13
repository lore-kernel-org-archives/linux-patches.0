Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0C2165F1F;
	Thu, 13 Feb 2025 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460280; cv=none; b=ViHIU2rUz14ZyBMR1o7qaWt3J8vi+mozuifbQ+xS4UarHAUUPuSygxMPxU+dbHLh/sUCptpilD99Ft8EhVgTgrgvTFvJ1g9Hjv9eZ/dHpIiYw97jYB+k3Vt5e0XDBPnQgIhWnUxItGOXb3cxyfPPEwKa00GKVpwR3NPs1TVsPTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460280; c=relaxed/simple;
	bh=ZSGMGHyfC7l2RxkWfiIqZnf3hcxiWs13A765XAgihuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9kzlVZQ/5cHl1+bBFrNBz20eUx7rJyxJyDhldoIpu8oZX8PT+1qgoQ7RHL4XbJTBUCPs4Du3wlvJHB8l77K+qyUG+qm2JY7HAypJ7eX8/ViTsfN286hylSDyb6wf2vqKFh1uVYENPzXuZOV/5mV9mM6paB27A0KBCD/p+m+OeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN9MrI3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN9MrI3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6BC4CEE4;
	Thu, 13 Feb 2025 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460279;
	bh=ZSGMGHyfC7l2RxkWfiIqZnf3hcxiWs13A765XAgihuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN9MrI3gFR2hBOMfcHqd4RzgdD54JZbdEujwObgCUxqCTgrp299RV0R5oKkiTeFUw
	 RLGlH3NxMtoM0q9eiH6PwxF7cRLUqcKmi6OxY/aG7zVF2WpuQvFP8/pL64C0/nc8Kh
	 Twn1mMe0Z91SVa07G03F0up4kpfaLfNUw/1gMzpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/273] clk: qcom: Make GCC_8150 depend on QCOM_GDSC
Date: Thu, 13 Feb 2025 15:26:46 +0100
Message-ID: <20250213142408.702932137@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 1474149c4209943b37a2c01b82f07ba39465e5fe ]

Like all other non-ancient Qualcomm clock drivers, QCOM_GDSC is
required, as the GCC driver defines and instantiates a bunch of GDSCs.

Add the missing dependency.

Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Closes: https://lore.kernel.org/linux-arm-msm/ab85f2ae-6c97-4fbb-a15b-31cc9e1f77fc@linaro.org/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20241026-topic-8150gcc_kconfig-v1-1-3772013d8804@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index a79b837583894..1de1661037b1b 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -881,6 +881,7 @@ config SM_GCC_7150
 config SM_GCC_8150
 	tristate "SM8150 Global Clock Controller"
 	depends on ARM64 || COMPILE_TEST
+	select QCOM_GDSC
 	help
 	  Support for the global clock controller on SM8150 devices.
 	  Say Y if you want to use peripheral devices such as UART,
-- 
2.39.5



