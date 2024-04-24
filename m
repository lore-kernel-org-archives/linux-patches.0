Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A04200107
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982547; cv=none; b=QAI0w92BHmDHO/esVDjcdtkLM/+ntHpYWGUQSReaBpTaTFp9GAVcIKcCyqBPF44ftGwNwaPWK7ATjgKQ+HtYcPjfPpbv6+jtHNvZplpx8mxUYQU0BunIWPpxDl8sBtc6oBh3SA9WO8VGei5Efpc2dt/g2ZlloIOqYb5l8JwE0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982547; c=relaxed/simple;
	bh=NHkS+PLB8tCqh4PRqBz9xJFe66d4//WHYse1TcAmK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZawVXtGei+07HfeaD3zcMvSRo0FhuYnHgL0BecbkLw9aWxEz9Kz3GjUtniYBT56Jhe1f2Ts5HQRQZDBQdPXSU/MWB3kPYOJNCOhc+f7pSwNs08UePxx+liW3iEN8+vKKEkSC24YMTfH2vWs7tSh51OqdxbxDKKBU/IjZ2nnaLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yp1suVgn; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yp1suVgn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982546; x=1745518546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHkS+PLB8tCqh4PRqBz9xJFe66d4//WHYse1TcAmK38=;
  b=Yp1suVgntERV4upX0WJikiosV/m1X9NJ6iwS/z8TScqYIAWJegI2/cND
   dX+rRLOSrIto7p30n/9ZtAT7brX7nzNo/pOIB7UHeaa/8UkpmiRlT94yy
   9ga4qjmWOhMN3NCwUua+PZBTKZ+GjEBDh/xJZYm+aFL+T6g3AUjnswyd6
   k3G8l1APtA8bbp+alC0qtmeyBnTnFb+FBdSKh6whAxwaSse6kX1GoJar2
   CLY6Ypmr/jhdZC1YLGCaZ9Hdkt8FVN/7NMJcY9bvwPbJ7izacjP+VsdsI
   tWG6H6tXpNNi54k7P9iGY5EatKRt/rrN3rFrl+xyMSco2MeadH1HKuC8M
   Q==;
X-CSE-ConnectionGUID: p0mpHuNxQFe5FeJULray8A==
X-CSE-MsgGUID: 3RFidkJTTmS4fSmD/r5v3A==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503731"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503731"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:45 -0700
X-CSE-ConnectionGUID: 1cjMMjg4Rli3jg+Vz0SoNA==
X-CSE-MsgGUID: K0SEcFSdQnaSOJ0+wWee3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750355"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:45 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 66/71] platform/x86: p2sb: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:45 -0700
Message-ID: <20240424181545.42426-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/p2sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 3d66e1d4eb1f..8cfbf0bbd346 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -24,7 +24,7 @@
 #define SPI_DEVFN_GOLDMONT	PCI_DEVFN(13, 2)
 
 static const struct x86_cpu_id p2sb_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
 	{}
 };
 
-- 
2.44.0

