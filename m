Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3388E3FE2D;
	Mon,  1 Apr 2024 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986634; cv=none; b=l4TxsS9rTJksKfxFXjZ1XHWgXQ1tK+aDjzFIxVR7weK9/a/Imbnae7B0LfSUzr7rpc1R1U6RTNMbYbyZExceCNMfpdmRApctlJe/w+598gAP6y7+dfaTL5j5+qHFGJ5fSMBFJGXuc/ZDXD88Os0AxEW7tE6GpNzb6upGAUM2G+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986634; c=relaxed/simple;
	bh=90mzQLLJUOafwL4Owvp9kZDncLP15coSCvGahuf0PNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF0AYzcqjQiIv4dK6OxiC6TaDxiaKLPJBt6Bo45ElPvup293VVM07W9DjjLhUi0RqgpKiFKa19msYNkgWbB5sO8OHkOaqWgsk9TdY5I4wQ4s4N/OtKNhHp1CTKr2o+XEFq7b87RttHsOZRwkr7OJiLLmBK1nR002DSlyvxh49kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScyjCsz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScyjCsz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4EFC433F1;
	Mon,  1 Apr 2024 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986633;
	bh=90mzQLLJUOafwL4Owvp9kZDncLP15coSCvGahuf0PNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScyjCsz57gBi379RKD7P3KurIiSQdneM2ibKYQ4LTJXJ/LUWHI4fKGnld2jytzbyS
	 ScYs7Fs36PxormisoQN3YF3KwmmJMLTi+ryCmQcp6CMITFH7BdcBs7LnLdmbTqsxac
	 ur5LEnn99cJVTFvzY2QLziKz+q5Ca8W9dcLlkJXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 007/399] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Mon,  1 Apr 2024 17:39:33 +0200
Message-ID: <20240401152549.367327707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Amit Pundir <amit.pundir@linaro.org>

[ Upstream commit 1d9054e3a4fd36e2949e616f7360bdb81bcc1921 ]

With the addition of RPMh power domain to the GCC node in
device tree, we noticed a significant delay in getting the
UFS driver probed on AOSP which futher led to mount failures
because Android do not support rootwait. So adding a soft
dependency on RPMh power domain which informs modprobe to
load rpmhpd module before gcc-sdm845.

Cc: stable@vger.kernel.org # v5.4+
Fixes: 4b6ea15c0a11 ("arm64: dts: qcom: sdm845: Add missing RPMh power domain to GCC")
Suggested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240123062814.2555649-1-amit.pundir@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm845.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sdm845.c b/drivers/clk/qcom/gcc-sdm845.c
index 725cd52d2398e..ea4c3bf4fb9bf 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -4037,3 +4037,4 @@ module_exit(gcc_sdm845_exit);
 MODULE_DESCRIPTION("QTI GCC SDM845 Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:gcc-sdm845");
+MODULE_SOFTDEP("pre: rpmhpd");
-- 
2.43.0



