Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE54E9C20;
	Thu, 17 Sep 2026 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668671; cv=none; b=OCHt2pu/AYcw9t/7TK8AoBf+uBSD8HTwQ/szOY7dPITXjHG4a6M07FkjNk718bzpMPaQJhPeB61c4j7WFBZYidHD/8DExCZrvWZeuie4YXydQWNiqJjjjqVJVdEObAap435ZGTGkaZaca0QFIRH0CINPDHaG3019Ir8/eFaevRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668671; c=relaxed/simple;
	bh=LiKu73MZaqevUBTcuURQD5mmVNZTm7vcyNeJ/vGijWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBKiCDT+L1zW8WSdOfJt5+xOxmhok9lqkzGTZvX+GiGgW3u4Ccv4Mju9q73PrJejq+oK+HVxYUVSYDHEheCL7TfItKFUQ3ZtL22JPbcXjpaj0cerg50Erfb8QZ7pD2CpLqPTqSnu3LE/AOX9WXUinGJxgOr3ZKZ1H4JWLpEZpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVMNClR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVMNClR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6C71F000FF;
	Thu, 17 Sep 2026 18:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668669;
	bh=cs0H1ruQSMUyiQ0PPE2fZcg8c3zNFQBos0gTxCr1TXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVMNClR+1rNo6zvUU890hTSojUeLMmj1ZmZpJb6+YQY+Vw329wfoeDqhPdzr6f7w1
	 oXaOduW1jSAL6mZJXRZazOYMMm6YDbAoaK6Nb0w3hfecfPx5o41L4PIpFoFR1xKFnk
	 yYqJtdkvYVjpuIuon8YyQcEnAYfGRURMqYgQMR4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Deskhmukh Shrirang <Shrirang.Deskhmukh@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0500/1102] RAS/AMD/ATL, EDAC/amd64: Only load ATL when needed
Date: Thu, 17 Sep 2026 16:07:23 +0100
Message-ID: <20260917151552.284402405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 4c3da04827dc01dc1cfc3d03654b7de656c42d80 ]

The AMD Address Translation Library (ATL) will attempt to load on all AMD
Zen/SMCA systems.

However, only systems with DRAM ECC enabled will use the library. Other
systems will fail to load the library and produce an unnecessary message to
the user. More importantly, that thing is dead code loaded and unused.

Remove the ATL module dependency table to prevent autoloading. Request
ATL to load from EDAC once all system checks are complete.

  [ bp: Massage commit message. ]

Fixes: 3f3174996be6 ("RAS: Introduce AMD Address Translation Library")
Closes: https://lore.kernel.org/20260305154528.1171999-1-mario.limonciello@amd.com
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Deskhmukh Shrirang <Shrirang.Deskhmukh@amd.com>
Link: https://lore.kernel.org/all/20260307144910.GA113343@yaz-khff2.amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c  | 2 ++
 drivers/ras/amd/atl/core.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 322ba16b31bf2..682a9374778ee 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4184,6 +4184,8 @@ static int __init amd64_edac_init(void)
 		goto err_pci;
 	}
 
+	request_module_nowait("amd_atl");
+
 	/* register stuff with EDAC MCE */
 	if (boot_cpu_data.x86 >= 0x17) {
 		amd_register_ecc_decoder(decode_umc_error);
diff --git a/drivers/ras/amd/atl/core.c b/drivers/ras/amd/atl/core.c
index 4197e10993aca..81ebde74cb107 100644
--- a/drivers/ras/amd/atl/core.c
+++ b/drivers/ras/amd/atl/core.c
@@ -190,7 +190,6 @@ static const struct x86_cpu_id amd_atl_cpuids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_ZEN, NULL),
 	{ }
 };
-MODULE_DEVICE_TABLE(x86cpu, amd_atl_cpuids);
 
 static int __init amd_atl_init(void)
 {
-- 
2.53.0



