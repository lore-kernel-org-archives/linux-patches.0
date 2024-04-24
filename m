Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077CB180A90
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982521; cv=none; b=dfPkdPnmuwSERfdsOnawHvPLC83sRfJVtbRQxk6RKNQ8sbNgy/HnqyvgWpydUqrm1fbgzEtS2e7zE3TDLJgh2AUpnCxyMho2iwiUwHrxndbIn9FVHAS6LT9K76w7gd/PMPm2BQPW9fXLKwxWUqbbu0EPoAbdR6D/zstz57IT9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982521; c=relaxed/simple;
	bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpcZ00GV/QvbTww63SgYOLY6NJcNtbIbNWH0OLRB74rsmtb87PT7GHe6g2/VfkFFOOfBEwF95UfYqHpavNqPa24/Df4xv3i82q2/VwGuidVgGzaamgNLKdcCXleUtfXodvxLldQIdrOjYUAW31AQE6gwoN2nV04vi0OZuYBy7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8PJPBI8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8PJPBI8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982520; x=1745518520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
  b=G8PJPBI8fziWRHD/c2rqqIZDs0l2vGQG07ovC1zbonX3wCWgd1nlSnZd
   oWam7Spv1nPUbs8/AXXpiK/6jHcdeDqC00oOem+JjaBRt55p75rcA0EMj
   Maw1oejCfe0ufvnH3UUkaSjuqmfq0dk+gyXQ6IE8Wk5/wIOCeHzbf/Ihm
   o568dMdEQfTuKTmGURb/aUHDMGn21sae6YE1VDpZQLE7r7osECcZhnlgf
   1YOriIX9G/HehX/o3XP/3Hb0mcXtBPXhigzV5QHmTvBU/lSdcqQxWCReB
   DcyVQRjXB9KLX/TZYikPzCyyDILFLr8DtYngvIBtG5atNvzuoTHvcbgUe
   g==;
X-CSE-ConnectionGUID: plR2ygSiSFy26iAqtKQhVQ==
X-CSE-MsgGUID: 2KH1sAmLQPaXYGms8O8rNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481988"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481988"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:11 -0700
X-CSE-ConnectionGUID: S0SzPpkVTTiK11GDlb5eIA==
X-CSE-MsgGUID: y+qNwmC9SpO/79qqtW+3QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262738"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 31/71] x86/cpu: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:11 -0700
Message-ID: <20240424181511.41753-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 2243083f0bc2..8651643bddae 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -25,7 +25,7 @@
  * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
  * for various common selections. The above can be shortened to:
  *
- * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
+ * X86_MATCH_VFM(INTEL_BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
-- 
2.44.0

