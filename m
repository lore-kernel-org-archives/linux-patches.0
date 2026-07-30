Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA43769FD;
	Thu, 30 Jul 2026 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426082; cv=none; b=c3OoPSp1QV2v5noqI3rif/f/iUW7Q1ZLeqjf0g8uGpg4bYmxuP1UERAfGVG/DNyRZygUPQEP/BanSapqwOVp9Lif4VsCSqNBZ7Lb9XBSWJckCOBLf4Gs1IQJChngAHXMuUgT0P1TxMo7fWLdCMdGnvDSPDdk4odAyi9/cLQkMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426082; c=relaxed/simple;
	bh=m3L6UcMpcqUbyUDnPySBqKgPBwxP6Zf2n/RcR8zeGJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzQbCnS34yNa3MxXCd4MyfKvcn9CzWyYUwmPjHNcmxNnl+rk5LQ8vsZR5s/hj9IK/uFE4M/cmo+QcyRnmJw1VupK8QdCTRzKH6jPQcYJkWUkRUUFciJj96fgANm2GAnvpgscRLVpUHJFKsHiB4iZrITISdUaDfvWJqofBWdEFvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgbQBL0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgbQBL0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ECE1F000E9;
	Thu, 30 Jul 2026 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426080;
	bh=6vPG846Qb1oOY4ijaCMmnqLMQ6heiwG/8hcDVDAynAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgbQBL0MKRRKrq/zvFRt6oZSc8dvUbCAbDtmexYaIGYsJ5+ax/wDb3GHEiKG9/cxF
	 GKDB7TN1wrjtfDFmHnpvct9hLRvfmZQ+LOYrtMLRqQXO+4JFrHeyXxjhg/nLR97hcq
	 FOMTEA7pfhQF5h6qkxpacU2VIPOwCLGA5ujtB/fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 295/602] drm/amdgpu: Disable PCIe dynamic speed switching on Ryzen Pinnacle Ridge
Date: Thu, 30 Jul 2026 16:11:27 +0200
Message-ID: <20260730141442.169667694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0148ac33547b9af1c5a7f3bb6e5baffcb6e9fac2 upstream.

AMD Ryzen Pinnacle Ridge (Zen+, family 0x17 model 0x08) CPUs have
PCI controllers that don't support PCIe dynamic speed switching,
causing system freezes during GPU initialization when enabled.

Disable dynamic speed switching when this CPU is detected.

Assisted-by: Claude:sonnet
Fixes: 466a7d115326 ("drm/amd: Use the first non-dGPU PCI device for BW limits")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5436
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Link: https://patch.msgid.link/20260709031520.841611-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ceb4e034a327a04155f32f1cd1a5031dfa5fe02)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1757,6 +1757,15 @@ static bool amdgpu_device_pcie_dynamic_s
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		return false;
+
+	/*
+	 * AMD Ryzen Pinnacle Ridge (Zen+, family 0x17 model 0x08) CPUs don't
+	 * support PCIe dynamic speed switching.
+	 * https://gitlab.freedesktop.org/drm/amd/-/work_items/5436
+	 */
+	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 == 0x17 &&
+	    c->x86_model == 0x08)
+		return false;
 #endif
 	return true;
 }


