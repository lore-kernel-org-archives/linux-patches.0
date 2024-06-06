Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DD71B3F39;
	Thu,  6 Jun 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683437; cv=none; b=tFvXeXtl1b2XpWwlLraDckFFYD1gF8CBvB1bF6fo7VGFcbDRO/2xp2BhtTrUQeW4Lp4uSXCB6f9FUlqrCi4zkFwzxhF4fBj4QlzyOInkvwBnCmJP+HaDN6n36HAo9y2lC0wyo8FdOgLdinsm52yZRFqDLq5exH3fppXB3XjCXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683437; c=relaxed/simple;
	bh=SPNaSpBQwS6iI1WiNeDylolad8aKFclZfTZD7VZdVB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLYRwaokDxvMcGRJvLXfPs8dSSXA/0y3C3aEe9GK76c9o3pUsciqauVy66xPhNmvOzbfl3/4jRBI3CMC6pO62CnejPPw5PBiX2gaFMD+mT6fv6iMOzMSoxXmYgyRjSqG2w1FPdJCddDayOFrOP7R+dXxDYULcBPqFxoOqtQ96/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxQ6dHDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxQ6dHDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB74C2BD10;
	Thu,  6 Jun 2024 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683437;
	bh=SPNaSpBQwS6iI1WiNeDylolad8aKFclZfTZD7VZdVB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxQ6dHDJNQRwxCauPcuFAQk1zwpPCV7x+Hj6Hv0bzQV3+oQJktO7rUD2t3nNKIxV3
	 31R1Ii/tw3cIedrh7yitQZym322p9sFn+/QIaeVyF5m6B0pa391/Y/IzsnEmjbKewp
	 4UVBXpqggbHEK488ZYzWvNA8u25+Gun1MbBK84j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/473] microblaze: Remove early printk call from cpuinfo-static.c
Date: Thu,  6 Jun 2024 16:04:11 +0200
Message-ID: <20240606131710.577934418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



