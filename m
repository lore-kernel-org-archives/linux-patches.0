Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29697369D67;
	Wed, 20 May 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299320; cv=none; b=acTXjdFfdw8XFtMOrLLxoNxhbkJl27McR7g6ZWMB/V9a2rCmrGTzUj08ZN78s4U5aqizl30J95apXS/FmD+zwuR2Rlp194a9bVchTZ7gZ5uiRKDwUHUUsUNxytIZORKUeflhHJBWts5esrvLcJ6j28YLcN25dmup48MfSCjk7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299320; c=relaxed/simple;
	bh=IKp8v5qo7kq+/7aBGwzY/7eShQ0CQoeNyG6uFMDf09M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKgLjLQTTAQtDkVWoOfH1upKp6J18U30dLAk8XawukScmQ3/KhT7/u32meQsijC4aSFCKA+G8Yar1SXfcu2SInvjMStEWKVdexoWAQH/N+UPd7VDbtU2Rjx01QL0gdhySnHq16L8ZHdi/9qwZehysnpWm2NTb4u/QTgbQVLgWTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppaCnfjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppaCnfjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAF11F000E9;
	Wed, 20 May 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299319;
	bh=QfZxFZdNah3vIKxMIzQVlN6tyZYQ7WbkPdkimMP2YGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppaCnfjxDWSC7HlRpZDHW2IaQ5f1TU1f5HTY6XLFAhHKVtTyEz/DmBjeHxf1huQhk
	 +c0IYeoEqMNVwBOQraxz3QnIPrYXvXdrWli6NxPjWO76SDYoPqhITQiYdYuCvOvhwp
	 BYPntr/m/o0Lgm19jTiGhw4nzoWkGB0fybRMaELs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 727/957] tools/power turbostat.8: Document the "--force" option
Date: Wed, 20 May 2026 18:20:10 +0200
Message-ID: <20260520162150.320212247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit 785953cf6e63aa5a9fcdfa9577b1411e0281c4bc ]

Starting in turbostat v2025.01.14, turbostat refused to run
on unsupported hardware, pointing to "RUN THE LATEST VERSION"
on turbostat(8).

At that time, turbostat supported and advertised the "--force"
parameter to run anyway (with unsupported results).

Also document "--force" on turbostat.8.

Signed-off-by: Len Brown <len.brown@intel.com>
Stable-dep-of: ce012c966b51 ("tools/power turbostat: Fix unrecognized option '-P'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 3340def58d015..6c9428f98cd2b 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -111,6 +111,8 @@ The column name "all" can be used to enable all disabled-by-default built-in cou
 .PP
 \fB--no-perf\fP Disable all the uses of the perf API.
 .PP
+\fB--force\fPForce turbostat to run on an unsupported platform (minimal defaults).
+.PP
 \fB--interval seconds\fP overrides the default 5.0 second measurement interval.
 .PP
 \fB--num_iterations num\fP number of the measurement iterations.
@@ -161,9 +163,9 @@ The system configuration dump (if --quiet is not used) is followed by statistics
 .PP
 \fBC1, C2, C3...\fP The number times Linux requested the C1, C2, C3 idle state during the measurement interval.  The system summary line shows the sum for all CPUs.  These are C-state names as exported in /sys/devices/system/cpu/cpu*/cpuidle/state*/name.  While their names are generic, their attributes are processor specific. They the system description section of output shows what MWAIT sub-states they are mapped to on each system.  These counters are in the "cpuidle" group, which is disabled, by default.
 .PP
-\fBC1+, C2+, C3+...\fP The idle governor idle state misprediction statistics. Inidcates the number times Linux requested the C1, C2, C3 idle state during the measurement interval, but should have requested a deeper idle state (if it exists and enabled). These statistics come from the /sys/devices/system/cpu/cpu*/cpuidle/state*/below file.  These counters are in the "cpuidle" group, which is disabled, by default.
+\fBC1+, C2+, C3+...\fP The idle governor idle state misprediction statistics. Indicates the number times Linux requested the C1, C2, C3 idle state during the measurement interval, but should have requested a deeper idle state (if it exists and enabled). These statistics come from the /sys/devices/system/cpu/cpu*/cpuidle/state*/below file.  These counters are in the "cpuidle" group, which is disabled, by default.
 .PP
-\fBC1-, C2-, C3-...\fP The idle governor idle state misprediction statistics. Inidcates the number times Linux requested the C1, C2, C3 idle state during the measurement interval, but should have requested a shallower idle state (if it exists and enabled). These statistics come from the /sys/devices/system/cpu/cpu*/cpuidle/state*/above file.  These counters are in the "cpuidle" group, which is disabled, by default.
+\fBC1-, C2-, C3-...\fP The idle governor idle state misprediction statistics. Indicates the number times Linux requested the C1, C2, C3 idle state during the measurement interval, but should have requested a shallower idle state (if it exists and enabled). These statistics come from the /sys/devices/system/cpu/cpu*/cpuidle/state*/above file.  These counters are in the "cpuidle" group, which is disabled, by default.
 .PP
 \fBC1%, C2%, C3%\fP The residency percentage that Linux requested C1, C2, C3....  The system summary is the average of all CPUs in the system.  Note that these are software, reflecting what was requested.  The hardware counters reflect what was actually achieved.  These counters are in the "pct_idle" group, which is enabled by default.
 .PP
@@ -193,7 +195,7 @@ The system configuration dump (if --quiet is not used) is followed by statistics
 .PP
 \fBGFX%C0\fP Percentage of time that at least one GFX compute engine is busy.
 .PP
-\fBCPUGFX%\fP Percentage of time that at least one CPU is busy at the same time as at least one Graphics compute enginer is busy.
+\fBCPUGFX%\fP Percentage of time that at least one CPU is busy at the same time as at least one Graphics compute engine is busy.
 .PP
 \fBPkg%pc2, Pkg%pc3, Pkg%pc6, Pkg%pc7\fP percentage residency in hardware package idle states.  These numbers are from hardware residency counters.
 .PP
@@ -556,6 +558,8 @@ If the upstream version isn't new enough, the development tree can be found here
 If the development tree doesn't work, please contact the author via chat,
 or via email with the word "turbostat" on the Subject line.
 
+An old turbostat binary may run on unknown hardware by using "--force",
+but results are unsupported.
 .SH FILES
 .ta
 .nf
-- 
2.53.0



