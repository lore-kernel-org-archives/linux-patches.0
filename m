Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205E71474CF;
	Thu, 11 Apr 2024 10:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831486; cv=none; b=ZACbIBak/n9GyBLmsHVoGvXA/p7V3uGdQ+dhNAa+wADvP/YFX8D6Y8ENmxAOfbCxa53Yy+PRLursFWLhEIznN++/3qg/pERk9A4wCgKpqBt4r2j97XgU/E6E8UlD2WuDrODxg1oIqKTmocjzn6N3+SLLVRzeeER1MSzneSprz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831486; c=relaxed/simple;
	bh=RdIF4nHouyLOKQA2ucreemTGRrrb1T+FjfDV5xhHCZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc92XbrtjopcnY7fNlKOa7yil0Z5MUExznFaR4BCHHsSijL+QVsrIiy9DkLeBvwq5eR7UJH/bU70As8aahpTavvrJz0Gg2dGUWwDzxV16fMnId1qZ0HhhKkcOZnNYnfmn8opIW4SDY1LWkGz8uaKAyHyba57wQLALT4uAgLRXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS1RdoBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS1RdoBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C6EC433F1;
	Thu, 11 Apr 2024 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831486;
	bh=RdIF4nHouyLOKQA2ucreemTGRrrb1T+FjfDV5xhHCZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS1RdoBGmfB0L7VHt+Y5H4RJWDBrHodccBySWUTDmrU8PBE58lEDcsKxzVNIoG7fz
	 /XRzyuRP7lWm1BP2xiQUkfil0RNmlGfCUI6DEGKVxUDIJq59jogsvNpHOS1YipNBbq
	 4/HFlz5qA9ANNDKW5V1q8C93Zp7VxCqMDhGqU6Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/294] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Thu, 11 Apr 2024 11:52:52 +0200
Message-ID: <20240411095435.918738961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90f7febaf5288..a6b07aa8eb650 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -3646,3 +3646,4 @@ module_exit(gcc_sdm845_exit);
 MODULE_DESCRIPTION("QTI GCC SDM845 Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:gcc-sdm845");
+MODULE_SOFTDEP("pre: rpmhpd");
-- 
2.43.0



