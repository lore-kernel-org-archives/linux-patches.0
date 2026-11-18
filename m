Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024744;
	b=4Dih/w3qIVAG9f3BnY5GECF6UFnkaXLfxnKX+jglgeE258eCTRV4KxuPse8BwdRLJubx
	 8l6dveXoAswmgfiD0mVlxHTTr4dVONJ5IkAFnAX3SK/HqD30clRZhKW4DNrVt6HVwpgfn
	 RDzwe5vF4A+Ts3LrWTkXFM55u99Fh+w6X3StxuGjV1s36UoNF8h8jEOerTNUiQjBuozfh
	 doNb3VM/aD69d5bBWcdNfQj/4m5MO2+py2UJiPZDCFHM3IlXwwAbcc/QAN6JF6WwLP+5R
	 OrmUDQLFw9zdRmL31YJBzQ2Y2soTiBDpLkne/OngbdPsmowhETBpU/6NgNLSSz7YBbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxHuCkFYlV33181R5BTAiiI9VxwK+d0c4EDqKu1yD2M=;
	b=xRtba/LhBowRXWlFMsFfWaPA7MEoigCsHXvMgG3jGyEoFkxVxFqsyEn25AUIQ7lpOCKc
	 ip1JqOMstFxI0A+zCHhUiDroOnHUYmB1PeJIUnBotA7PncBlaaJFBbLEZlSc9hsr3S2I2
	 Ug0Zjosv40+lRKX7Q7cG7D3VLH3xkbNG6MJ7Um8eRrd9C5IOsIVIvCd7H168D3ySm1Nbq
	 QkDlpdCUin770LUtpZfK+iaL3SjA+IWRO6gPNdSL6ROJddf4wvY6g6X/FQGzUikxLVE3F
	 IaX/mAE9IYjsdSdjStdZBHrb1MvpvYV8338nDmf3MQrNmwRl7IRIqgr9vSCiCG90Sqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucYuaDft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5E7606A331;
	Wed, 18 Nov 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucYuaDft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841E71F000C5;
	Wed, 18 Nov 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024744;
	bh=UxHuCkFYlV33181R5BTAiiI9VxwK+d0c4EDqKu1yD2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucYuaDftyVq6dvcWGPx1eIRUrMFt79NSszP45ibNslyLSu5o77BzRrS0yMkYWBFYs
	 bme28UUJLTVDjlswnUymld2efWmDwmUyVJQ1Z2jjppSIvZRLu2/+8OHN+zVC0wd82C
	 kAli+UKzzoJpSfw46ggNoz0ygdLR7TMFbs9uFwBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0835/2151] perf vendor events intel: Fix sierraforest umask encoding.
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118150152.623642449@linuxfoundation.org>
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

[ Upstream commit a86bd28b6e71101a1b11b7768f9bbc648b7b14d3 ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 9626368d429a ("perf vendor events intel: Update sierraforst events to v1.01")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/pmu-events/arch/x86/sierraforest/uncore-cache.json  | 5 +++++
 .../arch/x86/sierraforest/uncore-interconnect.json           | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
index 3d1fb5f0417ec..e3946d897cb11 100644
--- a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
@@ -692,6 +692,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.DIRBACKED_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -721,6 +722,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.INCLUSIVE_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -739,6 +741,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.UPDATE_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -758,6 +761,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -767,6 +771,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_SHARED",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json
index 251e5d20fefec..ce49487324b36 100644
--- a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json
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



