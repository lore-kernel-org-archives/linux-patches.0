Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040377;
	b=rhLiMJ4UxOdEFRYFbMhhG1L2jRnWAEHbMWeWnNqEnqS3OFLmCLDpG/k3y+SEsd7styjO
	 k6rzSzUcxW+9Cj46imoxVBnqG1VlS+SYZhXuAywwgEL9OV1s/nComo2NCbjTlX+X0N/s0
	 v22zphU/aVGQy/sMl04ifODSTwWHmZLmR1LJTvHHCaPVy4mqNY++nvyeTdV/1vDxDWDEf
	 /44rnFbBcpnm11Uc3n8M9RAp29B0/r5BAr+yISyTEolEONvHkPx3L61JMADVsZHCz7JHX
	 JXZg6r4J4z88H8uS56fb9YqA9bCufYs+k9uS+/OlzraR4hL52iQ5u8A8Kq6ii0rSBKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibc+tlkHU54hRW0gP9yq0YowmK6mFJupfU4Ac8nrzYI=;
	b=2m06GydO3c4mnCGaloO/jjZJM0Wx3zAIVC9hyflFeybr6grYwYMldKv+Y2v6f2W7GfAX
	 YA9gdDaa4AeN1KRwD8Ap4PGWsswtmm7N2Qcw40uS0qJfh57Mm6b0m87GhRC1Hsr+Hfqq1
	 G/vorukag6bDxQq0kTVRvCXs2lWULEC3c36P8qAUoMgFr0tzFZIKeRVW4pLYqM8xg5ikF
	 x0q+H+5MmkL70V1rvMlVa22VIpG3WY41YNXY4p4CrX8OXb8ZfWq96cEBFiaG5XLBnif7r
	 rRtG/G5dU99r++hfU2P6dxg4tySD/qExzmqPnv3pZ5n2lvroOyf+7lu4mkSnT3LoG0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTK5pJvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA2606A31C;
	Wed, 18 Nov 2026 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTK5pJvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6BB1F000C5;
	Wed, 18 Nov 2026 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040377;
	bh=ibc+tlkHU54hRW0gP9yq0YowmK6mFJupfU4Ac8nrzYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTK5pJvJWKWaYx79gwWMzDf/x2wLCRK3aGxwWmnGdRac9Tm5p4J2vSxvmKbPoDYm8
	 TePB+yExq1F0Z2vmcOe6DOU1jwFSFsnihBjhkzJWC05bKTOvwSLSoG/p0NY7RkKfAS
	 halDVl4gU+ZrwH1brV3QJ49kdHKg+HGR+v63YGHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2434/3318] perf vendor events intel: Fix skylakex umask encoding.
Date: Wed, 18 Nov 2026 15:50:56 +0100
Message-ID: <20261118150434.478437659@linuxfoundation.org>
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

[ Upstream commit f37e7dfbd34c4e48d2bea4c5e0e64c398671e87b ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 748d5cf71948 ("perf vendor events intel: Fix uncore topics for skylakex")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pmu-events/arch/x86/skylakex/uncore-interconnect.json   | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
index 3eece8a728b56..2175db06ab554 100644
--- a/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
@@ -10998,6 +10998,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DATA_HDR",
         "PerPkg": "1",
+        "UMask": "0x800",
         "Unit": "UPI"
     },
     {
@@ -11006,6 +11007,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DUAL_SLOT_HDR",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "UPI"
     },
     {
@@ -11014,6 +11016,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.LOC",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "UPI"
     },
     {
@@ -11040,6 +11043,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.NON_DATA_HDR",
         "PerPkg": "1",
+        "UMask": "0x1000",
         "Unit": "UPI"
     },
     {
@@ -11048,6 +11052,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.REM",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "UPI"
     },
     {
@@ -11083,6 +11088,7 @@
         "EventCode": "0x4",
         "EventName": "UNC_UPI_TxL_HDR_MATCH.SGL_SLOT_HDR",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "UPI"
     },
     {
-- 
2.53.0



