Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033099;
	b=uz/9X895f1NFe1u59yDcQrbl+bwoctBuJCFNoMdzh+AD3uvJajKOU3lT4vYsJ79ndDbb
	 mBm0GVLhZB6ZN8JrENajOInEFr3V+SErzlDz150fI77AUsPgd5VYerAqux0KMlGAawL6i
	 gn2u9I72IzRv/ZYXwjk8xYm1DOk/M7YjCrWoC6qGb7Gn6ib97rK9Nln+xvx9q8y4j+aoC
	 89mmBnwhwb2ibJ/4XYMi3l1jTAHGfMS8EFnq+mE5iXISBC1+h1zeuzMS2XoCJlx1RtCS8
	 myUBAMFIxidoYeo9lj5A7jbk0P4t4NCYsaaoryCJx19AELZDrXWaM4ePO89AJ01OVKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAM6KejkDXrqdfxuSVxT70UqK7dRwGmyw/HBHbdrFOw=;
	b=2UmxySnj4y8E0GHb72NBcqN1JOg71Jv79wzBRZ6GZ5ShEiwcsidRUIjYqcqmAbv2zCyX
	 GzRSzN5ULJpOaTINijbA/ClJ1d0hTw0elsQ9Xbh6QMcFZcmzCBXSc08oyXp1SctQ1rzfw
	 ctNTCDQ9/DLpNvjVyyjtGaU/qBVhV+bY5lCn2tqiIQBarYldt0YmVu4PH/m1ymM0rveMd
	 gnz/uc1hhKFRk/NGYA2GmrQbGSBwtuFLC8C42eIuszPebcAUYACN20hDHnpHzwLmMLp7t
	 LQbyaF2qJdr+mL5j9x0W6Mm0Ad2mNmlccRge2GO70HF9tkVoY+AeBpwBzE6EGL7U9Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilFhInXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE86606A31C;
	Wed, 18 Nov 2026 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilFhInXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4671F000C4;
	Wed, 18 Nov 2026 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033099;
	bh=sAM6KejkDXrqdfxuSVxT70UqK7dRwGmyw/HBHbdrFOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilFhInXlioj0AeTN534pE8wjzcuBwfR/wK0X1L5GR32wMr7zXcgStxN4UHUc7kIHw
	 kF5D0lFp/pspgXLLtlF/3ci5aHyVxQDKduhRs4Qa5JWPIW1MpHEWuPbFUEEUHFjcI4
	 Wgp27Z/r3SO+eVCFLgLxvAVUG+YN2yLbh7UdLu0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1605/1756] x86_energy_perf_policy: Fix optarg keyword matching
Date: Wed, 18 Nov 2026 16:02:12 +0100
Message-ID: <20261118150113.777642941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



