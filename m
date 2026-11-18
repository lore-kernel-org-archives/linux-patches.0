Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040380;
	b=t0OtOhnevvZkQni08yo/J078Annn9o3oNj48HLG/QYjDh5j2gaV2qZNOcXtWGl9OLu8B
	 Lvi/PvvbVDrE4frKTT5Q/0rVdQ2QHE2I/eEoACdsIe5THPhLP6HZHe7gi8t5zj7efxDbu
	 M3FN4DyuCcG574lFdDUMWKwreF569OONAQQPtHEGm6n9SHWKOeAIywtmVrncDznSm2ShF
	 5PAycKX0cbqiQCsSxvSQGpmTVSwWotZ4Xt/PrdJYXPSIKsxCFYMcLUdXltM7Rc9eX4CWI
	 KAiucU/LujF2Uk8CfiHwSkwpwFfXd+yI42A/SunvCYdh9hiGA5RvOJvtqfJ7zTC/tLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=niwhlgpqgHtoktgmpPF8ukO1amjhcu60rz3GYZb4dj4=;
	b=PfubZ1mpYdkmOEWqvh8xg0CUa6nHJrhm8xCoJjE5scS1hqN/KNwNnugmsppX+YSqJeUN
	 blHKoUv5lArUedx25bi4DwBi1StqJ13UaCZ3hQ8up8Yi60FOEFJtsbk7NyzYlepSKzbLU
	 ppzBQgI1ZSk1Apx1hgaOjjZRpaAZ9U6FrrLRIEdBuTyupDCPnqOimfxugI3jOzZ/+o2mh
	 Nhs1FnXtjPwuiY/hQgUC6QAKoskxy3O50Azc6L0HTjFZxy1trVsJDX1dSL8DXXHMw4y45
	 tumSr4LMpkbL/B4QN/GfkIFMir62z+eLtZ6ag6dbpj+r/XxURg9+rzswale5sdI1t2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7wz26Ix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98869606A32A;
	Wed, 18 Nov 2026 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7wz26Ix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B0E1F000CA;
	Wed, 18 Nov 2026 22:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040380;
	bh=niwhlgpqgHtoktgmpPF8ukO1amjhcu60rz3GYZb4dj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7wz26Ixzb47rildLrWFXocpJ6edrnUUpzNTzSe7SKQOF/P22+o49bpPnVkTh38Qu
	 VHGe/s3gBKYS/gYR7QN0MZQg7SowKsrMGLB84o2nwntkaji9TgGh+YO30lN8jTGIBE
	 tdzTfTKUcB6zvQjlscBE3VSyei8DmRqN5s0+Blhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2435/3318] perf vendor events intel: Fix snowridgex umask encoding.
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118150434.506467582@linuxfoundation.org>
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
index a68a5bb05c22b..c9b8e41e4e4e4 100644
--- a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-cache.json
@@ -1354,6 +1354,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.ANY_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : All Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Any local or remote transaction to the LLC, including prefetch.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -1380,6 +1381,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.CODE_READ_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : CRd Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Local or remote CRd transactions to the LLC.  This includes CRd prefetch.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -1397,6 +1399,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.COREPREF_OR_DMND_LOCAL_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Local request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Any local transaction to the LLC, including prefetches from the Core",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -1432,6 +1435,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.DATA_READ_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Data Read Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Read transactions.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -1485,6 +1489,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.FLUSH_OR_INV_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Flush or Invalidate Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -1502,6 +1507,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.LOCAL_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Transactions homed locally Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Transaction whose address resides in the local MC.",
+        "UMask": "0x80000",
         "Unit": "CHA"
     },
     {
@@ -1528,6 +1534,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.OTHER_REQ_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : Write Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Writeback transactions to the LLC  This includes all write transactions -- both Cacheable and UC.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -1626,6 +1633,7 @@
         "EventName": "UNC_CHA_LLC_LOOKUP.RFO_F",
         "PerPkg": "1",
         "PublicDescription": "Cache Lookups : RFO Request Filter : Counts the number of times the LLC was accessed - this includes code, data, prefetches and hints coming from L2.  This has numerous filters available.  Note the non-standard filtering equation.  This event will count requests that lookup the cache multiple times with multiple increments.  One must ALWAYS select a state or states (in the umask field) to match.  Otherwise, the event will count nothing. : Local or remote RFO transactions to the LLC.  This includes RFO prefetch.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -1751,6 +1759,7 @@
         "EventName": "UNC_CHA_LLC_VICTIMS.LOCAL_ONLY",
         "PerPkg": "1",
         "PublicDescription": "Lines Victimized : Local Only : Counts the number of lines that were victimized on a fill.  This can be filtered by the state that the line was in.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -1847,6 +1856,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.ADEGRCREDIT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x10000000",
         "Unit": "CHA"
     },
     {
@@ -1855,6 +1865,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.AKEGRCREDIT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x20000000",
         "Unit": "CHA"
     },
     {
@@ -1863,6 +1874,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.ALLRSFWAYS_RES",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x80000",
         "Unit": "CHA"
     },
     {
@@ -1871,6 +1883,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.BLEGRCREDIT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x8000000",
         "Unit": "CHA"
     },
     {
@@ -1879,6 +1892,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.FSF_VICP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -1923,6 +1937,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.HACREDIT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -1931,6 +1946,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.IDX_INPIPE",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x10000",
         "Unit": "CHA"
     },
     {
@@ -1939,6 +1955,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.IPQ_SETMATCH_VICP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -1947,6 +1964,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.IRQ_SETMATCH_VICP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -1955,6 +1973,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.ISMQ_SETMATCH_VICP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200000",
         "Unit": "CHA"
     },
     {
@@ -1963,6 +1982,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.IVEGRCREDIT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x4000000",
         "Unit": "CHA"
     },
     {
@@ -1971,6 +1991,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.LLC_WAYS_RES",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x800000",
         "Unit": "CHA"
     },
     {
@@ -1979,6 +2000,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.NOTALLOWSNOOP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x1000000",
         "Unit": "CHA"
     },
     {
@@ -1987,6 +2009,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.ONE_FSF_VIC",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -1995,6 +2018,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.ONE_RSP_CON",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -2021,6 +2045,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.RRQ_SETMATCH_VICP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100000",
         "Unit": "CHA"
     },
     {
@@ -2029,6 +2054,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.SETMATCHENTRYWSCT",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -2037,6 +2063,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.SF_WAYS_RES",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x400000",
         "Unit": "CHA"
     },
     {
@@ -2045,6 +2072,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.TOPA_MATCH",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x2000000",
         "Unit": "CHA"
     },
     {
@@ -2053,6 +2081,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.TORID_MATCH_GO_P",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -2061,6 +2090,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.VN_AD_REQ",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -2069,6 +2099,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.VN_AD_RSP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -2093,6 +2124,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.VN_BL_RSP",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -2109,6 +2141,7 @@
         "EventName": "UNC_CHA_PIPE_REJECT.WAY_MATCH",
         "PerPkg": "1",
         "PublicDescription": "Pipe Rejects : More Miscellaneous events in the Cbo.",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -2135,6 +2168,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC10",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC10 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 10 only.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -2143,6 +2177,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC11",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC11 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 11 only.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -2151,6 +2186,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC12",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC12 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 12 only.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -2159,6 +2195,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC13",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC13 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 13 only.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -2221,6 +2258,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC8",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC8 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 8 only.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -2229,6 +2267,7 @@
         "EventName": "UNC_CHA_READ_NO_CREDITS.MC9",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx READ Credits Empty : MC9 : Counts the number of times when there are no credits available for sending reads from the CHA into the iMC.  In order to send reads into the memory controller, the HA must first acquire a credit for the iMC's AD Ingress queue. : Filter for memory controller 9 only.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -4198,6 +4237,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.DDR",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : DDR4 Access : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -4206,6 +4246,7 @@
         "EventCode": "0x35",
         "EventName": "UNC_CHA_TOR_INSERTS.DDR4",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -4223,6 +4264,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.HIT",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Hits : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -4753,6 +4795,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.ISOC",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just ISOC : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -4761,6 +4804,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.LOCAL_TGT",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Local Targets : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -4796,6 +4840,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.MATCH_OPC",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Match the Opcode in b[29:19] of the extended umask field : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -4804,6 +4849,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.MISS",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just Misses : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -4812,6 +4858,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.MMCFG",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : MMCFG Access : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -4820,6 +4867,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.NEARMEM",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NearMem : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -4828,6 +4876,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.NONCOH",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NonCoherent : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -4836,6 +4885,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.NOT_NEARMEM",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Just NotNearMem : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -4844,6 +4894,7 @@
         "EventName": "UNC_CHA_TOR_INSERTS.PREMORPH_OPC",
         "PerPkg": "1",
         "PublicDescription": "TOR Inserts : Match the PreMorphed Opcode in b[29:19] of the extended umask field : Counts the number of entries successfully inserted into the TOR that match qualifications specified by the subevent.   Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000",
         "Unit": "CHA"
     },
     {
@@ -4870,6 +4921,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.DDR",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : DDR4 Access : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -4887,6 +4939,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.HIT",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Hits : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -5381,6 +5434,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.ISOC",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just ISOC : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200000000",
         "Unit": "CHA"
     },
     {
@@ -5389,6 +5443,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.LOCAL_TGT",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Local Targets : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x8000",
         "Unit": "CHA"
     },
     {
@@ -5424,6 +5479,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.MATCH_OPC",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Match the Opcode in b[29:19] of the extended umask field : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x20000",
         "Unit": "CHA"
     },
     {
@@ -5432,6 +5488,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.MISS",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just Misses : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
@@ -5440,6 +5497,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.MMCFG",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : MMCFG Access : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -5448,6 +5506,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.NEARMEM",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NearMem : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000000",
         "Unit": "CHA"
     },
     {
@@ -5456,6 +5515,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.NONCOH",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NonCoherent : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x100000000",
         "Unit": "CHA"
     },
     {
@@ -5464,6 +5524,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.NOT_NEARMEM",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Just NotNearMem : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x80000000",
         "Unit": "CHA"
     },
     {
@@ -5472,6 +5533,7 @@
         "EventName": "UNC_CHA_TOR_OCCUPANCY.PREMORPH_OPC",
         "PerPkg": "1",
         "PublicDescription": "TOR Occupancy : Match the PreMorphed Opcode in b[29:19] of the extended umask field : For each cycle, this event accumulates the number of valid entries in the TOR that match qualifications specified by the subevent.     Does not include addressless requests such as locks and interrupts.",
+        "UMask": "0x40000",
         "Unit": "CHA"
     },
     {
@@ -6947,6 +7009,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC10",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC10 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 10 only.",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -6955,6 +7018,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC11",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC11 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 11 only.",
+        "UMask": "0x800",
         "Unit": "CHA"
     },
     {
@@ -6963,6 +7027,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC12",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC12 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 12 only.",
+        "UMask": "0x1000",
         "Unit": "CHA"
     },
     {
@@ -6971,6 +7036,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC13",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC13 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 13 only.",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -7033,6 +7099,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC8",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC8 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 8 only.",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -7041,6 +7108,7 @@
         "EventName": "UNC_CHA_WRITE_NO_CREDITS.MC9",
         "PerPkg": "1",
         "PublicDescription": "CHA iMC CHNx WRITE Credits Empty : MC9 : Counts the number of times when there are no credits available for sending WRITEs from the CHA into the iMC.  In order to send WRITEs into the memory controller, the HA must first acquire a credit for the iMC's BL Ingress queue. : Filter for memory controller 9 only.",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
index 7e2895f7fe3d4..f445783382970 100644
--- a/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/snowridgex/uncore-interconnect.json
@@ -1802,6 +1802,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.CH0_FROM_TGR",
         "PerPkg": "1",
+        "UMask": "0x500",
         "Unit": "M2M"
     },
     {
@@ -1825,6 +1826,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.CH0_NI_MISS",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "M2M"
     },
     {
@@ -1856,6 +1858,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.CH1_FROM_TGR",
         "PerPkg": "1",
+        "UMask": "0x900",
         "Unit": "M2M"
     },
     {
@@ -1879,6 +1882,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.CH1_NI_MISS",
         "PerPkg": "1",
+        "UMask": "0xc00",
         "Unit": "M2M"
     },
     {
@@ -1902,6 +1906,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.FROM_TGR",
         "PerPkg": "1",
+        "UMask": "0x1d00",
         "Unit": "M2M"
     },
     {
@@ -1925,6 +1930,7 @@
         "EventCode": "0x38",
         "EventName": "UNC_M2M_IMC_WRITES.NI_MISS",
         "PerPkg": "1",
+        "UMask": "0x1c00",
         "Unit": "M2M"
     },
     {
@@ -2303,6 +2309,7 @@
         "EventCode": "0x70",
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH0.RPQ_PROXY",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "M2M"
     },
     {
@@ -2326,6 +2333,7 @@
         "EventCode": "0x70",
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH0.XPT_THRESH",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "M2M"
     },
     {
@@ -2381,6 +2389,7 @@
         "EventCode": "0x71",
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH1.RPQ_PROXY",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "M2M"
     },
     {
@@ -2404,6 +2413,7 @@
         "EventCode": "0x71",
         "EventName": "UNC_M2M_PREFCAM_DROP_REASONS_CH1.XPT_THRESH",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "M2M"
     },
     {
-- 
2.53.0



