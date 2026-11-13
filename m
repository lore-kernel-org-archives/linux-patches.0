Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591715;
	b=QSZRPLaOfKNOA1BerfurgDvT3uc9k7PA6erj7B1gm33jBHla5fSnGtw8YE+595A5u2RU
	 INvQYJUGWNcHLGXXAj2OXvn40arF7cEnsQUyG95/ce4/berov/JSb2Fecxrgo15uh5cZJ
	 8izcUK0Xw2c2qYHNLpXFNdwRPKBm4fYy1wrseXTrDgNyGX+50oBCWu8sT+YZGLrgnJz0Y
	 Nrs96e4t0O1BQkryyAqrpI5YVGDTJXfoKYFeGIeosxNv0+5X5PdlQi5fCHNDfDeG+H2k/
	 eNGRyDxXLwgh2fCOqyYg4+XVyAWJw+f/Tws98OLSItJ6R9jR4WkfLXs2EY5/nOAw6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591715;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IfmSocrZvEleSEw8e1476dtq8P/mTSo2YReK7ZjdB2Q=;
	b=mhKBsOVeh1MVT00xsFXc+Uapn3ZlK4tTFCJYtZqzDitnbG2V2/p5HlUOfhvAkrUlnXUw
	 QUi31f+NqdgUZkZQFDlpPu3dgekCi1D8jMIfOZy5iCt7cTWaY3szL6nxMtDh5gIz6iliZ
	 n7i3QesTMl0s6cLkF6Y0q/yIn8uB4mfi9aJOne/9OSXSUrd0HxyfLXuY+ejspJ2dl9JTo
	 OpisLmXMkHeWEFcmn69mC2wmeeGgAlAYR4C9G2jBXlDQHg2HJJkpT3cX3+/2go0H4uS5U
	 quEMVOw1wz1Qz+RsiZdJ/iYJoEvLuVGtHU4YPyBIJjwlCIiwY1A8copEykzOBAaePLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eEJHnZ01;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F106070F15
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 17:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8F106070F15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eEJHnZ01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794591715; x=1826127715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yhhgobd8eM/gIokmkqi2ACthXUuyo2eBk292YnghZ/k=;
  b=eEJHnZ01FlWR/E3j5BaDAlFxyZsiY46LFAOzJpxfPjqEsZqeISXKrN2G
   3oMu16wGKi8j27S+rj/5vw42UdJfUXVTQMR9ah5xFl71D/NfKQp2KwTgv
   quQef0xJPndSKOak3Zet4qXdeaQ7ytm21jnDQ+OG3x5lI+ig5z3rDH4zS
   KUCFFI8IdOvqB8rKkl3JkZIHMAmuGgfIlxCBKW3soypjsQkif38aY+SJa
   t65lRSa74uZZK4jfEOR7GcTNi3ffcDSOu+bm27NNmMrguc60LJgSGQipl
   F9XU/keA5YyZOt+C1DmCijoU0c+eNXXrEK7xsQeyI+HF4S9YqGAQWK7XB
   Q==;
X-CSE-ConnectionGUID: 3VrVxlSqTCi9WzkGGVgjjQ==
X-CSE-MsgGUID: f9K/pmt1QkGs4rgMP8ANyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3415603"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3415603"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 09:41:54 -0800
X-CSE-ConnectionGUID: f8HBsq0fSe68/GlFMYl16A==
X-CSE-MsgGUID: piIFZ4jCR8mp/xSrHgi4eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9290941"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.53])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 09:41:54 -0800
From: Tony Luck <tony.luck@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add Intel Coral Rapids and Razor Lake CPU models
Date: Fri, 13 Nov 2026 09:41:45 -0800
Message-ID: <20261113174145.13513-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
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

November 2026 "Intel Architecture Instruction Set Extensions and
Future Features" published the model numbers for the upcoming
Coral Rapids server and four Razor Lake (two desktops, two mobile).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 66d964afe18a..2a5761d475b8 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -129,6 +129,8 @@
 
 #define INTEL_DIAMONDRAPIDS_X		IFM(19, 0x01) /* Panther Cove */
 
+#define INTEL_CORALRAPIDS_X		IFM(19, 0x08)
+
 #define INTEL_BARTLETTLAKE		IFM(6, 0xD7) /* Raptor Cove */
 
 /* "Hybrid" Processors (P-Core/E-Core) */
@@ -159,6 +161,11 @@
 #define INTEL_NOVALAKE			IFM(18, 0x01) /* Coyote Cove / Arctic Wolf */
 #define INTEL_NOVALAKE_L		IFM(18, 0x03) /* Coyote Cove / Arctic Wolf */
 
+#define INTEL_RAZORLAKE			IFM(18, 0x06)
+#define INTEL_RAZORLAKE_L		IFM(18, 0x07)
+#define INTEL_RAZORLAKE_U		IFM(18, 0x09)
+#define INTEL_RAZORLAKE_S		IFM(18, 0x0A)
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_ATOM_BONNELL		IFM(6, 0x1C) /* Diamondville, Pineview */
-- 
2.56.0

