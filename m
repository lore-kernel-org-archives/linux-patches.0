Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0046A352;
	Mon,  8 Apr 2024 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581262; cv=none; b=kpbW4aUTYzxr1geHacXsFoIvbt6pV1YTpySwV1c6T4aX4IZnreqLvPJ/k5Q240vTo0X4fCDDT8SBatXdGAsQcP2qUtQ9cGgY2L3075z57n2RRwcq3x/Kag1FKLxMMhAGprbJTMWcVOq1qR2fBWKFRrSY9iNRDqXe+rFaj6JGQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581262; c=relaxed/simple;
	bh=1PaVpCR4cUN45bSeWRWOeiIwOwBZxutCET6lOJpZdS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyxlpFMNYuJ5ZhFqnVrI0uM8COSsmSBRHu7U0qYSGe/Xyj9YZOqCFxmOPzAMskl+lEollflTsppa6TNkOxULljxoYqzAvm9tmjjhEbRATnlcJOZ1GKwLzQaMCDn6GM6RHDNH91s+/SluigdZLj5qxBT5LSBX2rEIRC6oZdfjpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3PYUVuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3PYUVuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0162FC433F1;
	Mon,  8 Apr 2024 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581261;
	bh=1PaVpCR4cUN45bSeWRWOeiIwOwBZxutCET6lOJpZdS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3PYUVuUNYZuqs2PFP2k8hUIIA9v0E6TCVtUZ0j/rl7OHRCyogsf3o+CuZ09pFTTa
	 tR9oYhQGzdB3HZeCAPQUtBMtSOT/A49Xq+6Vf9vgcAKJJBT8vvQRbaqo+Wgv0gALnw
	 sHtq+Voqs9GPDuwGwvWMmYhvvtytgjxk4LGDsELk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/690] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Mon,  8 Apr 2024 14:47:58 +0200
Message-ID: <20240408125359.996630563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 58aa3ec9a7fc3..fffdb480073e7 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -3642,3 +3642,4 @@ module_exit(gcc_sdm845_exit);
 MODULE_DESCRIPTION("QTI GCC SDM845 Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:gcc-sdm845");
+MODULE_SOFTDEP("pre: rpmhpd");
-- 
2.43.0



