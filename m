Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997E6265CC5;
	Tue, 11 Nov 2025 01:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824365; cv=none; b=i0TXl0OU99DaoPdNaOwVsm3aSKfuk48qWPAKdcmqeFM3FnTof3DfM/s2bgVWciF6wjsPuOhm8Zy+H3mOVVKxAMwRLlML0LYnkydpVhRw2k95nTyhQOh0xMHeNS8RGBabaBnAROVAyMO/o8rqDRK0pgWX2HC4Ab8gbM/ZqlpHh+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824365; c=relaxed/simple;
	bh=g/3p7fIMkNMgRN9RnpVvoFQqCzrOeGkbAGRRQKU3LeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujDjxTM7wmrjnWiU3T1zI3b6O2hCrVVOdzbxteTx9luxnJOih2nv2hNjprhIZ4l1d3mehRPLY0NdPMocC45Don4ShHqMcnQz7iIVoh7/i09EGFyGRuxeBviil1HEc6OMmS8oXBGfQn5uoj734aY+EWhAfvEgItmiy0PpgwU23y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Inu/86N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Inu/86N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F0C19421;
	Tue, 11 Nov 2025 01:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824365;
	bh=g/3p7fIMkNMgRN9RnpVvoFQqCzrOeGkbAGRRQKU3LeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inu/86N5vFonY/9HqLrPYsg8UUM6VPA6S3dG9wrvkki+qMS1dOUEVZHUG5wAF7Kwu
	 8FGKtUovwOTjmXUN/wGPjbS5zuNLivBUU6lOQZQBGU2d6kZGR9fwdPNOOCfxRLU6Oc
	 TOKBuEOxhOogD1Z6UR0ADE3+DuLC/5hY3P+JOEUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 454/849] drm/amd: add more cyan skillfish PCI ids
Date: Tue, 11 Nov 2025 09:40:24 +0900
Message-ID: <20251111004547.404740033@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5e81ff3ffdc3f..e60043ac9841e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2172,6 +2172,11 @@ static const struct pci_device_id pciidlist[] = {
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



