Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ADC24EAB1;
	Mon, 23 Jun 2025 13:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686185; cv=none; b=hyFv0u9mrPuSRgExJdKuS9L1sM8FHvIzNZZPChIlCrOvzzxCtJAtgaEACLMydX3xFwqCU5s+dDAll6K/h8sC9+dVtKdEHxxWOD6Qnl7oTAYKI0FPQS80dRQnt6aj6tHXhIwKK6LzrdKsCM62syXI3KIvngCp5K1voPvv5O//9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686185; c=relaxed/simple;
	bh=IDOvj8U1r8cSMawFdYrP2zl0wuiNvCJHAkeDpLVvIvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKuHTz+hkjgvmRHG/3eXK5Yild3LZz/yH78IuJZxl1OF8dUaC2K//WlHTO51mW0TAFoR2QF2s/xTH9wrai3IXzGyWWO7KJjsBpI5UGXPxYCSZfWi4IlZA+kyMBt7ZOtknMunB3fRGa86v9FEhrQpW9jGjrIYbUQqER0vLdkGtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+GCMMHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+GCMMHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4CC4CEEA;
	Mon, 23 Jun 2025 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686185;
	bh=IDOvj8U1r8cSMawFdYrP2zl0wuiNvCJHAkeDpLVvIvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+GCMMHpL4ZHbXTTPqqYTX4nnkMu7/Xt9j4oB8wwPRoe2AONnwvjbIoF1B1uzzhrO
	 w5XkSzzV7Nb9d2jM2juwQYGY7zioDUl0zu1Li4ZxjA5lLvXoYoX2HKSCi4gKcSdMe1
	 Rvth4ZOy2Rdn/st2ZIhp2DHwtO9ej/ZhRChALZ8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 308/592] drm/xe/uc: Remove static from loop variable
Date: Mon, 23 Jun 2025 15:04:26 +0200
Message-ID: <20250623130707.732415694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 75584c8213d341ddd5b7c72abf822e62f4b3ab27 ]

The `entries` variable is used to loop through the array - it's supposed
to be const, but not static.

Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250307-xe-per-gt-fw-v1-1-459574d76400@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_uc_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
index fb0eda3d56829..b553079ae3d64 100644
--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -222,8 +222,8 @@ uc_fw_auto_select(struct xe_device *xe, struct xe_uc_fw *uc_fw)
 		[XE_UC_FW_TYPE_HUC] = { entries_huc, ARRAY_SIZE(entries_huc) },
 		[XE_UC_FW_TYPE_GSC] = { entries_gsc, ARRAY_SIZE(entries_gsc) },
 	};
-	static const struct uc_fw_entry *entries;
 	enum xe_platform p = xe->info.platform;
+	const struct uc_fw_entry *entries;
 	u32 count;
 	int i;
 
-- 
2.39.5



