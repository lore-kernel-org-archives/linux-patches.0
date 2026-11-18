Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017711;
	b=TTvM3ICCAirGHMIXg52LTpqPtas3eE+CgWjNSb1yiQ2dOnDkNKK8COeNRk6PbGIYRh/0
	 jRHr6xU17C+vdGNTHjGJsxXQkdUSqqz/0EmHsFr1Npetbsxse3w/KInBzun9/O8kt3CSH
	 1qhuz/KRaRqaelp2F31dwdebxCTdNIzTp+cceAogomZLr+gYVyrXgBbvef6D4dnI4wzof
	 ntkv3Cusu6fuhdlEt8THHocNuELUyEEbQKfdoK42vaVMo1jVG3YBApzFfbWCwGYZisNj1
	 BMpD8tDWsBk6zpMIcn6vXZWOIO6/pNE7MKlkCxpgPvhR5Y00Mtee1ZsjUCSUsKzQF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHp2Crwgpa5gDrsCiFyhWTjQf6/2pomcfJ0LuWkbHWA=;
	b=zeeaJsDQ1NLpP0s0tPNlswr0i3y4HV+b4axaTvd42v/n98WndXZQ+u65x+w6mfTVAi0j
	 EeJ10L1kCvFm+nM7Ru3Ce+5USOhWC8ZpGIfG8i0bQ1xp40gybergp5H9T9GwTOPVO+Y+5
	 9QPyZInlVeZdzc6AfEVSCZRtkwg1QTSfylXw4QlgSLYypgEF6arEltqyM2sWH4QZOhDmQ
	 qv98KrknYFnELG3/g/YQzOHUh6Q6o08VPHwVsUXi+Il/5GT2ID0lYJZWFvQNg3hgokHON
	 jUmcb6MktBUShmvUcd7SmJfpjh795lQiN9pMHBcnP2jhHIAr9n3Om71tH4jdIRmmp2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpUiKDnY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CA1606A32F;
	Wed, 18 Nov 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpUiKDnY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B921F000C8;
	Wed, 18 Nov 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017711;
	bh=MHp2Crwgpa5gDrsCiFyhWTjQf6/2pomcfJ0LuWkbHWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpUiKDnYAgCIX1jAcsxU7hHg6B/FAC+psmv1HCQu104yVjB6r/v09fdPzHOSi4Em9
	 pa25eURDpRqWkpbMDq1bJZM/do+g4n0M6fwZA1tI+CPzNFDyT9aIbY8MeTB4eR5+qr
	 q3+sRxUekuvsLlkbnrsed3yCRO0H8M11ah81QYEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0982/2651] perf vendor events intel: Fix skylakex umask encoding.
Date: Wed, 18 Nov 2026 15:37:02 +0100
Message-ID: <20261118150323.253407835@linuxfoundation.org>
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
index eef801c68bd25..08311bdb2b203 100644
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



