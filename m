Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96CBA3F;
	Mon,  1 Apr 2024 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990615; cv=none; b=moFjt/QSW1UWztWXrrRlQErvKExHrvkC/U6wKc1ZEWeT6lNyi1vrHNrNXdRTiupSKqe+v3QQtodg2baYDD3pOud8pTEInUQ32DRxueB6ck0sG2n7xqC+BS3A8xeENtgA0KKebVWXUPycniVvQAwP1UU7qjhBbWa1VfwjKzrMw5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990615; c=relaxed/simple;
	bh=mFiUKKuzTgirS1twEx1T5Li7uA1DVqAYf/1KAmklCgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onlblgE61aYUkH+bMDkG1qdqXSA3FcrPl3hs/mcPSBAZBWcqbTAfbdpWu9XsrL1Q2E/98IQR5U5yWbjUXcrUIlHVqOse9jUG2wa62qytjTa0G0QMMgrxGYV7ksJezVRRk/tOUtB1POKonLgq9xlcYMSeTp5PgTCnD8+7H0Bsyng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ij0MUsbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ij0MUsbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653D4C433F1;
	Mon,  1 Apr 2024 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990614;
	bh=mFiUKKuzTgirS1twEx1T5Li7uA1DVqAYf/1KAmklCgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij0MUsbx+eYhUXSo/l1snIeNfPqZ3AGmCb4WN2S9m5FTDArFK/nGRoD8d9q8rwpzD
	 uqbFvgVi8dxACT8kRqC7DYoHz1/ceVrSub8soh+ifI7B4HNkAAONCGaVuqMVu//NA8
	 8tF8G17SJuOvWLrKZOizDu0ubQdkMYKFlmn0kAMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/272] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Mon,  1 Apr 2024 17:43:23 +0200
Message-ID: <20240401152530.708616041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6af08e0ca8475..ef15e8f114027 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -4038,3 +4038,4 @@ module_exit(gcc_sdm845_exit);
 MODULE_DESCRIPTION("QTI GCC SDM845 Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:gcc-sdm845");
+MODULE_SOFTDEP("pre: rpmhpd");
-- 
2.43.0



