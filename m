Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019702;
	b=h8kHIy3HA+TPniR2tGp7dKTXXnmCP/ShVzPsLy610JO3sHqKQK1EKww1P3H8814j832d
	 nBjyIMR2BUJj4i0QpSF3TlzzK6ZbNnfpTWxiBiAAGhcRDe5qthaxNtf7dwhOgo7jL0auk
	 gH5KCeT03XI2SntA3ZiKD7iz5cNuZBqm/WikHoxEX+LAt3XhO4gVFd4MR9DObhMWg5EWB
	 68QxvjBgagnx2qzr5etlCdvlYIMzmx98CTuHFXbUh9mxABwohqGpLmiX390RZ606zeuvt
	 WqENS2mrRZ+/19cxw5JseQvY27V4x4fd/z7mqTCFaJ6EwCPjoOgfQLYrXCgkq+2OJWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=t6WELtMXGZNCbPuz+gTlQaf2j0WV1zjI7m6d8bi1AjM=;
	b=DMWNYiqvTDZdJEeXdi72SgLjlNxKuIAM86vqQ1ND9hDcBjH1OzVzfop0WcY/P8m3lkY8
	 nBh8Qt8CTkYVQICIIVT9RF4iP1r+uffOP/Ty2yKkyIjPZ1EKak36+uudO3z5D2Z38bKmK
	 5EbYLxYRL02m76IriDcvy+YpGTC9QxFqgd0J+QjFLMRooULaJI31D57wmEO6EdF5NFfUZ
	 zgU1XfuFnfOW9VM7W9OLrukJNuruqd1J+s9JD3LoSEVZ3QHnLQB8TL//Ykx8ZzdjuYm23
	 GYp9JBj5igY89gKkmgS3+tgNCEtJCjd/BHExBinwEDmmESoMSF8Pu2NshPHFpPzbOyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WeNkWNN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53E606A31C;
	Wed, 18 Nov 2026 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WeNkWNN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EF51F000C4;
	Wed, 18 Nov 2026 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019702;
	bh=t6WELtMXGZNCbPuz+gTlQaf2j0WV1zjI7m6d8bi1AjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeNkWNN9PrI2w9WaPidrvbqWfhsvUstBxvPRm5eRwrSilfqtks376glTYt+QdsbPI
	 2QXv3PVN2Bqu4JucvzanAUijzscCYbpAmf4o2nue/1Orrmvmmkp28Zlv/fg7ygLfvq
	 f9qchSeGzCLy7mPhHylnAvv6OKl+h6kae1wKA3f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1689/2651] platform/x86/amd: pmc: Drop scratch_reg from amd_1ah_m80_cpu_info
Date: Wed, 18 Nov 2026 15:48:49 +0100
Message-ID: <20261118150348.479745691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c84f2e1518d052f8699031330f1cc90cbf68740a ]

This platform does no longer populate this register.

Fixes: 2726b5758f80a ("platform/x86: amd-pmc: Use correct IP block table for AMD 1Ah M80H SoC")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260918170302.352054-3-mario.limonciello@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index f93c35efeaa00..038b05e36b65a 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -183,7 +183,6 @@ static const struct amd_pmc_cpu_info amd_1ah_m80_cpu_info = {
 	.smu_arg	= AMD_PMC_REGISTER_ARG_1AH_80H,
 	.smu_rsp	= AMD_PMC_REGISTER_RSP_1AH_80H,
 	.num_ips	= ARRAY_SIZE(soc15_ip_blk_v3),
-	.scratch_reg	= AMD_PMC_SCRATCH_REG_1AH,
 	.ips_ptr	= soc15_ip_blk_v3,
 	.os_hint	= MSG_OS_HINT_RN,
 };
-- 
2.53.0



