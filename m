Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8258333A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302245; cv=none; b=kgXVr3BUAOnX+aYBd90w6ISM3YDTU6xcxH9cuYQ+40Ck6LhGGKSO9OV6V2ZEbuDAWlt53Nce20gr7rucRIfzDJlxsZ317p8ToH1yEeQ5y+kEqWztMP/SlP039raoN0eIs/kWXHt4OHyFn++nmsegFWk2AU+3MxzdO/xxcXWbrXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302245; c=relaxed/simple;
	bh=CmCEB8bD5CNDIjLm8CKUlVvOIAb0Gj7MMO+gA7DzELU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYN5iP4tcylvEvPoAxgtlUqv1XVS1pbm6CGTIKUpDDUi1IF9o4haHH7bgQkEy7PjWVnB/46IBZPkqvxYVSpHqvdkt7y42sC5sl0RcF+9Iq5lZe30spEVnU/a/mOSeVynZTVNEJVE1Rf45AC6Gsyg0S2ezDkQ4d6cZ8pTD7iAHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bg8CLbVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bg8CLbVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D0C19424;
	Sat, 28 Feb 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302245;
	bh=CmCEB8bD5CNDIjLm8CKUlVvOIAb0Gj7MMO+gA7DzELU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bg8CLbVwWqe3klaSfMsIVQNYIsaxH9zFr1961+hrP1deh5a6IQeuBq0XWD5z332PX
	 XeOmsbujZ4GV3DFWIgGlJpTi35b3yY6oleM+1HteQsZ3dC7b0CvUIc3yLxMQ6v9wMI
	 NnEqSlkyvrqSwwyU9rv79kmb1/JxpuqWI5pw6UiLwqJZO3yL87OeWcECcEJrpXsV+B
	 j+0MjwV858y23ZuPIX/6Xp8x9MU7W+BgXrljn8voRvJgvkHc1GJfDCIFmnVLinpjLB
	 HGsjzS6Oxrilt2ms+dh1Oq6S+mJoJoEL1/DK22o+9EeGpwUTCiVufMVcAqOeBKBoUR
	 g4trp73RHU4bw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/283] powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check
Date: Sat, 28 Feb 2026 13:06:40 -0500
Message-ID: <20260228180709.1583486-258-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit c7d54dafa042cf379859dba265fe5afef6fa8770 ]

On partitioned systems, multiple TPMI instances may exist per package,
but RAPL registers are only valid on one instance since RAPL has
package-scope control. Other instances return invalid versions during
domain parsing, which is expected behavior on such systems.

Currently this generates a firmware bug warning:

  intel_rapl_tpmi: [Firmware Bug]: Invalid version

Remove the FW_BUG tag, downgrade to pr_debug(), and update the message
to clarify that invalid versions are expected on partitioned systems
where only one instance can be valid.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260211223401.1575776-1-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 1c48dba0ba96a..6958c2f0b7660 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -156,7 +156,7 @@ static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 	tpmi_domain_flags = tpmi_domain_header >> 32 & 0xffff;
 
 	if (tpmi_domain_version == TPMI_VERSION_INVALID) {
-		pr_warn(FW_BUG "Invalid version\n");
+		pr_debug("Invalid version, other instances may be valid\n");
 		return -ENODEV;
 	}
 
-- 
2.51.0

