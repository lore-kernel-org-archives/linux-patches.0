Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235D446AC;
	Mon,  1 Apr 2024 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987907; cv=none; b=Gf+HhVY704uBU5nXKuGpMq+9MFrfMFEinU71RS3NQCA1YmsoRhhr4eyNS9Cso7Osh2FIc2pv+ICk63WPqDGEN/wqfp35pd+eiVtKY8yp2kyCDQ7jK4oOcr0K5Lq52vJ/ZZ6NIwUFaJppq6yZsDI0ZQiS0bmOETTyYkADh6Du8do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987907; c=relaxed/simple;
	bh=rf4v7DBplo9CstdToVWZ1GXpqEekl/GqjVpTeEjAJaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icK6ZVj4cKhK8aq2v4/U3kkR+Kj/RwKCP9SCyt1Rhg+KzxbznvhPzCC63UAKgbAHGJh7eMEk4qDaHrOjZ3RS5paQ4Ik9LmaBGNPrr3Mp0I/l6fGYcWRqqPAPKftt1UvXEG+e4AwO3mVg0fCBbURUKfJJ8bOTe20RKZlfkQbCO44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/GvCAUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/GvCAUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B647C43390;
	Mon,  1 Apr 2024 16:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987906;
	bh=rf4v7DBplo9CstdToVWZ1GXpqEekl/GqjVpTeEjAJaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/GvCAUXTxtOWEaPulF7ApXvW17WwzmIKwhNzwUIPZDAZRZp+gk1/t9iWfOsL3w2b
	 XCY/6uPjegUqZHpg2c13TMZsBzvWmN42x3jLqBx4nFRjbejsCicpUpglLg0nxkcyXX
	 KJ+CZeW0lYeRy29B5opDmzZG4zc898hYytZ/Rlmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 009/432] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Mon,  1 Apr 2024 17:39:56 +0200
Message-ID: <20240401152553.407943118@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



