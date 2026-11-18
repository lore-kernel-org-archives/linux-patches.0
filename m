Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056871;
	b=1fIZT2WSQ5jGY7PxXCY5V56HXD2mld4VLtVtLl0kb6c2cmt64seA55PBFiTFS8TCvgnD
	 It0F1lyToamEtDo7hONELFOmFhFdbXXKGd5uUvrTmpdi+3TVpcoF7PQFOuDi+P/PHKav5
	 cyExrsi4JFkYDxXS7WFOPwr5nTBPak3M/BykYodcSoF2KPBDg2hEdhiBaRZyy0Sv0MMuX
	 2ymfVJj+8dIcbE7im+gmYqkV100Pp4C1WMfo/dyqw+Y4GdmFsU58mwd9ymiFTGnGxr2HJ
	 00+yD0cOnVTKasEtCjPE0xUddgxD5z0194jKRCGcS0PkOwyk1dZzsy6BKbi0b9Waewg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ssapeYAdxkJKPiWUuu+bp9+3RslI3zrZYlcN7MD0kA=;
	b=UCgeYqED/jk3EE6JZYVqLZxawFHHOV+aMXXTm358gRGOumBD3eMM0jzgl13asDmg5y3Q
	 L45oP2aNybawNtW2jhFa6xICidaXSYWTxT+Fx/YdYWD6ODFH+JjAtSih5OAEqD7w1z9fq
	 XbOmDaneHSN+mtJJFx3YLFSDrXwtVF04r2jQQz8vBAl1L7sN2y9teu4bKY0ABeJV/xXcs
	 P0CkvrNtwVe240bM0KLxr+xQ7OdfD8vGlJuxxMAyaUkQkTDrKGqox8B47JQvq8tQA8De0
	 yCU/i/+7eol7xL+xVY6tMVcT61kz37S7iZBzF6Do19caFAzUtHEi2k6I8j0MKBnKNXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrzBX9XW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D75606A32F;
	Thu, 19 Nov 2026 02:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrzBX9XW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1811F000C4;
	Thu, 19 Nov 2026 02:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056871;
	bh=0ssapeYAdxkJKPiWUuu+bp9+3RslI3zrZYlcN7MD0kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrzBX9XW5hGUhCSfwd/9eNIW+cQewnjPG7OTj1RkkE7RCAJLemDGKWvx4Righ1kD3
	 5fLeVzOp6wnaImDJd5OuAZLgxyatdB23LCrCziI6p+BD8cmX78XbRzKGnsP8bLh9jc
	 jvV15t1byNJXBZJ7OPezd+NqzirKdmAGDpEfKHGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2142/2214] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:03:38 +0100
Message-ID: <20261118150136.185365507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



