Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030322;
	b=lFDvS1FWobr8UsIW9ABob4I5jl+fpmPexmT9dM4L/bRkS3LNagiOsJqBr+1saaABPO+m
	 +mD3QQVDYiGADn0Z1hEL5z6Bc9ehQn7eRZ0SR+5cf0aN4wAhgQZwyx3ilna/ZdaWXU9V3
	 RFEH19Ic4BemUlh+j7nk8RV1zM8Dx+cq9Wu2VkgnLKuVckRlwkJK2brtMzgASxHhb+/UJ
	 VGaWKYhmuO7fvZbbVvmMvKt2V1L5IZgBJUyZylzpg0DNwTObWw4M5dkh9TcOlAP2YXR/K
	 g0TY8mDtzGmYnjTYUs81nJKJ1ucE8J0xxehW0jqHfBqXtk1fIWHuprRRTdXgpjYUBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zyTM0DqMlwZ++1BGFLSj5VrQ3oqvQuTkg67wrP2BVD4=;
	b=GSJr711sNq+HdzGn2OntOZfi4Z3XtJsPRsZ2dCtllgpem8rAZKrLD8lIt8FZVpZvVicx
	 ygK1FCcHDLWgnxfVVMeBdSy5eAB5dtOk4VCxOKoOidb5YGLLmSeWPYXSNbnQoW6w2sNdt
	 /LKY+1jpgkZcfy8XLWlIGTVa/1v02GuSALCno9vxWClujip5cr40ZM9NJTi8MVQWUwjAT
	 ZT6+mjpuMsx3OxL5R3XWKH3nHZ3r3ga8YbMv+GKNbTUdi2mOoLsQg6Maawaz2sBS7v0LK
	 WrQbx5HLCHI1iawycH+0r40TzFZWizT6m0dgf++Qv9aYHQBPAsWqB7hgeX9mbQE2l6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pExhrXuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A51606A334;
	Wed, 18 Nov 2026 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pExhrXuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB6A1F000C4;
	Wed, 18 Nov 2026 19:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030322;
	bh=zyTM0DqMlwZ++1BGFLSj5VrQ3oqvQuTkg67wrP2BVD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pExhrXuEsiIg1zrlN9+9KMr6IT+oqO7WCdx0pvFflJk4dwGPHecgccTVlzUu/jp6G
	 2BpYDWPfsHf2pyGRvI4U91KaFVbg7O86HBrUx8VL6Y3t9iuLv4RozDptjdG1tHMH/e
	 FesS5DuUbZxu7dYWEqsDIw3+dXLfgWmVpR4wECPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0664/1756] perf vendor events intel: Fix sierraforest umask encoding.
Date: Wed, 18 Nov 2026 15:46:31 +0100
Message-ID: <20261118150035.528124880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f37107373e3bf..981ae71e5c0f6 100644
--- a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
+++ b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-cache.json
@@ -682,6 +682,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.DIRBACKED_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "CHA"
     },
     {
@@ -711,6 +712,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.INCLUSIVE_ONLY",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "CHA"
     },
     {
@@ -729,6 +731,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.UPDATE_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x100",
         "Unit": "CHA"
     },
     {
@@ -748,6 +751,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_EXCLUSIVE",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "CHA"
     },
     {
@@ -757,6 +761,7 @@
         "EventName": "UNC_CHA_REMOTE_SF.VICTIM_SHARED",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "CHA"
     },
     {
diff --git a/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/sierraforest/uncore-interconnect.json
index 80440edac4319..67a1a7f79ffb6 100644
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



