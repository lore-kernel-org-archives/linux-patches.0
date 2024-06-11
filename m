Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856F28488
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 20:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718138903; cv=none; b=K88sIv7CHjY9YWQbE8JudXUL+UlyvQbKpQU8/971Dq8mgIAVFLJcaQzgsz5CCPZSq/rHPRHXh8w+3o5msD9zdMCWxmwRbbaRt5bF4dNIEDhbW46mbxF+jSSddTk1OLbCnjMQnxaBiVgZoMmMoY82s+0nrfWqz2eda1akA73a+8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718138903; c=relaxed/simple;
	bh=1/tqaIGvH2aIdc6qjr6EFO6xMzJH8Sqyn0+Hr1zgwww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=joCjhdTWeijlRzEQQXWWISUkxGvTUbL1vc3fFCsBhUOScXa1RmFN8ClQf1qKS8gUP5RS3ztbi7vqr6O1UeUbKvyIR5rOIN7A7EeX09JlDGsUtRxaxlG5JShVh6mJb71heEmNQZg1WtI783pve5Vs1kHET6CJWzj24PJ1rP5DW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLKY/h2K; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLKY/h2K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718138902; x=1749674902;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1/tqaIGvH2aIdc6qjr6EFO6xMzJH8Sqyn0+Hr1zgwww=;
  b=OLKY/h2K4+LunhzvahYq0xDmifdZ7PZ1f7wCMV8H98Sw8DwkUREK1stY
   gWpLScVoerzmR1vOWDMoyFEYVzA4Why3309qqM1vxzexHUM13xZuEyVIB
   aYLgNgh8lP/FmP9cmT4bXfRQrBOTuBy1Ao01JXS40X8L6/VGLaJrofaH4
   Y+0FViWf82zkU5Y+Y3fWZrWW4asG05qRy8+voA8Y8ZAUDSUnKo32jrPs+
   eFlzs9UUvpKnoY91QA8tCkBxaIpFQoN5bBGkMyXTxZ6qQM17NnW5QRmSe
   KtA2ymsj4pLx1q6RbtDXMD1Wh8zxwRK/4Qmvcy0/D4zYwjYUVNeVfCZmw
   g==;
X-CSE-ConnectionGUID: BwEllGUxQXGhIC4rgLbHug==
X-CSE-MsgGUID: Do61WwZmR/mPb/RvufFtMw==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="25452976"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="25452976"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 13:48:21 -0700
X-CSE-ConnectionGUID: ScX/nCj5SmCchozr0VqgOQ==
X-CSE-MsgGUID: FBKMqUEGQ86Ox5eLHbEp+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="77020659"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 13:48:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] Documentation/x86: Switch to new Intel CPU model defines
Date: Tue, 11 Jun 2024 13:48:14 -0700
Message-ID: <20240611204814.353821-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model
so "_FAM6" is no longer used in the #define names.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/cpuinfo.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arch/x86/cpuinfo.rst b/Documentation/arch/x86/cpuinfo.rst
index 8895784d4784..6ef426a52cdc 100644
--- a/Documentation/arch/x86/cpuinfo.rst
+++ b/Documentation/arch/x86/cpuinfo.rst
@@ -112,7 +112,7 @@ conditions are met, the features are enabled by the set_cpu_cap or
 setup_force_cpu_cap macros. For example, if bit 5 is set in MSR_IA32_CORE_CAPS,
 the feature X86_FEATURE_SPLIT_LOCK_DETECT will be enabled and
 "split_lock_detect" will be displayed. The flag "ring3mwait" will be
-displayed only when running on INTEL_FAM6_XEON_PHI_[KNL|KNM] processors.
+displayed only when running on INTEL_XEON_PHI_[KNL|KNM] processors.
 
 d: Flags can represent purely software features.
 ------------------------------------------------
-- 
2.45.0

