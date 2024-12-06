Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59DA202F7C;
	Fri,  6 Dec 2024 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496384; cv=none; b=bqCkBUlEZqAJK5dpenx/YqnixgOIc9XNVNBdIbNxjdnBNORNbIxgiFv1NtSaaXIMIbEAsjuPqY8TLXrjtoWhmyDlrcy6Mc4tM/XMXAZCaNC1ECFsVrQGA0zFKvUXYWTaBMn25fgEyJsp8cHZoaTt7xRKHE0DEs9kFjX+JjPFZIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496384; c=relaxed/simple;
	bh=1B+jd5KCMi9bdrwmauaKUizm4XXIpJac+1d4s8G8HGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FygnCvNdTk5Tml7oUG9lw9d2jfBRJnqW7OTgw4/h5ORpLFrp+j5E8gZRfvWNDDVtVSA9PIVyYImyRKNsfGMs08yv8eOp1whE93pGcqk6KMWuV1p+0Md/Vnbw9ch5PWXFP4JMWKJI/6SkSFOxQb/dxL7mcOCQEfxrWfy7HwTI884=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX3DVQ9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX3DVQ9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56899C4CED1;
	Fri,  6 Dec 2024 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496383;
	bh=1B+jd5KCMi9bdrwmauaKUizm4XXIpJac+1d4s8G8HGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX3DVQ9sliplUCjHbLZ2ZaClvTxDIrUPcOy6x3vAIUOG26x22iek8cshRmtJTDHqN
	 O6AwvjyMC2E8ip8MCq+8lZZC6a19pFlkQTj4iMLFQvSoS76+dsmYmjKQBg+23cMzIy
	 qO4frI2m1bpOCNZmhcN8KgpQdYx18KVE3vfsW+Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 136/146] drm/amd: Add some missing straps from NBIO 7.11.0
Date: Fri,  6 Dec 2024 15:37:47 +0100
Message-ID: <20241206143532.890640525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 902fbbf429b8213232b18de0ddfd5c0f3851cb8f upstream.

Earlier ASICs have strap information exported, and this is missing
for NBIO 7.11.0.

Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: ca8c68142ad8 ("drm/amdgpu: add nbio 7.11 registers")
Link: https://lore.kernel.org/r/20241118174611.10700-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_offset.h  |    2 +
 drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_sh_mask.h |   13 ++++++++++
 2 files changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_offset.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_offset.h
@@ -7571,6 +7571,8 @@
 // base address: 0x10100000
 #define regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0                                                              0xd000
 #define regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0_BASE_IDX                                                     5
+#define regRCC_DEV0_EPF5_STRAP4                                                                         0xd284
+#define regRCC_DEV0_EPF5_STRAP4_BASE_IDX                                                                5
 
 
 // addressBlock: nbio_nbif0_bif_rst_bif_rst_regblk
--- a/drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_sh_mask.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/nbio/nbio_7_11_0_sh_mask.h
@@ -50665,6 +50665,19 @@
 #define RCC_STRAP0_RCC_DEV0_EPF0_STRAP0__STRAP_D1_SUPPORT_DEV0_F0_MASK                                        0x40000000L
 #define RCC_STRAP0_RCC_DEV0_EPF0_STRAP0__STRAP_D2_SUPPORT_DEV0_F0_MASK                                        0x80000000L
 
+//RCC_DEV0_EPF5_STRAP4
+#define RCC_DEV0_EPF5_STRAP4__STRAP_ATOMIC_64BIT_EN_DEV0_F5__SHIFT                                            0x14
+#define RCC_DEV0_EPF5_STRAP4__STRAP_ATOMIC_EN_DEV0_F5__SHIFT                                                  0x15
+#define RCC_DEV0_EPF5_STRAP4__STRAP_FLR_EN_DEV0_F5__SHIFT                                                     0x16
+#define RCC_DEV0_EPF5_STRAP4__STRAP_PME_SUPPORT_DEV0_F5__SHIFT                                                0x17
+#define RCC_DEV0_EPF5_STRAP4__STRAP_INTERRUPT_PIN_DEV0_F5__SHIFT                                              0x1c
+#define RCC_DEV0_EPF5_STRAP4__STRAP_AUXPWR_SUPPORT_DEV0_F5__SHIFT                                             0x1f
+#define RCC_DEV0_EPF5_STRAP4__STRAP_ATOMIC_64BIT_EN_DEV0_F5_MASK                                              0x00100000L
+#define RCC_DEV0_EPF5_STRAP4__STRAP_ATOMIC_EN_DEV0_F5_MASK                                                    0x00200000L
+#define RCC_DEV0_EPF5_STRAP4__STRAP_FLR_EN_DEV0_F5_MASK                                                       0x00400000L
+#define RCC_DEV0_EPF5_STRAP4__STRAP_PME_SUPPORT_DEV0_F5_MASK                                                  0x0F800000L
+#define RCC_DEV0_EPF5_STRAP4__STRAP_INTERRUPT_PIN_DEV0_F5_MASK                                                0x70000000L
+#define RCC_DEV0_EPF5_STRAP4__STRAP_AUXPWR_SUPPORT_DEV0_F5_MASK                                               0x80000000L
 
 // addressBlock: nbio_nbif0_bif_rst_bif_rst_regblk
 //HARD_RST_CTRL


