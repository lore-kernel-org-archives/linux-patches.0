Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774853446AB;
	Wed,  3 Dec 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777859; cv=none; b=AefRgS5YMOfhEfXuSdokhnQReKGRhtdcbNo8vtjykvH5x0o0oRU2nnTRRdpDcFUxNK0yqed/Q+wty4oHQr6dW5VonJ8bX0++MQhyMsfnTnooRDFQi4JdpEsLDk9P4v5TWZsokjdf5JzhisketPmEeloIKufNtCvt/bpDbOcLHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777859; c=relaxed/simple;
	bh=deTYuSHEDL2NGKx9zHKiKeNBZ72QSMd54KMdkjnpaHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiR9WwvChBwJ0ro5GOthZPSL0RI8ASD8HDZCrDsR9e+mF6R2jN0+Qo5NMBjH/lBSbWjpfFX1DUOXkiZ0z1RFRTZA485ZSqo/HulfYZH4jen/WTmqRY7OvNWeP20QNeGz+F3T7QaWgIxaCbySQagNxHYmg06p9vzPc9mIKmg0NuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d15FoV7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d15FoV7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9003C4CEF5;
	Wed,  3 Dec 2025 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777859;
	bh=deTYuSHEDL2NGKx9zHKiKeNBZ72QSMd54KMdkjnpaHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d15FoV7W2jGjrDZoNV3AZHTn4GI7zRFpI1bWQAnCzo2/sFvfB6FwXurkCNGZAbrJs
	 nKJQKCR64q4yQcKLufI/M5EzwCSkXwnUkXLtQgiJb476+rvrd6l0vIi9KSENa2ZvIq
	 FpD8uTYOsvB7jPwIcX1u8iCSUMJChEfLHjQazYvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
Date: Wed,  3 Dec 2025 16:24:46 +0100
Message-ID: <20251203152419.094422510@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index adcf3adc5ca51..7abcb5db9ae26 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1942,6 +1942,11 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
 
 	/* CYAN_SKILLFISH */
+	{0x1002, 0x13DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13F9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FC, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 
 	/* BEIGE_GOBY */
-- 
2.51.0



