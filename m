Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B61779B4
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982512; cv=none; b=NRO9Psi1sMMimzT0QtPBu+PqHmKHkwSSfN8/8W7t5Zqr6SJvz/5O7fQgAzEAU6tPQ8ALhvlK8uS9YTnqh4vSNOA2Kns4qG1Cp3ab0guYSUP3QcvaD9+t+y2JI1lQpSZz0+f/EzMpjFAOK04HXHgZnHNhXht13HjRmssVsbI9RGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982512; c=relaxed/simple;
	bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed5NMeCQc0d46fcJNGtIZDoZmRfbI5LPoGrkzvobErFjAZvEnrybNI9eOPkVuJ4hVCMOZSmM8EY8HybHAreSDq0MX3hL1+ep2zA/mTkzrQfuTzJQtzr/bDPWSpsog2DZUXn/lLPCjESTH/7WoDHJL4GpFhSUmSq8czdGIsrjIIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bAAcl3uF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bAAcl3uF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982511; x=1745518511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
  b=bAAcl3uFqRB9u8Gf3IwmVVdlEML24vDkIZ2J+EnIUeNIIq7e3dq7Ssnp
   9vXumMjUDrBdGa/HQIBK8QGs+DZ6R4lcnF+Zvtn61Jkr0ACKiyYChRNHJ
   WmGCHjXe0RHGaGqxfx61OuKJ5aOsUO6wImFJqOe/JOHcMw87vYu3eCzuN
   fFkMWL1X8euGoplAqtDb+ccVBoe/rkasHlcW6mlbpoBkpqtjdSMtPNKpK
   GiKyypZfilfBXyFK2/p/FvSEcZ3MQ1Dfo2iScVOVxGBinIdod3Qxw1qSL
   POPrseuLRSm+DB9nMfDsdweAP0ikM4WMhtQ67a8JCod4/K6wRzpFJG27n
   w==;
X-CSE-ConnectionGUID: GZF9eOUvTn2Sxoi7HkOVUw==
X-CSE-MsgGUID: KC9E75ePQTK7fVJCdd1SiQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481845"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481845"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:59 -0700
X-CSE-ConnectionGUID: fIvJjhdlSqKYHN3AWZyHZg==
X-CSE-MsgGUID: jJio6ahnToe8mAdZagIthw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262631"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 17/71] crypto: x86/twofish - Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:58 -0700
Message-ID: <20240424181458.41481-1-tony.luck@intel.com>
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
 arch/x86/crypto/twofish_glue_3way.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 90454cf18e0d..82311249048f 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
+
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -107,10 +109,10 @@ static bool is_blacklisted_cpu(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return false;
 
-	if (boot_cpu_data.x86 == 0x06 &&
-		(boot_cpu_data.x86_model == 0x1c ||
-		 boot_cpu_data.x86_model == 0x26 ||
-		 boot_cpu_data.x86_model == 0x36)) {
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_BONNELL:
+	case INTEL_ATOM_BONNELL_MID:
+	case INTEL_ATOM_SALTWELL:
 		/*
 		 * On Atom, twofish-3way is slower than original assembler
 		 * implementation. Twofish-3way trades off some performance in
-- 
2.44.0

