Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3A139568;
	Tue, 14 May 2024 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682934; cv=none; b=kfV+1EyifCjyZQoCYGRDrkWgVZ1a3cMCIeL1+6QPc/ULs7Wuhx8gn4uz6dzFpwKUsdR3OH1ZSWfYSvSIhNAxgdZ0hci89zJlMNVzNE6xr2V/YqLY6SMox6D+rUHdwB2tmzjEjfW7omVvW6f5KlvYwlQzcnW7dKx9Z6ZWIuyG9QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682934; c=relaxed/simple;
	bh=+lZuthWITtUxAki4VdK6SExSbTPA8FmOLIRWQv/oFNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7wY3N7vMWMIdbNl1w0rmZ+Kt5S58rE6Jn8pa3FmrOhE0ZkUgbI+GXiZWcVn+xqmAu4m02zm1WhSi8H71/GvnqQ65o4n7FWMbPPisCuBRxcil/pXSXSMO+CjfnBcFe4q3SJYktyv8XyJSFJda9mQpCxYQIGhOZd8t3iM00NGqNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jl/zZP37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jl/zZP37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D0CC2BD10;
	Tue, 14 May 2024 10:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682934;
	bh=+lZuthWITtUxAki4VdK6SExSbTPA8FmOLIRWQv/oFNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jl/zZP37gDBkd0RW+G+U6YjwMOBmNTHtu0w0ujglvsLDhAwhSWMi+Mk28ANq4CHnw
	 ru4leIw0b5loJTTu0e50xE47KO0iaQ9sj4G2UbCArAOZBDdu1joGcKQBfU6czf1AZS
	 24l+B2frRhRZUwF1iYmK2EQVryg8Mh24x53mgzmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 136/336] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:15:40 +0200
Message-ID: <20240514101043.734502503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8f08c3fd498d5..1ba6340d3b3da 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -370,7 +370,7 @@ below the processor's base frequency.
 
 Busy% = MPERF_delta/TSC_delta
 
-Bzy_MHz = TSC_delta/APERF_delta/MPERF_delta/measurement_interval
+Bzy_MHz = TSC_delta*APERF_delta/MPERF_delta/measurement_interval
 
 Note that these calculations depend on TSC_delta, so they
 are not reliable during intervals when TSC_MHz is not running at the base frequency.
-- 
2.43.0



