Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D6A2F2D;
	Tue, 27 Feb 2024 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040865; cv=none; b=cmD/sJt+k1DIgC2ONeiD1kdKf8vMeNXrC+SvxL2rKGcB8qZM4dT+RlE0LYegKxC5s1KHb8D8/UyXEO8Oxj8EZUG5nejS2iygTN4aYHw5Bj3VGN9dOOPBHqGx2OJknXofpTtuPmc+FF6S7kO6gG9xRjccIwD7GU1VFpfjhFMET9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040865; c=relaxed/simple;
	bh=afDtefiCTx/ZGK4L389FhIre8wI5SNLNcGGRhynmu+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPWHdjvY9kfreWG7iyhcdoEXbyEwMpXcqmwFOGVFGSyGF9kv+661Ct+iI0ba9xTUGap+kkN8Gdbt2tG0MNrrXPFa4ghMUOIELJJyXnzNF7bAfSGFGvZRdRq6QFga5cH5Bbpaax671Wi45f56WavZ41/Pb+3eMO0nGbThdV6fJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znmKFHkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znmKFHkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12625C433C7;
	Tue, 27 Feb 2024 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040865;
	bh=afDtefiCTx/ZGK4L389FhIre8wI5SNLNcGGRhynmu+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znmKFHkWesYd4JhpzkX93Dt6+OY+HohsMeKlWXHUM+yrxQZI9tdDqPkTEBP68Z/Aw
	 LCLJj4JyZ5PZkxSZgmGo0sbXkRnHeG0t/izyZkzzt/fpKzFL5BPGHdN2PPtslvtpot
	 C6//JUjvYsyignDeKdhc4MnHcqUIlMMm2sRduLGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 119/334] accel/ivpu: Disable d3hot_delay on all NPU generations
Date: Tue, 27 Feb 2024 14:19:37 +0100
Message-ID: <20240227131634.313803033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit a7f31091ddf457352e3dd7ac183fdbd26b4dcd04 ]

NPU does not require this delay regardless of the generation.
All generations are integrated into the SOC.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240126122804.2169129-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.c b/drivers/accel/ivpu/ivpu_drv.c
index 7906030176538..c856c417a1451 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -479,9 +479,8 @@ static int ivpu_pci_init(struct ivpu_device *vdev)
 	/* Clear any pending errors */
 	pcie_capability_clear_word(pdev, PCI_EXP_DEVSTA, 0x3f);
 
-	/* VPU 37XX does not require 10m D3hot delay */
-	if (ivpu_hw_gen(vdev) == IVPU_HW_37XX)
-		pdev->d3hot_delay = 0;
+	/* NPU does not require 10m D3hot delay */
+	pdev->d3hot_delay = 0;
 
 	ret = pcim_enable_device(pdev);
 	if (ret) {
-- 
2.43.0



