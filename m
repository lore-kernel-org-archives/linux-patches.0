Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017709;
	b=SQoBIIp0EAaNLGOQklnSvf94kHn8EWsE6uMwbXaRl/ipSl6Tqtt4XvIVFc4pwdj2jI1s
	 19fhQU6AC4KUuH2ilewhQWerCr7evtiY0WHvbOJ1b+K9uA7h9MhMA4mqGGwNd50L+/CK8
	 k6tcTDgD/WaTLhsTlFbQH5LSK6VC/5MlKNW/CxXhBsP9lQHAPFXKpFHL04BymophMiw/q
	 CNWNQTEm5fGoBijIhLUXv6EGlzcVMZ904HWIngOckNotadNK1VHq/UQxql0yDjiOxdcGQ
	 wBA9jq2cFfPTcmzDP+C+7tZGhZrxNRULaX+rlaC0HxK0Dl+q8A2OyPdXvvMHt4mkadw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVEMIZfSl3w9AivDjxgSoxJpinINDY8vcMHvXsXgpt0=;
	b=JRijXVrKRelAwQ+9bQukWFqewjMAF9zOdJMNTuVaGypn63/xLQM39ldSIOFOyXUOAYhO
	 zsAprtHWqZRQRyNC+y6Qd+kYRXOFJ1zEl47RhKx5e21KPWBRNjBsaV8je17Z3+1IQXJWh
	 Jx27sX/eFKPC7WcLNGiB1nooRjwJ8Qy2QbCU3DbtsnYEZHmSkccZDnJQAY1rCJm2S+wKF
	 rmBMYof2vNmjWHmEdt7Zmc7jsMvi+RCnwTjKtlcEzQ8rkdSUK/hXhjhNUA1LZzMXJoyh2
	 G53TEk5jdc2vGGcDynGMrvUhrN4Uzi6jJjSi6CisMk9Gb5Jd3sSasEfYkfJL/Ipkizg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7KZNhUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DD606A32A;
	Wed, 18 Nov 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7KZNhUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F53B1F000C4;
	Wed, 18 Nov 2026 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017708;
	bh=rVEMIZfSl3w9AivDjxgSoxJpinINDY8vcMHvXsXgpt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7KZNhUApPZc5bmZs1dTrctkiF1opyMGRfIj6D5VurALZCUNp8zBVXyRdzS7cvLTl
	 uGQobLOQERnC2KnbBwTe94zjtAzNMGN33XDALHIwxvYwksTK5TlHts1Z1+GuIx85Xp
	 FThKdc1e7LQbf+le7JTVOKTNBaygWrpl261fgbRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0981/2651] perf vendor events intel: Fix sierraforest umask encoding.
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118150323.218235540@linuxfoundation.org>
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
index 35b1763b00208..0b95faa5e4698 100644
--- a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
@@ -701,6 +701,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.DIRBACKED_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -730,6 +731,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.INCLUSIVE_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -748,6 +750,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.UPDATE_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -767,6 +770,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -776,6 +780,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_SHARED",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json
index 1f6e0970141a1..7fa6def25379a 100644
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



