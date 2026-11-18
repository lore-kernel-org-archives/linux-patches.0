Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028048;
	b=wh7666V0stlUow8OUFXdl2IcjXofhJSiVhWQVfullvUaQwmEqaTC62x/gmEoNtTZ5QaA
	 KadZcRf2HVgNgFuIcdFpoekob4LiZfeItuKSdj2lolaJbpkdUCukoeVx7JCvJhFkanfkt
	 XL/NCWXBFlfiCVpgDdDZ6KeTB+C/zyr5ZLbTXg8o9oNQNqw5WlCG1OJNqjrAafOCimjX7
	 sZ2ql7jDFuJCjAh2bZk82nhWOGTuFdIR0P/i1orZWV0fMpaUwQH8IiJt1fhXG+pVBOQng
	 vlNmVHxugt8l6pp02y1MoNOIsQAP56VMBU+nTTxhhPMAM3tzOgsugcxgz34zMho1oeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DIlfNjGZfsp5BtQINM7ww78O/Z5cb2ahf1h0eH/vcYg=;
	b=3Vq+Rh78Di/EBBPre2nwCpOfMsoF4auikQ8gCdVDaKp9xFs5S66iEtnmw5u7UolwNRNq
	 X9dWLRsyZBf2z5Phdcyc6YV+7qsuDVYHGAXp6SNrljYLFnOWkcf45qI0Gp+awrrkJWolO
	 Gv6KKVmR4Mx4+m0Csmh2Y0UFpSuZVqWuqbs6ZEx9w+erSblcm9+PdS8UhxUZX+wSbI58k
	 KeQeHy/5IUeLQgMTSjYIuRr0QGpufeIX/nyonk8HzOvZgDieQ8czqBnHEM0WjPRZu9adl
	 BSBntvh4NHd6nJKts77H4XB63uthmtuEGsNsjAWsKSIuRqFEbJQD+G/NderpUT1m0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06chirtf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B89A606A31C;
	Wed, 18 Nov 2026 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06chirtf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B8E1F000C4;
	Wed, 18 Nov 2026 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028047;
	bh=DIlfNjGZfsp5BtQINM7ww78O/Z5cb2ahf1h0eH/vcYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06chirtfgIG8qpVqVPhatG4KnZxqKHntzkMCo49nr8CLiFohUf9K/Tj4nKPPGpMTn
	 7wjs8IkOXnFtNg6jSu+0e3TI1DbI/q4hnz0p3hc1E08gBsyTxI42wLR/hASSCaHHyy
	 hHyBJFikF644cPT/2wlq1y+DPPgpcroDkhuUs5+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1999/2151] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:02:14 +0100
Message-ID: <20261118150234.542180468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 884a4c746f32e..4aefdd3699f40 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -312,22 +312,22 @@ int parse_optarg_string(char *s)
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



