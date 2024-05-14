Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC3139CE4;
	Tue, 14 May 2024 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687039; cv=none; b=sncDXd/isT00lsmNMHCtV3IOWhu+/8z4WGWxanYSvFbFV3uDgzlScoCOdIhEGPZCdWKMlwJnTCKj8fh2NvMVGEX2MWZD3CGhjJUAaN4KgbgwXdgR3YFllCUrcqGcxV0crEpd3BdR/cjVNsB020uQb340WQ4a57yzTY6khj1/lfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687039; c=relaxed/simple;
	bh=/wAh/74Dyg2OGUIGg3htN1sZ/SK9X6GlRrmarqRdme8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQzLqA0LhqJF2Xw2iPoBQKtxRFYDbrKY02c7f51upFxjrDex1VNr6JdCqNatzZJLmbtz7w3Cc2Oit1pXF3DgBBkZ5Ns8PrcJeUB25WnQ9HJNCIUIspGtonTUZ2FVdrOkfHaewrJaPNTjrcjYTMb94WXKZE05LJ5J/GTdgewZXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yesmkauj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yesmkauj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A538EC2BD10;
	Tue, 14 May 2024 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687039;
	bh=/wAh/74Dyg2OGUIGg3htN1sZ/SK9X6GlRrmarqRdme8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yesmkaujeUP4xeff/henBmcp4gw8nYMmF2DtsOpkq6pT6b12In/04MyZvBbu2eBTn
	 t/mrIxCwr3xJ5DyzN5iKQTdTtvZXPbbDfKxPon2jAI15Xlh+k9q3DHOJY73cy7yFaP
	 RmvEI0p/jcuC36aQm0U074z0RftR/wTVss4JWpcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/84] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:19:55 +0200
Message-ID: <20240514100953.347026677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Liu <liupeng17@lenovo.com>

[ Upstream commit 0b13410b52c4636aacb6964a4253a797c0fa0d16 ]

The code calculates Bzy_MHz by multiplying TSC_delta * APERF_delta/MPERF_delta
The man page erroneously showed that TSC_delta was divided.

Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index a6db83a88e852..25a560c41321d 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -318,7 +318,7 @@ below the processor's base frequency.
 
 Busy% = MPERF_delta/TSC_delta
 
-Bzy_MHz = TSC_delta/APERF_delta/MPERF_delta/measurement_interval
+Bzy_MHz = TSC_delta*APERF_delta/MPERF_delta/measurement_interval
 
 Note that these calculations depend on TSC_delta, so they
 are not reliable during intervals when TSC_MHz is not running at the base frequency.
-- 
2.43.0



