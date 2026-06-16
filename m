Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F7444CF44;
	Tue, 16 Jun 2026 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625330; cv=none; b=V4TeCAUo4yuyxkzeJ3tt2RGJ+P8gtS/eBbDl4c5yB1Nt7w5DhYzZjfyWckDqmTfyADhxK63kDtTnb5JFQi4asbyqdFSArVXqJCi3eutwXEmlo/9V0WA7UlLKEzyXH6GeOjib/tofgWJLnGggBDuvCkFr25aAHQXIE/6aHf7Qp/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625330; c=relaxed/simple;
	bh=CqUS2OgRkIWS3edTfi89l89vcWGViUcxURjH89PPYc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNxYqEoFT1PmTmKwZp+URhWvHwNfI+hQG3JIb6p/5q0id4bgOl/zufbd3nwJHYeNLHJCWdS6jLo8ghe69+u/XVnoRxrFLLVFP+Ve+h+LQgrk0KR687U0OP9KK1JlCfwwt6wQWLXMBIkVHW+bgepzvGCtlxLckiYQmdmZ+bAuhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPt/Ktpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPt/Ktpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1282A1F000E9;
	Tue, 16 Jun 2026 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625329;
	bh=No6Pm4h5Pfsd5gp/Rxi4/EG17sLfouRxdCiSwxia3uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPt/Ktpc/4bq+lnlpNRKKWWkH4PeG9n/i+NHopxPk0u7yEM1vcWscqItWXCZ+BpAT
	 NIGcWsvsG69zGCaMcHCWBCVXz4zti5LouTtLPD1A9w6qW5l837IcfQWoFq04nnrtkV
	 mB0ZEovz7VtqD/QYEmh8E6mnxxIOlqCBNLWQUhCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/325] cpufreq/amd-pstate: drop stale @epp_cached kdoc
Date: Tue, 16 Jun 2026 20:27:54 +0530
Message-ID: <20260616145101.618941989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 3cd07ee35a66038fd1a643632bfc057645e07c9a ]

Commit 4e16c1175238 ("cpufreq/amd-pstate: Stop caching EPP") removed
the epp_cached field from struct amd_cpudata in favour of always
reading from cppc_req_cached, but the kdoc above the struct still
documents @epp_cached.

Drop the now-stale @epp_cached entry.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 4e16c1175238 ("cpufreq/amd-pstate: Stop caching EPP")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Link: https://lore.kernel.org/r/20260526022131.1302373-1-zhanxusheng@xiaomi.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
index cb45fdca27a6c7..75136d2250c1a5 100644
--- a/drivers/cpufreq/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -76,7 +76,6 @@ struct amd_aperf_mperf {
  * @hw_prefcore: check whether HW supports preferred core featue.
  * 		  Only when hw_prefcore and early prefcore param are true,
  * 		  AMD P-State driver supports preferred core featue.
- * @epp_cached: Cached CPPC energy-performance preference value
  * @policy: Cpufreq policy value
  *
  * The amd_cpudata is key private data for each CPU thread in AMD P-State, and
-- 
2.53.0



