Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050619;
	b=qJNf7zNTEzwcHCUr7/VqqR8ofWmGvxU849arwn+N8M6RYON/3m+D/qE8ymhmncJbJWSU
	 M15vd0vlaMoVArb2IZyyJpCL4yyWxippFedbFEDbXn0aT4UXn58uU1r5RXoNlTcpWiDYL
	 PCjyTRPfV9ZtW+06djsusMyp/lLCP9BQrPtQg+KBCWUgYljaZ2rdHrSqyGK/Cy2VlljIJ
	 N5WQ9FoZy0TVvxgsN/0+DjWPY1J6uYQUGRNLu9LPo4POELcMwX4I1SQ2WopcwsXUlhPZv
	 oPWWxVbe6tZ1UXgC7HTfP2FtBt6O+OaVx3UrvwLA3QSnR3gQINDVENuH7Mu++STQ0aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aswtg2AcP6PCG61YuIzL5RsLDPXql19pGWYkAaZRmm4=;
	b=PhVbhR5T3VhwVRXW7MKU7uq3FgaKl1Mk+9hg9qcfaaz6sZn/0X3UI4Idnk+qNiqp/L/R
	 1D8BiSk7KLF2sRdVp9tGc5rBqTfnYrMMkJYflGemCbmr1p11IeyAQZvBzrsmcPbODDqqU
	 t2mnv/+y5RPnrAKnuiWsFJvbEQgtiO7gXVV8dzBjgAOK/Q4tmBsnYpuCWnhkODO+MrfiD
	 l4TKAcXP8iG1Z8yKXcv5ZZ/iA5UCsrdageqHG+rc8Y68xNkiLl2n1Ru1i9yR0Xk354qm3
	 iUeNBRxNTh6DI+Y01kqlN5V25HcGGvz3CSchruYOw0PMdrJ/k+iPsT4rJN+yfVykXnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3B8nKUc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2448B606A31C;
	Thu, 19 Nov 2026 01:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3B8nKUc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B941F000C4;
	Thu, 19 Nov 2026 01:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050619;
	bh=Aswtg2AcP6PCG61YuIzL5RsLDPXql19pGWYkAaZRmm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3B8nKUcCunRvt/o5i9eLsiaOHM5l0lzXzfwdI/g+Vex8YrfTBc9OWwDRy+O/GFAh
	 MG39fLeALp+W+oYBjoIOicT7Ge6bRYaI0/J63J/tJgUnxXq5eZToCpDUtrcF+5dXON
	 gNqZylRUTMGWe+/mxeDjgnfUYyP+/3mkhu/Clmek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2755/2857] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:03:09 +0100
Message-ID: <20261118150340.803904926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 891738116c8b2..2545f64d5f43b 100644
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



