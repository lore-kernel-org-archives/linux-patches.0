Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024750;
	b=cd1KDHsktVvoD8S8Y/MyaNwp3xyjVLPrT36At66lW56ggbQ9H3zTql4rqWwlG+ZXhbAH
	 RQ6xoGgFE2lraRNAt/9wtaFidC8pifbNrFaEySDYWYp09dnApP7X4MHD95JocPO7IfbDI
	 iMY5JbPbBxlzupFgKQtFd4WpZ2lIWKaqus0zEX5tk2BaDgyHYNsbdl80GKwFk1wGO+Ml9
	 Z1JM1YcL1cH8vgQ4TfIc3nWIfCHFvLw9DeoIHTfB23m8hoFZ7FJ2DqW2165EZ1+EWI515
	 fYm6IIv8AvZUC5f8E46n/IC1OneVJ4F63FdPqq6TZRqV1+zLnO9ThvnVAmlyTF9ZOgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0HTJ9U0t186ijsKo/YYY8g0cpe7uFCuEBLLRY7TzneI=;
	b=Wbd25lGDi50gJZmxT1OJOy8+tyDw+S8FmojBXvT9q/eWAs/QXPkpFUTPRDn3CTjK+QDF
	 CvD4wIQkTk39G6TjH1Znc75xKaQLFGQmPAekFqlCaqB4HWlCAdQ47zUDofQ1TcWWZ/pPc
	 3hcYm/53VPlye8k1E+N57N01wYmjzfjQsIV+3NUaf7SewWsClEOJo2V+IBFHfKH8J3xEL
	 CgKHphdyxX0kSZ1QEIIAV7RB0GWxO5eGvUkPSiaUcbCoFeo0zK06f+1P6fkXrYiaD4qoc
	 4Dwt8mdTGeN3D+N+sN+1m7TtP+0RHjGXo4ufg4Ilqg7PaH9r5G5a5NvNmI7pkXHy9/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Njfv6xAF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57C606A333;
	Wed, 18 Nov 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Njfv6xAF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9861F000C4;
	Wed, 18 Nov 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024750;
	bh=0HTJ9U0t186ijsKo/YYY8g0cpe7uFCuEBLLRY7TzneI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Njfv6xAFJto3Q1sCXDdDSnMmsFGpkXqW6ASa4GoCMHVb59KcluO7motp6V7nRg3Rl
	 DDzLWqIMSqlcA+TeCPSaRxspIQX8a6TJzwLKzy0GW6Pr6KDJjKhx88RhdMKTLrAgeY
	 Mv1ElwMIU/NTYJHSciIs9+pRfT/lo470aKF/RumM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0837/2151] perf vendor events intel: Fix snowridgex umask encoding.
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150152.699794903@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8a0b9c9ff582258aafc6d6c8fe3fb104d9686a7b ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 2bb848f820a5 ("perf vendor events intel: Fix uncore topics for snowridgex")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/x86/snowridgex/uncore-cache.json     | 68 +++++++++++++++++++
 .../x86/snowridgex/uncore-interconnect.json   | 10 +++
 2 files changed, 78 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json
index a81776deb2e61..c32f1f3f826ac 100644
--- a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json
@@ -1592,6 +1592,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : All Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Any local or remote transaction to the LLC, including prefetch.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -1624,6 +1625,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : CRd Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Local or remote CRd transactions to the LLC.  This includes CRd prefetch.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -1645,6 +1647,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Local request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Any local transaction to the LLC, including prefetches from the Core",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -1687,6 +1690,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Data Read Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Read transactions.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -1752,6 +1756,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Flush or Invalidate Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -1773,6 +1778,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Transactions homed locally Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Transaction whose address resides in the local MC.",
+        "UMask": "0x80000",
         "Unit": "CHA"
     },
     {
@@ -1805,6 +1811,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Write Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Writeback transactions to the LLC  This includes all write transactions -- both Cacheable and UC.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -1925,6 +1932,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : RFO Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Local or remote RFO transactions to the LLC.  This includes RFO prefetch.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -2077,6 +2085,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Lines Victimized : Local Only : Counts the number of lines that were victimized on a fill.  This can be filtered by the state that the line was in.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -2195,6 +2204,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x10000000",
         "Unit": "CHA"
     },
     {
@@ -2205,6 +2215,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x20000000",
         "Unit": "CHA"
     },
     {
@@ -2215,6 +2226,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x80000",
         "Unit": "CHA"
     },
     {
@@ -2225,6 +2237,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x8000000",
         "Unit": "CHA"
     },
     {
@@ -2235,6 +2248,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -2289,6 +2303,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -2299,6 +2314,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x10000",
         "Unit": "CHA"
     },
     {
@@ -2309,6 +2325,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -2319,6 +2336,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -2329,6 +2347,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200000",
         "Unit": "CHA"
     },
     {
@@ -2339,6 +2358,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x4000000",
         "Unit": "CHA"
     },
     {
@@ -2349,6 +2369,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x800000",
         "Unit": "CHA"
     },
     {
@@ -2359,6 +2380,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x1000000",
         "Unit": "CHA"
     },
     {
@@ -2369,6 +2391,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -2379,6 +2402,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -2411,6 +2435,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100000",
         "Unit": "CHA"
     },
     {
@@ -2421,6 +2446,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -2431,6 +2457,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x400000",
         "Unit": "CHA"
     },
     {
@@ -2441,6 +2468,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x2000000",
         "Unit": "CHA"
     },
     {
@@ -2451,6 +2479,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -2461,6 +2490,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -2471,6 +2501,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -2481,6 +2512,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -2491,6 +2523,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -2523,6 +2556,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC10 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 10 only.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -2533,6 +2567,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC11 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 11 only.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -2543,6 +2578,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC12 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 12 only.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -2553,6 +2589,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC13 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 13 only.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -2629,6 +2666,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC8 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 8 only.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -2639,6 +2677,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC9 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 9 only.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -5047,6 +5086,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : DDR4 Access : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -5057,6 +5097,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.DDR4",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -5078,6 +5119,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Hits : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -5687,6 +5729,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just ISOC : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -5697,6 +5740,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Local Targets : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -5740,6 +5784,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Match the Opcode in b[29:19] of the extended umask field : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -5750,6 +5795,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Misses : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -5760,6 +5806,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : MMCFG Access : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -5770,6 +5817,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NearMem : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -5780,6 +5828,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NonCoherent : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -5790,6 +5839,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NotNearMem : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -5800,6 +5850,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Match the PreMorphed Opcode in b[29:19] of the extended umask field : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000",
         "Unit": "CHA"
     },
     {
@@ -5832,6 +5883,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : DDR4 Access : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -5853,6 +5905,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Hits : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -6440,6 +6493,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just ISOC : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -6450,6 +6504,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Local Targets : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -6493,6 +6548,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Match the Opcode in b[29:19] of the extended umask field : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -6503,6 +6559,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Misses : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -6513,6 +6570,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : MMCFG Access : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -6523,6 +6581,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NearMem : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -6533,6 +6592,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NonCoherent : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -6543,6 +6603,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NotNearMem : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -6553,6 +6614,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Match the PreMorphed Opcode in b[29:19] of the extended umask field : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000",
         "Unit": "CHA"
     },
     {
@@ -8356,6 +8418,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC10 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 10 only.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -8366,6 +8429,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC11 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 11 only.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -8376,6 +8440,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC12 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 12 only.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -8386,6 +8451,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC13 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 13 only.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -8462,6 +8528,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC8 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 8 only.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -8472,6 +8539,7 @@
         "Experimental": "1",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC9 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 9 only.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
index 88ee90b8a2d9f..9667e4f48c13a 100644
--- a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
@@ -2210,6 +2210,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.CH0_FROM_TGR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x500",
         "Unit": "M2M"
     },
     {
@@ -2239,6 +2240,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.CH0_NI_MISS",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "M2M"
     },
     {
@@ -2278,6 +2280,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.CH1_FROM_TGR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x900",
         "Unit": "M2M"
     },
     {
@@ -2307,6 +2310,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.CH1_NI_MISS",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0xc00",
         "Unit": "M2M"
     },
     {
@@ -2336,6 +2340,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.FROM_TGR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x1d00",
         "Unit": "M2M"
     },
     {
@@ -2365,6 +2370,7 @@
         "EventName": "UNC_M2M_IMC_WRITES.NI_MISS",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x1c00",
         "Unit": "M2M"
     },
     {
@@ -2837,6 +2843,7 @@
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH0.RPQ_PROXY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "M2M"
     },
     {
@@ -2866,6 +2873,7 @@
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH0.XPT_THRESH",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "M2M"
     },
     {
@@ -2935,6 +2943,7 @@
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH1.RPQ_PROXY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "M2M"
     },
     {
@@ -2964,6 +2973,7 @@
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH1.XPT_THRESH",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "M2M"
     },
     {
-- 
2.53.0



