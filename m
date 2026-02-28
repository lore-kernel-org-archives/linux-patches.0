Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C5326D63
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300973; cv=none; b=pH0bZlEPIRtl5neHV/Kc+c7b6W1/hQ2mD69tOrUf0LGtZbnfs5pqnMO/Ur8QjXiNduolj/itN1n+U4xklrwRuXEHbtRwVKMGHX4tq+piBTGN4G292wQyInwYTYepgL7q21wZliNFCoikmLwZg6UwdxMYOtKzCkwbimnGNaGkRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300973; c=relaxed/simple;
	bh=NZb0PUgRolF99DOs3hWc0wbs6TV3plrjOtUkWQ0yzM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFgj3t4aJ67szaGvXM4QQ6oXoAfmuXddm4iTlE3oO18VeB1CGtFO3YBIS/T8JxB2/m94hDy+sI1FbS2J5jBN3bvuDGGepCMXigaxHzuowaOmxcOqLwUuGKkZsOmQEbu5oBy/au4c7zssJBbWgQ8wvJR42WH24KBhahbwiGA/pw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCZ31tlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCZ31tlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AAEC19424;
	Sat, 28 Feb 2026 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300972;
	bh=NZb0PUgRolF99DOs3hWc0wbs6TV3plrjOtUkWQ0yzM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCZ31tlPf5VlnQN1GAUfBNZ5nX8tEwv+mwh1MHhBdzQj2FuAhAA7Cjq8CS/Si3cjC
	 1kEmDkt9HZ9J7sIW4CuKjH+80B7mdxHo69ARMueleMnx42VR7jRS98GZW+YO+2Z1i8
	 4aXcOV+BMnmdR9zKe53ljZGNa/SnU0PosyJxs/3YOjW+CFuM2bbVodc9DmhUbr84z0
	 fEWgSHap60IYc4fiir+42ancc29cZ9RiSLhgW2dt7eaguU1YA/Yl4v20wOP4u/YR9k
	 AV0ShcAqyv0eU+y/mJ7wMHf97mN8FYYzq/S6SjdaVWPOJjZnIXODNbjDHmxsaf4SSn
	 TLaZLuSVsD8fA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Jianfeng Gao <jianfeng.gao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/752] EDAC/igen6: Add two Intel Amston Lake SoCs support
Date: Sat, 28 Feb 2026 12:36:51 -0500
Message-ID: <20260228174750.1542406-100-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 41ca2155d62b0b0d217f59e1bce18362d0c2446f ]

Intel Amston Lake SoCs with IBECC (In-Band ECC) capability share the same
IBECC registers as Alder Lake-N SoCs. Add two new compute die IDs for
Amston Lake SoC products to enable EDAC support.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Jianfeng Gao <jianfeng.gao@intel.com>
Link: https://patch.msgid.link/20251124065457.3630949-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 9202e6e2daf4e..463bbcd484c3c 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -246,6 +246,8 @@ static struct work_struct ecclog_work;
 
 /* Compute did IDs for Amston Lake with IBECC */
 #define DID_ASL_SKU1	0x464a
+#define DID_ASL_SKU2	0x4646
+#define DID_ASL_SKU3	0x4652
 
 /* Compute die IDs for Raptor Lake-P with IBECC */
 #define DID_RPL_P_SKU1	0xa706
@@ -628,6 +630,8 @@ static struct pci_device_id igen6_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, DID_ADL_N_SKU12), (kernel_ulong_t)&adl_n_cfg },
 	{ PCI_VDEVICE(INTEL, DID_AZB_SKU1), (kernel_ulong_t)&adl_n_cfg },
 	{ PCI_VDEVICE(INTEL, DID_ASL_SKU1), (kernel_ulong_t)&adl_n_cfg },
+	{ PCI_VDEVICE(INTEL, DID_ASL_SKU2), (kernel_ulong_t)&adl_n_cfg },
+	{ PCI_VDEVICE(INTEL, DID_ASL_SKU3), (kernel_ulong_t)&adl_n_cfg },
 	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU1), (kernel_ulong_t)&rpl_p_cfg },
 	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU2), (kernel_ulong_t)&rpl_p_cfg },
 	{ PCI_VDEVICE(INTEL, DID_RPL_P_SKU3), (kernel_ulong_t)&rpl_p_cfg },
-- 
2.51.0

