Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E46717F4E9
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187836; cv=none; b=APP/uZtGaOkf5FEega6cpROdxPV3Vti9PhtJ9bMlRU6sQtuNIGZewB4A+v2mNxBQEEq2KMLbL2dbXx8X7AIPyWOpsrXyIj9O6l/kBZx4LTJtweKPN8Wrx+W4adKTf9LRLzbdJ/IzZ/maBEtwOjLsOOPlE9vTL3EMsdfXZjMm8Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187836; c=relaxed/simple;
	bh=fYJHYz8V9kimHRbxD5uVEAotpDMXkQsRHlaEWk/P2XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZVw/m4QP5f3C+TeB4UKeRb64uvZAza4TYnxcEQY4ZfCmC/PISwsWe6obQqvtWFZqlMzTYFzl/1gazcSe8QWsXBcZNyVLVB3ytrqlNTVKWHn73jU3RRivnCop6S17rJNuy+sT5D2C6jG/o/W+SCMfCuUtXM8b3B66S+TnmnhcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhxbrwBp; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhxbrwBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187834; x=1748723834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fYJHYz8V9kimHRbxD5uVEAotpDMXkQsRHlaEWk/P2XA=;
  b=IhxbrwBp6oNwE3HsRARz+ta7fux+EMRiXzbylkNlG21sdYUmouZq6jg3
   EmUfYEqLuCfdf6cN8P3d+J851+35bBrdtLndBV1awvOGbOApyTHxVImuL
   xCUu7PmRKITUpJgK5JLrrUvUjlw4bJrRX3JJ2Fd8ITS3yH5zmi/KaYkN+
   LuXYheMaeONMgROcOT/Y1q0xyuKhfqj2O++BuJqOG5Q8fYdU8+Q/pTEb0
   s/Wu518Sk8hcsPjA4AhtQ5gWkOfdkY5Gl+4URVIlF6J6ZzQGagTwspo0n
   VWcbkZsX0/Ere8DBrkZ4q9osT6g57iu77lEA3bku//boVvzB4n7aPSOgE
   g==;
X-CSE-ConnectionGUID: LhHGCdgORMWStl8lVVWb4g==
X-CSE-MsgGUID: 5PQxdX3/QDWhPRnA3KH01w==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871832"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871832"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
X-CSE-ConnectionGUID: jlutvOQKQTeichxkEJghtg==
X-CSE-MsgGUID: HXsIpmIITtKI0awIz129Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355371"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 03/11] x86/platform/atom: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:36:59 -0700
Message-ID: <20240531203706.233365-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
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
 arch/x86/platform/atom/punit_atom_debug.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/atom/punit_atom_debug.c b/arch/x86/platform/atom/punit_atom_debug.c
index 6b9c6deca8ba..44c30ce6360a 100644
--- a/arch/x86/platform/atom/punit_atom_debug.c
+++ b/arch/x86/platform/atom/punit_atom_debug.c
@@ -165,14 +165,13 @@ static void punit_s2idle_check_register(struct punit_device *punit_device) {}
 static void punit_s2idle_check_unregister(void) {}
 #endif
 
-#define X86_MATCH(model, data)						 \
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_##model, \
-					   X86_FEATURE_MWAIT, data)
+#define X86_MATCH(vfm, data)					 \
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_MWAIT, data)
 
 static const struct x86_cpu_id intel_punit_cpu_ids[] = {
-	X86_MATCH(ATOM_SILVERMONT,		&punit_device_byt),
-	X86_MATCH(ATOM_SILVERMONT_MID,		&punit_device_tng),
-	X86_MATCH(ATOM_AIRMONT,			&punit_device_cht),
+	X86_MATCH(INTEL_ATOM_SILVERMONT,	&punit_device_byt),
+	X86_MATCH(INTEL_ATOM_SILVERMONT_MID,	&punit_device_tng),
+	X86_MATCH(INTEL_ATOM_AIRMONT,		&punit_device_cht),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_punit_cpu_ids);
-- 
2.45.0

