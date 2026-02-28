Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A235433FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300924; cv=none; b=XzNzNxOa5UplQxnuPhOsz9AmXoZMmP+LaqB7uRZozeFLxkrsG1zzTW9n0nx1uVIpiHUkuVj/UVIQZr00vZitGNUGsmbzNLGNHOHdYkfMSIj0coaPOmnJbshT4S2f9ud0bFm/kkgqn0V+Hr98uf0dBaXAXl/HzN++9ONeT88oKB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300924; c=relaxed/simple;
	bh=7vVPGALmuNeLk8yGU4KurhELNTDP0geSF1U6fTA/0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+Wd1QD3zUM7dzia/y78bi0lWfkGTHdGTY8wQOU7HZ6yR7AUbw2PO4/HqyrTru+7nwcfxavolnTfIUWkbRZFnS6JSZYnSJtubwLl7z7IYXADRzvncLVU8J+I8ovGFrJzHrtruY8l1mU7wjMX45s26T8lWIi3RRWIPcEBdNLhMbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GY5snOC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GY5snOC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A097C19423;
	Sat, 28 Feb 2026 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300924;
	bh=7vVPGALmuNeLk8yGU4KurhELNTDP0geSF1U6fTA/0yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GY5snOC5yoE4eEe+q3yRKyLuDU0t1dBqirBvRIIBz2db2zozi2WPoQD+VubX0KZt0
	 e5+1Uoz8uWzfv4aCGzx9RvuKAIf3ewbeB05z3H/I18qwb4rRJYaw/9gKxN52E4+4NX
	 WJfM2sFxf5hk7/Ax25ah1GdBeMdAhUXyzNhMv2jOTfgf6sY1Gb/5nYu0tAjQZZDwPK
	 47yW2WzeNKXvGK+4laBV66BGL8mgG9fiXvmk+XqylF9Ke4xeLz4ba6nXP3PF4NGKF8
	 7BYcYycq5+jlcXYMALkR60ndZn/g+hUpGKh0Rv5pYiTIJmPcLKmWkJP7YRThHIG2xf
	 VIg9+yQPmvjbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/752] tools/cpupower: Fix inverted APERF capability check
Date: Sat, 28 Feb 2026 12:35:53 -0500
Message-ID: <20260228174750.1542406-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 24858a84163c8d04827166b3bcaed80612bb62fc ]

The capability check was inverted, causing the function to return
error when APERF support is available and proceed when it is not.

Negate the condition to return error only when APERF capability
is absent.

Link: https://lore.kernel.org/r/20251126091613.567480-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/cpufreq-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/cpufreq-info.c b/tools/power/cpupower/utils/cpufreq-info.c
index 7d3732f5f2f6f..5fe01e516817e 100644
--- a/tools/power/cpupower/utils/cpufreq-info.c
+++ b/tools/power/cpupower/utils/cpufreq-info.c
@@ -270,7 +270,7 @@ static int get_freq_hardware(unsigned int cpu, unsigned int human)
 {
 	unsigned long freq;
 
-	if (cpupower_cpu_info.caps & CPUPOWER_CAP_APERF)
+	if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_APERF))
 		return -EINVAL;
 
 	freq = cpufreq_get_freq_hardware(cpu);
-- 
2.51.0

