Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8E2AE8D;
	Tue, 11 Nov 2025 00:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822327; cv=none; b=I9Y+V3X6j3zKtV1DnklCGyKXEbetbgNT60TQwZ9iquuB9jf1WnjHTKhPyBbuH8crfXPIHxRnwbRkdjnCqZAXQrn1ujJWlhCTgpxFfG8kwzXXl6zk2xw/0NdcgJZxeUrA1czmtS7xX4oL+V7R5ZTCAk6Ns8FOpbig8L9ZxA9MtEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822327; c=relaxed/simple;
	bh=LL6X/sSzQGRN2yQb2q7ZshW/0I5dQpiNkanyPy3QTP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVDN/tIfxKjiA5CbxnwN8Ac0IiNhZKFITzVSfe7f0dDt2wrvHRhfPPCHDHB3kPE8nVyCi/9z11ejyL1IlfreCG8PVGX4NiVM2u/ZuU6ZACWoP7FTRUsRXOTs/jxaQz+PBFD3wu/EqfYuV3bafWHlOGy+brRycH0F5CD17BEb2NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0lJTzn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0lJTzn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1ECDC116B1;
	Tue, 11 Nov 2025 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822327;
	bh=LL6X/sSzQGRN2yQb2q7ZshW/0I5dQpiNkanyPy3QTP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0lJTzn76uOwIDDeIuLI+48CFHq1PM8WTP6/ENJ7z1z3eezuLxekISvCljc8fAHoP
	 kBRvZeD7bzria1jo3gARGR5f2whzvnr8JLus1cqlkG+8zg/wV6vMbNB60HxwUEqaF0
	 7OV38cDxHhcasO/2w/8esbi1387A+P9OqwLids7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/849] drm/amdgpu: fix SPDX header on irqsrcs_vcn_5_0.h
Date: Tue, 11 Nov 2025 09:34:16 +0900
Message-ID: <20251111004538.496823459@linuxfoundation.org>
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

[ Upstream commit 8284a9e91722d3214aac5d54b4e0d2c91af0fdfc ]

This should be MIT.  The driver in general is MIT and
the license text at the top of the file is MIT so fix
it.

Fixes: d1bb64651095 ("drm/amdgpu: add irq source ids for VCN5_0/JPEG5_0")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4654
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 68c20d7b1779f97d600e61b9e95726c0cd609e2a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h b/drivers/gpu/drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h
index 64b553e7de1ae..e7fdcee22a714 100644
--- a/drivers/gpu/drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h
+++ b/drivers/gpu/drm/amd/include/ivsrcid/vcn/irqsrcs_vcn_5_0.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: MIT */
 
 /*
  * Copyright 2024 Advanced Micro Devices, Inc. All rights reserved.
-- 
2.51.0



