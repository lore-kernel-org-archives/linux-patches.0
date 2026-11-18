Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017706;
	b=IvyN/xULHuQJ4NbQmYsl+xqMP2IRfI560+i0FYOEm8VOVkTja7VGfb0cCsqVbM++/nRK
	 2RFf0Jldy/KiEQgjiYc/XTmCnKa7c7UmLbdnQD7YxfPHGH2GD8IKoAQKLTuHAA9pNPv9r
	 EqGc7ChXmqCKWRXZpeBmPG/fVOu9wXSBcUzjp/IIT3IzHax5YbKqYEol0yLKbQeKl57+/
	 gLtYOoAfWxb5oi1eQ1fl7oWFSWOMUQ7FRYzWYUxa8F/3x0zdG8EuKrVo5SPKDVk+GxrQp
	 UjoM4H1Sg4Hj+5C23ofJ6zAVAVaBe+Qvz15RnaJsGVmYGu1/roRiWR3uOx8n3SkKQ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErrxqWxTdfoiHce9SIkjTUAhC6Lft6UhKMbV0bZmoqY=;
	b=TLCWyLoWvsj1v0eoIMA5o13Y2f7kOBIDssdnzdlDs70DFbhAI/QbEkfoamXSGwtZUXje
	 0crLCr3aEeD4crYhQFH8gfLbBbzLYUlZ5klKT7WByrJsiXzJCXpQS41XNUpWhRCUb5PSW
	 R8ybOiql9vPECOQUmnmn4fH/g4kwYC5dCzvmXvBqPF+qFN/mwE+mF6ZcMa2dUoFE5HGA/
	 pVGwGhmEg/YqPQSpwG4EEEbNpX8OAc4mj9xB4Ki+2+pRlWfwnX61x30mVApe0FF3BOZ8T
	 tXdl7LRoyqm9AEnSSB3dwa52+4+Ky9jP3vvw789J1SEkFVFDwSxjAwUHaGPRMkHroZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUOOtmMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334A9606A320;
	Wed, 18 Nov 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUOOtmMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D5B1F000C4;
	Wed, 18 Nov 2026 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017706;
	bh=ErrxqWxTdfoiHce9SIkjTUAhC6Lft6UhKMbV0bZmoqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUOOtmMjvjXpgsEPxq5daRec6pJcv6/1v1hxH4I7yiyNBZa+pvQkUGQrYZwm5QPde
	 QXaBEa/kGedgG0/CI0cc26OMHEpw7cnYRKgme3OZxEacnDaBk787sDrwzEAXQGwkp6
	 1CY5NjX46HrFHJO+u0cm7DcEDqMQkHukclCycU+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0980/2651] perf vendor events intel: Fix lunarlake umask encoding.
Date: Wed, 18 Nov 2026 15:37:00 +0100
Message-ID: <20261118150323.182711904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f2844acc9dfc330b6e4b4731c18ddafe10b2f99c ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 23878069de30 ("perf vendor events: Update/add Lunarlake events/metrics")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/x86/lunarlake/cache.json    | 3 +++
 tools/perf/pmu-events/arch/x86/lunarlake/pipeline.json | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/lunarlake/cache.json b/tools/perf/pmu-events/arch/x86/lunarlake/cache.json
index 5b350233a5e18..c77040e87639f 100644
--- a/tools/perf/pmu-events/arch/x86/lunarlake/cache.json
+++ b/tools/perf/pmu-events/arch/x86/lunarlake/cache.json
@@ -848,6 +848,7 @@
         "EventName": "MEM_LOAD_L3_MISS_RETIRED.MEMSIDE_CACHE",
         "PublicDescription": "Retired load instructions which data source is memory side cache. Available PDIST counters: 0,1",
         "SampleAfterValue": "100007",
+        "UMask": "0x100",
         "Unit": "cpu_core"
     },
     {
@@ -901,6 +902,7 @@
         "EventName": "MEM_LOAD_RETIRED.L1_HIT_L1",
         "PublicDescription": "Counts retired load instructions with at least one uop that hit in the Level 1 of the L1 data cache. Available PDIST counters: 0,1",
         "SampleAfterValue": "1000003",
+        "UMask": "0x100",
         "Unit": "cpu_core"
     },
     {
@@ -1093,6 +1095,7 @@
         "EventCode": "0x44",
         "EventName": "MEM_STORE_RETIRED.MEMSIDE_CACHE",
         "SampleAfterValue": "100021",
+        "UMask": "0x400",
         "Unit": "cpu_core"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/lunarlake/pipeline.json b/tools/perf/pmu-events/arch/x86/lunarlake/pipeline.json
index 8be3ea336bb8a..5d8bd972d4633 100644
--- a/tools/perf/pmu-events/arch/x86/lunarlake/pipeline.json
+++ b/tools/perf/pmu-events/arch/x86/lunarlake/pipeline.json
@@ -190,6 +190,7 @@
         "EventName": "BR_INST_RETIRED.COND_TAKEN_FWD",
         "PublicDescription": "Counts taken forward conditional branch instructions retired. Available PDIST counters: 0,1",
         "SampleAfterValue": "400009",
+        "UMask": "0x100",
         "Unit": "cpu_core"
     },
     {
@@ -474,6 +475,7 @@
         "EventName": "BR_MISP_RETIRED.COND_TAKEN_FWD",
         "PublicDescription": "Counts taken forward conditional mispredicted branch instructions retired. Available PDIST counters: 0,1",
         "SampleAfterValue": "400009",
+        "UMask": "0x100",
         "Unit": "cpu_core"
     },
     {
-- 
2.53.0



