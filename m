Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062099;
	b=FUP8wM1geHJH3892jdW2iJt+TyWQ/BKf5mrgxmvWJ5leNwux5LHZgJTY97VRxYYN1/2q
	 7yRHlBJcASFOI1flZaO7t/XMJGrDnBelwHMWqyqj+2V6ST8KXMeQs8JENfpjbCZycyGpp
	 W9y98v+8uR9TfF2axex/lmtfeFMRrENGwMYSI1q4O0ldTTJjes3bU3ocDNs3FO5xRonSW
	 Tev1PnvHvwjQaxviLhpb6thhAHwrrTPH69OspU9udb+QPk4tVAKmkbdNuw28wUR4EMoOo
	 3X74YxOU+VOI3Suz1nPfAPR7xB4ggKr7pS5fpl+KPxIcI79lwrabdjxjtJoNdDyi3NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CfvYQA6P5/GNqJ4Ec9pRhN7QEJS3kxUZ4a9yrV9H9+s=;
	b=fGqfwfMOJxiOcJH9nfa8gg1r9YCtu90XFexbf8BM/9R4VzG4HkqJk4gerD9w43axFoBw
	 m8AH6M1djdw9p+xvSgznDm8xogBMzQR0NeFHB2Pdt0dJN6GJP8dQgMtHk1M50SGDaoQSa
	 Q1BiYEaK43/QUKzbsjA2uufR9hGg2cMaAB9UCjtpWMzegZ/ESEcqFCGks0fj8liglCCyn
	 tTyvtyjMDMnuxwRkB0OHWRrTy9qGWZ39NaNcBo33tKMcB6t8oT+g13MonG+6yDn8sJk71
	 JH2MlE1MSzPhH4R9XoDSYK5N379OW6PJysdKuXNBCqLK1RBh3sM7ohZP+ci+JokaM8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/RwnL2C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E4606A320;
	Thu, 19 Nov 2026 04:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/RwnL2C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD701F000C4;
	Thu, 19 Nov 2026 04:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062099;
	bh=CfvYQA6P5/GNqJ4Ec9pRhN7QEJS3kxUZ4a9yrV9H9+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/RwnL2ChWK8cAwywTpu3/ZXYfu1G3NBp0AfrwREoliyuoZyHztJKGYAdBfKQyXXq
	 vUICe+/eT48AwpwtM6QhmbtkVEqQYwl4QfQSNJsHV+dfA/9g29DG9nFGxkNQJk2SDp
	 G+6NE8q5y+2PGg/xCyJObAaH0EBE6O014JWgpvBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1790/1848] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150034.237514429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 702b5882cfce4..916694583507e 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -309,22 +309,22 @@ int parse_optarg_string(char *s)
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



