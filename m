Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD441419AA;
	Tue, 27 Feb 2024 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041895; cv=none; b=eGh93r/YoKScDI5UryvkUzE9I1AjBIkRvmo77z6Dbc0JiCBgh3DcfxW0APfW2mTctyouJdzHwBs2MAqiSHlf73LRBlkG4IYpXMcKYUfZzMi2b8iHjldqEb3ci1fkjGftBK9kVke3EJ7kkFni1QZllfoaHGHCUx/9DgV9MnwnCrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041895; c=relaxed/simple;
	bh=GmIx7y3ImGAsNPC3mSJaEWmcQaBPXSPY7NWodqX0S6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftInRNSEI5MfYJNHeO0ZZrw9YWcSqSLm6CqdxGF7gsWE6n6/KUnR4ZzckRGfr+JpC0W10jy+Kr67JrLNA/MMUsjovClLna5rqPcNpgQJ3+nxI3pUmSBuelI37PT9XHoF7ZMS7FCDj2wEvn8kBVx+2feO2l5s9P+SbfLDBr8QHds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih5dzqPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih5dzqPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD9EC433F1;
	Tue, 27 Feb 2024 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041895;
	bh=GmIx7y3ImGAsNPC3mSJaEWmcQaBPXSPY7NWodqX0S6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih5dzqPyE5s3C31v7mL0IbFpBTM2qSaoaepdYc+4a2OrJuEZrggPN14vW4eFS5kQ4
	 dbMXVkTHmk4cXNrooLJer6pQ3IcGBlahFohW/cSufA/agkMkIaqbHHRWNfv6FMfRxA
	 miJe29Yn47d8XSZKTSope/L+7d2afRTCkupE8yNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/299] accel/ivpu: Disable d3hot_delay on all NPU generations
Date: Tue, 27 Feb 2024 14:23:38 +0100
Message-ID: <20240227131629.325436665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e9359611d69c..8fb70e3c7b9ca 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -467,9 +467,8 @@ static int ivpu_pci_init(struct ivpu_device *vdev)
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



