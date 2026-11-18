Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019705;
	b=iO5OTJo6siR9QaKZWxFdMFF9SHuYqjnMy7X3214aJefVgNT6MmcxBYPQzaXMF42pm/iy
	 BPtprduwjrT2UmXMTLq5PLDzVUFGvg128idCASB53VpFqUbAxZY3QSlybGr/5BXtivhqe
	 2YFGsiEnq6mEnIMWxwYo81MiO8p0IssGtLzVudoGrbONxwSE2qzhZWlxwNLSw5goi5yhe
	 AjFEGNdhOc5snFfanr7/cZYRBue8Lc4lczBlRfp4AcC5uwhlrsIPTBDTd/6SNXWmld0hI
	 uAzbNW5BJqDVrAyCH+Y36XZHQXLvo2C6Sr6wm2WJQ2qNBcxQfhji4bqJzGJstfL6GzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eorQak1xQ2+NJbAOHGKnLiMOuJMTaGShMvvmjUkGnY4=;
	b=OqBIKY4VWjeaXLqZwBTJU1Fs0A/aNMU14XSU1xHGZHgV7bO+sQ7bg3gitNFw0zMnUcxS
	 81ZO/niXik0x+X+XIVSQk4NeH9vK4DpoKRlENp0WOUSfJfPhA9te8EQXcU8oGcBi9ZFaB
	 UW/NanNQdEcYNLEyXNf7m3TksaosOKGtpclCCj84b6Easdv0dvVkeyeZlPWYlhMv1Ry9Q
	 a31S+jr1OxPwAochxhzvi81TaI9SzYE1ILIuIEzSJBoOeEh7K+10WP6soZ76tSIGU3GBp
	 tOGTqM/ZlISMwM3Q1LcHIUHjrfvwS+/Z4RJcjU9EuBmeKvoGRZWbpwLCOPfPYdkLNBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbBmouzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341A606A338;
	Wed, 18 Nov 2026 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbBmouzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8731F000C4;
	Wed, 18 Nov 2026 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019705;
	bh=eorQak1xQ2+NJbAOHGKnLiMOuJMTaGShMvvmjUkGnY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbBmouzScqhMRI8EJ6gh28dhYMYbZayWZEFPdjmDtz9pMYUooqOZkkk9EgoNjLlDj
	 dy0xblv6In8+YSdyBem2ePohlzjFGyXBN2l6DY//AZvUv3xmOfqq5VtnORbFjejwUm
	 3hd6re5qSx+0muooVVMF/Lq/v3+k2B3eTeEPtyqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1690/2651] platform/x86/intel/pmc: Fix stale NVL PCD-S S0ix_LPM telemetry constants
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118150348.510591300@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Pardee <xi.pardee@linux.intel.com>

[ Upstream commit 2ac40383e9b70bae67ff4cdbb2108c006bf1b5e5 ]

The Nova Lake PCD-S S0ix_LPM telemetry layout changed. The PCD-S telemetry
GUID was changed to reflect the layout change, per the client GUID
revision rule.

nvl_pcds_d3_status_1_map[] was correctly updated, but two companion
constants were never updated to match:

 1. NVL_PCDS_NUM_S0IX_BLOCKER (core.h) is 71 instead of the actual
    number of blk == 1 entries across nvl_pcds_blk_maps.

 2. PCDS_LPM_REQ_GUID (nvl.c) is still 0x01091102. It was never
    bumped to 0x01091103 to reflect the S0ix_LPM telemetry metadata
    layout change.

Both constants describe the same S0ix_LPM/blocker telemetry region
for PCD-S, so fix them together in one change.

Fixes: 41354f4c8a79 ("platform/x86/intel/pmc: Add Nova Lake support to intel_pmc_core driver")
Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20260919051830.565240-1-xi.pardee@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.h | 2 +-
 drivers/platform/x86/intel/pmc/nvl.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index b4c7399f8369d..e55164e5807fd 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -323,7 +323,7 @@ enum ppfear_regs {
 #define NVL_LPM_LIVE_STATUS_OFFSET		0x1760
 #define NVL_LPM_NUM_MAPS			15
 #define NVL_PCDH_NUM_S0IX_BLOCKER		107
-#define NVL_PCDS_NUM_S0IX_BLOCKER		71
+#define NVL_PCDS_NUM_S0IX_BLOCKER		70
 #define NVL_PCHS_NUM_S0IX_BLOCKER		54
 #define NVL_PCDS_PMC_LTR_RESERVED		0x1bac
 #define NVL_PCDH_BLK_REQ_OFFSET			53
diff --git a/drivers/platform/x86/intel/pmc/nvl.c b/drivers/platform/x86/intel/pmc/nvl.c
index 8dabf2511dd9d..1ed02332dbfce 100644
--- a/drivers/platform/x86/intel/pmc/nvl.c
+++ b/drivers/platform/x86/intel/pmc/nvl.c
@@ -14,7 +14,7 @@
 /* PMC SSRAM PMT Telemetry GUIDS */
 #define PCDH_LPM_REQ_GUID 0x01093101
 #define PCHS_LPM_REQ_GUID 0x01092101
-#define PCDS_LPM_REQ_GUID 0x01091102
+#define PCDS_LPM_REQ_GUID 0x01091103
 
 /*
  * Die Mapping to Product.
-- 
2.53.0



