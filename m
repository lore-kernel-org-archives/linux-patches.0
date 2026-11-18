Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042518;
	b=5GB0I3hO78KgbrXMxcd5CLYmXEsvf9arPCak4Nt6LqqCmLiAIydIZHxNd5YzrnrQ43Lj
	 t4GoiHvEiJmaaPDBj4MI6vicQ1ErEdBl0RZnaqDSJdpxYwXQ9HOP56wov4Cdgd8yVWk92
	 3uBCTKjLrIfiI4VqQRvYvLiWuZOubt6+RZjH+Xr+2GzJsXWhoASeKaZZF3jTmnp571PEn
	 yBDg9cuBfyA+ZgreUsa1dCPOQV0ozeh/jhokDSANSOMMiNH6URQTFok/nj0fLoLqPTBeU
	 VCNCxuJnZgybVsNYa0EM0vXJhFSRj+F+P+WPnSGbtgz2+9x3uoAhs+bjBAKNvtokC4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3WgiNhY8dMYYgfTiJIzkvxKNtAGzURq3rmtuZeULfU=;
	b=JL8IjGIYuvLws0dXYd/S0McngGEW3wf8JFDMk+66chnJs8wp0IOFtHyk0eEeYVq2DDfu
	 DlxR1JxNWogguLaMgVAEQoV3EhQoOjHJu5BfTI+CbYwiIZZRuOstBjVEYG3gyAIqODbjG
	 TlYIqleJnL1qauchUeOcZwb9lRjgHRjPz1GXGAe9xiMXYXWqUn5tvhFjVjMyDW6rRVwyg
	 dNJjIh2NMv81wR5AWb/f/qPZtHvmhoWavalTi4DQht73Vlwl/nJF0zHCxVjMc9BZahhvH
	 UI3EWAp13h1YqoAuY7JO6vFdTCxsGCDK1XC+JwNNd2rSjhK/xfrV09F+J7wwNe1Xnrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NgXkW/ao";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D8606A325;
	Wed, 18 Nov 2026 22:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgXkW/ao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F08B1F000C4;
	Wed, 18 Nov 2026 22:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042518;
	bh=Z3WgiNhY8dMYYgfTiJIzkvxKNtAGzURq3rmtuZeULfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgXkW/aoBvzC/+0F0tWGappZW6FOXFKMT5vOOTkAuG4MEWar0c1AtzSmBpvFlinzs
	 gb+OsAai/cYcar1+YVM1goysowdmfHLnxcLrPFD+/KcGzIJSCfE8C9NhG0QI/xQMeT
	 7/RGwnk3zXsldjFHUYUO3SbfN1QZYYeTMRR3Al/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3197/3318] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:03:39 +0100
Message-ID: <20261118150455.682943849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



