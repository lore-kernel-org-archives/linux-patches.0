Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FAF1D86FF;
	Tue, 11 Nov 2025 01:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823717; cv=none; b=tHrmnajbkWFUhzHtILaV4trW5xJ2VU8TxivryY64AGdSoKZKjZmNAYhSibPK0q51Dlb1qK7t8OlVVUij8HkeJkwvWY+crLbvdh6qhcIimFv2avvCZr+Ner06VEfPXpcIZLsAzhdF+ASJMhuebLMWtZLaMs/X14+wWhLr77Bt04g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823717; c=relaxed/simple;
	bh=43tVYFp8KxrD3tLFRypStTB+Hwnoanhy0Y8wM9EIhOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0WWtPDKlB2lha52YuUeV5jl1XtQ1y4xz5D13IEdgPAEsFjru0kVIh10G08BxXnOEAilBHZTZjuII4DUvgE+9Ce3YxUV+QWrMMRbEnqOcBr+I6nqpEVnI/CvfIco8ttrKwr3xNvvYMaUNXiTJFSrOGK7dCHVQ+mCD8t8CNVH5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9vxF2BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9vxF2BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED83C2BC86;
	Tue, 11 Nov 2025 01:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823717;
	bh=43tVYFp8KxrD3tLFRypStTB+Hwnoanhy0Y8wM9EIhOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9vxF2BYTeq/QwCoFcV6Rf2ZmWA0iMJZAXyBBGZVWlDaCTZviotgtPb3/fJrHI7/k
	 fkU5fxVEet6PMA4+es4/iUE0yd/6NvqhQUjBCdcjGIKikQfJ1QLkV8qZViHVyFxJJB
	 7DN896i+kGbU7QMtjJo1DThpO3HYZhMeuCdxFnvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/565] drm/amd: add more cyan skillfish PCI ids
Date: Tue, 11 Nov 2025 09:42:42 +0900
Message-ID: <20251111004533.766624913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93c3de2d27d3a..41397f1cdeb8a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2135,6 +2135,11 @@ static const struct pci_device_id pciidlist[] = {
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



