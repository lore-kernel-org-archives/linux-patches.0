Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030328;
	b=eWvfzDlTp+o8FJF+VDGeu9zQYdXKASL5UlsNgqDoxa6ZCNSveTQdwLnpPvoMnh5AbmDw
	 nWB+cFFEA9fFSType7YTrjSqu6WW+96TprrqzUi9QdosLHcbuvtQksnqO1Up1pljhCADq
	 c+gUnFkFskc5tX7jOUsbf6l5P6fdwcj0mADHr/nbPVz2huUrVXCPBVXlBw3911W+puwYn
	 dqa9aII8bhk9PhiUR5sXHF8i4apUa+D/hJtv6nkb+RW6TEMXQXBSy3JJyuiP1Qp3s3zse
	 Zgw4xcTWTizlKoiIlInJtcF7cDaR1dwYx3bm+CYoajYkXkEPq6v6fQOOW55LSEx2oVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I9EYmmthRgORZ7iUeU82zVWLgUOsMySflXlLjk166F4=;
	b=pjCzOyOtMlPpxzH4Vdpqkh93/TEqirCaAmuKCyLGEXDJ4282j5ERiMD9y/F0VaLq1TZC
	 o/WRcRGJykXt5JDBHDmzi9LMXN0bkd/XUGnhA3s+SnZOgVm8YZF6hj/EQlv2dH0vGNnVM
	 u0NPjs+L6pemi9aM9t9uNTioQ3jtTLqvQrkuU2IVJI2dFMmrxj8rrjjKV2jd+wOtr+NEc
	 bwAaiUtED4cMPnzpSkkai+EAeCq8ZmX+XOVXM1BIQL3mXNdsAQKxVh8fFR6hLawdMLl+f
	 HuFPRTDpL97jhOOgiInLfH1PHSFQKg6XEJIspf4q8/dERiqf2HLi+U/VT2Ncdo0EF7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfLRMg5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3B606A333;
	Wed, 18 Nov 2026 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfLRMg5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483B21F000C7;
	Wed, 18 Nov 2026 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030327;
	bh=I9EYmmthRgORZ7iUeU82zVWLgUOsMySflXlLjk166F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfLRMg5Hhtl//Vxq2LTF+AMC7IvZTlkVBnxSBFt0nSLrf8jUNXBfyN8Fhq2WdlWxX
	 Ijgc/z60GVv+A9U74CIdIVUUOEVrEMssEsN4X1Hbjs3lkH87p2CR4q8L7GhsSU9r6A
	 RQuZqi7N6gXUFf9Fa+rnBbNsTua7VDD/l1Q8AGYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0665/1756] perf vendor events intel: Fix skylakex umask encoding.
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150035.587584654@linuxfoundation.org>
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
index 216a00237cd1b..59fdd7fa7ba09 100644
--- a/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
@@ -13462,6 +13462,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DATA_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x800",
         "Unit": "UPI"
     },
     {
@@ -13472,6 +13473,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DUAL_SLOT_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "UPI"
     },
     {
@@ -13482,6 +13484,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.LOC",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "UPI"
     },
     {
@@ -13514,6 +13517,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.NON_DATA_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x1000",
         "Unit": "UPI"
     },
     {
@@ -13524,6 +13528,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.REM",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "UPI"
     },
     {
@@ -13567,6 +13572,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.SGL_SLOT_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "UPI"
     },
     {
-- 
2.53.0



