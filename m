Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168AB35E551;
	Wed,  3 Dec 2025 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779246; cv=none; b=QPgw8AZNp6aOBq32jgA6zZ6zM0QF60Epq3TZSI+mqyn5+D5krcGytes+61Hyz7nMsr312YZN4RcmezmhXv5UrdX0/MrUYGEiZhYHeROg+NjsxSMfQt8TKY42I3uCz4Nt9eQWZDKpFTCU/ic7xvBFiPLWlvUQy2VUnajQiELNAWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779246; c=relaxed/simple;
	bh=ylmRP7zRMEqIXr6IQavN99fF5+J0QccluS1Gua+wnKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBcLB9Zq/9Hn7VQssoo3xqJiKdx8kC/hjXKdPPQeTfQPmcoCvUeW4tA1JevYjPz0+5uxj1DbBRqPG7ZeVZpza9FiTFb+uZvuAOGy1zHuYBBq447A0U7nMHJOA3ymoZ4PUrK55vtz0es989Y4xMslichGuPP2PmfvACwDiaaf/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6wCv5+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6wCv5+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0F8C4CEF5;
	Wed,  3 Dec 2025 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779245;
	bh=ylmRP7zRMEqIXr6IQavN99fF5+J0QccluS1Gua+wnKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6wCv5+Npl9mevcw2HQ8Rng7SwhCtHt1iZSeN7pUhF4TV8vnS94CRDbba/Ujvmami
	 U7eBzE3oht3i+QKB9cBx9nAQA7bTe+dFNTB/3gnWYQmtgdqUA2rAKc1ofeJ+JCZFHW
	 XnZKmW04VAh1PMwKnpZ2Kv2ZYwyKL0/Vr+YS18r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/568] drm/amd: add more cyan skillfish PCI ids
Date: Wed,  3 Dec 2025 16:23:21 +0100
Message-ID: <20251203152448.014236596@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1e18746381793bef7c715fc5ec5611a422a75c4c ]

Add additional PCI IDs to the cyan skillfish family.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 1fbb73b2691d5..6104353e4c2f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1997,6 +1997,11 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
 
 	/* CYAN_SKILLFISH */
+	{0x1002, 0x13DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13F9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FC, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 	{0x1002, 0x143F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 
-- 
2.51.0



