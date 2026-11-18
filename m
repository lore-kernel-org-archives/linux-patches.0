Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017703;
	b=NXHXoXrNVKTLe+gxIcLsyLj7nH8OKLgNQwbYrZpjxYCVN5tHeIw9ZpU3KEkl26cl0aSI
	 XNuN2cmswp45H+vAMxZmOlehfUCF17b+VMvBfZ8V9Xx6Q3puME7kK4khbtZaSvK7k0hSl
	 H8BEfVDlNkO4gLBiiu5HbdLm06VW/yFb1lJ+3gV9D/tyuDe8D8ZtT+uqmMJq/oWBQj14f
	 52KB9TeJ5X3GdJFwoAL0JFVNMlSlOgEeGhwPMmNfjhUDg6bv5IPZgSeje5QF+PLPm4c9L
	 swxRF2UoDLgi1h88XoC9Eehmd5+w4NM1oB7pCqQVGm14+4X3Ka87qHM30YXHh8SBWzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6KKhW+jFqxbyVwhLfHTKJh96KVMBfdx0ZXAGwblUkO8=;
	b=NH4I9rqbPPoRGxRX2qAon7cSSB1Q/3zjxOXbmiZ4XKBzBGuTmy5Fym+y0yPTWX8Nqvqz
	 lLkoG5omUDUqD5lAc6BvW6hPivUt1f5sHWPPRyRDte5BMslcEzpdUPezpEH/zqVdVl9rj
	 7dkg9iiELZML//CBZ76eiAe7HEqCVzj+v+v/aDLMByzYdCc2chtwBrlkmZ5K+iNACbxhz
	 BAFb39VZ1CVuLBNeQ1se/Tub8vCSrJa64r/FXfsFw+9TvD4wmqsJFlW2VoEqJA/zmQGXO
	 5+n9/iagHVZYXWQ003NrQEkte12G9TnYHNfEFR3mpqq1SHOAmjU1RoVqjye1NrjojGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUGCE51h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593EE60A260B;
	Wed, 18 Nov 2026 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUGCE51h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03431F000C8;
	Wed, 18 Nov 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017703;
	bh=6KKhW+jFqxbyVwhLfHTKJh96KVMBfdx0ZXAGwblUkO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUGCE51htK7K5DruKcwx32Vxce0cJvkKiMMJoqDzLUMSC/fL9Dsv2Jj3AwMRGXJ+x
	 rQnvlyyKm5395cyxbmf1Oug4bgh4owGzZ91vzp93oBAadqqY1w4uE3cPnJyT+Pshwk
	 5WOBKlV5A9otmVi+3JQQSpJFxPj0DVbSoZveD3Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0979/2651] perf vendor events intel: Fix clearwaterforest umask encoding.
Date: Wed, 18 Nov 2026 15:36:59 +0100
Message-ID: <20261118150323.145847556@linuxfoundation.org>
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

[ Upstream commit b26183fade24530141a2c7a22ca47e1ab0f7989e ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 1a5c515eae7c ("perf vendor events intel: Update clearwaterforest events and metrics from 1.00 to 1.02")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/pmu-events/arch/x86/clearwaterforest/pipeline.json  | 3 ++-
 .../pmu-events/arch/x86/clearwaterforest/uncore-cache.json   | 5 +++++
 .../arch/x86/clearwaterforest/uncore-interconnect.json       | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/x86/clearwaterforest/pipeline.json b/tools/perf/pmu-events/arch/x86/clearwaterforest/pipeline.json
index f73686174af90..6cea91277d5ce 100644
--- a/tools/perf/pmu-events/arch/x86/clearwaterforest/pipeline.json
+++ b/tools/perf/pmu-events/arch/x86/clearwaterforest/pipeline.json
@@ -934,6 +934,7 @@
         "Counter": "0,1,2,3,4,5,6,7",
         "EventCode": "0xc2",
         "EventName": "UOPS_RETIRED.X87",
-        "SampleAfterValue": "1000003"
+        "SampleAfterValue": "1000003",
+        "UMask": "0x100"
     }
 ]
diff --git a/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-cache.json b/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-cache.json
index 278837f2068a5..e065236e95255 100644
--- a/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-cache.json
@@ -700,6 +700,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.DIRBACKED_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -729,6 +730,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.INCLUSIVE_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -747,6 +749,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.UPDATE_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -766,6 +769,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -775,6 +779,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_SHARED",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-interconnect.json
index 1f6e0970141a1..7fa6def25379a 100644
--- a/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/clearwaterforest/uncore-interconnect.json
@@ -515,6 +515,7 @@
         "EventName": "UNC_B2CMI_IMC_WRITES.NI",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x300",
         "Unit": "B2CMI"
     },
     {
@@ -524,6 +525,7 @@
         "EventName": "UNC_B2CMI_IMC_WRITES.NI_MISS",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x500",
         "Unit": "B2CMI"
     },
     {
-- 
2.53.0



