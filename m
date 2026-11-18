Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021922;
	b=EPKbxDgEsFn+PsAn+Xq2b4VpRYEzIS95wxBdeTwn2uAIwJeXtLvEyjQA6Imu7v9fMxIt
	 0lqb+v0PWUchLL+KZsa1pUruGVI21cl/0rkgTXoRZu8VYeP2wrjAt1vKUr5tzzNp/kYB3
	 BODi3K7ohv53wFB8BuZ1TXgKN1CeASw4eQvkHN3mZjz+xl3Ij9Patj97hXvQ5//+t77Au
	 4nxAwzG1Zo4moKf0pWohs7lUiz7eRqSZUTyRk6xhcHmaAmL3eEmJis9tCuOOMRrnWbEU8
	 il6gwgag7GlfQ6UkZoyitJ4X//2O0/CdAiBXvY2jWJxD8jVDsIqrd7P1I0FwAzSb4aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1VrUpu4VYpu87vjHPZLELUMsfC68VJcXD1ptQVtdPA=;
	b=uO2H7HcZnIPLc7Db8v1acPi2W5nT8ag0tRWEQ6qFCv65DDyKSUOBL6ItiBAa7L/vA0wh
	 dWE5VlrLyigTBrYoUDazf8J3YxnbppBOq8RrLh/rZTAXxUvcGn/Ji42P5j9P8teYoXYNb
	 FMjzDdih6cHQk6HTEpF0ysbo4DXrbMRaWlzLd9yfYI2sarkPEas7rBl/4G+m9tqkptyiz
	 4DkSRhcp02421bLgaHhKXJIYtt2ME24Ypv8v1HWEn2vrIZh1qnXnAK4+yxy/KHPLTWc7t
	 vaiGXoQFoH54qyWYjQFMZrd7PVEIwGKd10mLQmi6SVW72jeN+7X1MJY75npW3xZ4cHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBAwa8SS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB93606A32C;
	Wed, 18 Nov 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBAwa8SS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12D81F000C4;
	Wed, 18 Nov 2026 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021922;
	bh=m1VrUpu4VYpu87vjHPZLELUMsfC68VJcXD1ptQVtdPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBAwa8SStT1SWrxcjrwNVttbtLub4A/KmxeHSPR/I4fkedpnmHw+id5F8HzSyMKPa
	 v4WeIG9IXqwypvDep+ofFlZGdQdJT/mxRrO+fp+nY9g3AhCLVuYklBxJAr8TvVoQ0H
	 4X+2XVDbl9xHVs97cTvi7vbHvDHO/soCMlZlal9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2478/2651] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:01:58 +0100
Message-ID: <20261118150414.151368116@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 0177067d195a4757149f6702af191987377c71c3 ]

Replace strncmp() with strcmp() for exact string matching in
parse_optarg_string().  Exact keyword matching is safer and clearer.
This prevents accidental matches with longer strings
like "performance-foo".

Fixes: 4beec1d75196 ("tools/power x86_energy_perf_policy: support HWP.EPP")
Assisted-by: GitHub-Copilot:Claude-Sonnet-4.6
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86_energy_perf_policy/x86_energy_perf_policy.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 0dc959e30076b..1fbe6af508d0f 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -335,22 +335,22 @@ int parse_optarg_string(char *s)
 	int i;
 	char *endptr;
 
-	if (!strncmp(s, "default", 7))
+	if (strcmp(s, "default") == 0)
 		return OPTARG_NORMAL;
 
-	if (!strncmp(s, "normal", 6))
+	if (strcmp(s, "normal") == 0)
 		return OPTARG_NORMAL;
 
-	if (!strncmp(s, "power", 9))
+	if (strcmp(s, "power") == 0)
 		return OPTARG_POWER;
 
-	if (!strncmp(s, "balance-power", 17))
+	if (strcmp(s, "balance-power") == 0)
 		return OPTARG_BALANCE_POWER;
 
-	if (!strncmp(s, "balance-performance", 19))
+	if (strcmp(s, "balance-performance") == 0)
 		return OPTARG_BALANCE_PERFORMANCE;
 
-	if (!strncmp(s, "performance", 11))
+	if (strcmp(s, "performance") == 0)
 		return OPTARG_PERFORMANCE;
 
 	i = strtol(s, &endptr, 0);
-- 
2.53.0



