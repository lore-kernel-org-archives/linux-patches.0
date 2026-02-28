Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DBC34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301925; cv=none; b=pw4tYG9DVSlEGZXhJekeJOXB2jpRT0hh6p89oZrMYCTg6mgBqdTiZWT/XwD++tqEWKufh9ZeimMz/eeWJwFM21ol1iEMKTTH74JAfP3v2IC5JjsVUJL21u/VBqpr+J60L2vAp32K2aqPQ7oKyP+PI1ejZPcfCwwVHwuIQ02fC3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301925; c=relaxed/simple;
	bh=ephY/5o+z6+fOJLYVWjA3rue+Vm4fNBLQ6oAW5S9FUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttGCJUyzZtEhHE6kfwJcWszBRu4iOWdDYdkfvwm4Uyo/p3t6QD1wooIdFLpORBYYPQ2808IF0O/zkUBqkbEbacVp9+wLgRvRuebTQ8ls8nwA4miBlquKZl4sPj3swblMAsbfgkOZMIfqA0GlQs6R9wov9QsDl2tq9ohvP7KcBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr33ISWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr33ISWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B9CC19423;
	Sat, 28 Feb 2026 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301924;
	bh=ephY/5o+z6+fOJLYVWjA3rue+Vm4fNBLQ6oAW5S9FUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr33ISWbm2+gDpKaQYSLQFLZf/PCAUAvx5FpiXmxTrIrHJOnw0K/oXCMk/fYR320d
	 JVKEuGohviQ/Ij+t35GNY74FVQSz+W1+dYjeMJIuaNhNOxtwjp225rIRNocu9sw+7N
	 YDf2GZcbZgrEGR0TI9CNw8BFvXvniKxuExBONFCi5q02WpwCLdLcFKUj6/MJsWs23W
	 IMJ3QN72x4xjy8FJYYNHwrkjDccB7RhVSUHbfDtyntO7GUewZtHmcLaQOuxrNvZaSi
	 hmFZd4w4BFX8r3ubejk7pQFTAMJPm/xYHubm/J2weaMII2tlmQVUmv88gOsdT8qzsl
	 xks1LleSvFYuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/385] powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check
Date: Sat, 28 Feb 2026 12:59:41 -0500
Message-ID: <20260228180011.1568201-359-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 645fd1dc51a98..1618138c5cac1 100644
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

