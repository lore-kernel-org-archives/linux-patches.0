Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C41145B2B;
	Thu, 13 Jun 2024 12:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281272; cv=none; b=fs7zX3JnbIoWmP+/duTtRhUUTZ0bMELcJZ0xX3zHBEQuu1jQZ2liX3M7YNiWBWe5ZAiPmMjdSkbEoxIfNT6xqNinZ7J6vek9hTsoQnaTkiqCJP9PvGO6t8oWZVO/z94TRfND4c1GXLP2rdqjJaB+d3rNZq8TfdraHxG3zPVPU/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281272; c=relaxed/simple;
	bh=ISW2vERWGcmxrPReJKLsfFQwjCbaGvxYobjE9/0KbgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSSCgiADYIAhwr4r7RBRdhddXL3gzHWs+hzXcMfx1lC3IaAwf+qpbECG+TWv/amQSH3niiKV8DsMTWzOFrlVkD0oZfGX+7v1VwvKVJjvPX6/noC8X5F9bwcF0JXb5AakIXiE1+Euy63LvPxj/3rywRzjfCAP1c9ORaXAOisTBSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkUH0m3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkUH0m3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F45C2BBFC;
	Thu, 13 Jun 2024 12:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281272;
	bh=ISW2vERWGcmxrPReJKLsfFQwjCbaGvxYobjE9/0KbgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkUH0m3ElJBbpAyAduPVvvqtBTRc/t6/MEc2H/BREwg8YyDhVY8svR5vkcGiLEApd
	 2cFyvvvdhbhL9Q42eLATpk6DM0wcGwPZvNly0dBkhDiAS3/fh/S7bAx9XeAD+O0r4e
	 HwitbvCPitx6ciI1MBDCyHmwEHx5/LhXYfwn4IjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/317] microblaze: Remove early printk call from cpuinfo-static.c
Date: Thu, 13 Jun 2024 13:33:07 +0200
Message-ID: <20240613113254.100238106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 58d647506c92ccd3cfa0c453c68ddd14f40bf06f ]

Early printk has been removed already that's why also remove calling it.
Similar change has been done in cpuinfo-pvr-full.c by commit cfbd8d1979af
("microblaze: Remove early printk setup").

Fixes: 96f0e6fcc9ad ("microblaze: remove redundant early_printk support")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/2f10db506be8188fa07b6ec331caca01af1b10f8.1712824039.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo-static.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c b/arch/microblaze/kernel/cpu/cpuinfo-static.c
index 85dbda4a08a81..03da36dc6d9c9 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-static.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -18,7 +18,7 @@ static const char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
 static const char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
 
 #define err_printk(x) \
-	early_printk("ERROR: Microblaze " x "-different for kernel and DTS\n");
+	pr_err("ERROR: Microblaze " x "-different for kernel and DTS\n");
 
 void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
 {
-- 
2.43.0



