Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3206A12DD92
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643319; cv=none; b=U3L58vV3jHnzQrNlvx7dXCkM1xEz/15WSKg+7fUYlzHDCrd9OmhP0rCNKCSgxNG8wpNoKZziVnOwB1dGZn9Z/8cNVDLO1t12+qtFJ069TGO0r1xF3a3k7arUNTLkmE9ksq9mwdIW5PAjtgCZX7fNRgALG4Tr1vcZ7I9ienRzPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643319; c=relaxed/simple;
	bh=UGEw2wLj1K8vQaWrX5dXU0U1OAJhcpCUAILxYE5zspA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnzUiAz0Lanejj3kLZwGll7y97QKns8IrmgnZKfojx8tbcYoJSa0rMCFdyDibxirQ1mJ59L8cZ6ijyGiixf4h9DvN3biUzaepiG8zMUSyORd7uJQTl93JQ5fBU36081urtAyS9GuUg3qIMs4woeUzAUO3yk7seoV8w51fMlmXxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WGLkGxan; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WGLkGxan"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643316; x=1743179316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UGEw2wLj1K8vQaWrX5dXU0U1OAJhcpCUAILxYE5zspA=;
  b=WGLkGxan8OGEbmFjUhV0QN1L6Ju+UqMWh8bz9g7NTnt3mBWRmDvKAOPx
   bhyycjIwQ9xqlBCa50/dcyL6e7/RfEPC/7jXRMZyg5QGMsvcyPITY3ej2
   nx9xLotpK6cbChmpUREFtq7Q0ouzyUd9daekL6wFMguP1mgSwaAPbS3Gp
   3EaAYLkwwjQt4DSGFw6ZkX7Jk4A5N0XSCuNvunr/J350MvSTGrpzltJ4J
   zhafU5HWwd6E1rhFDlMmGnc1pzOoYP2eWiPhkNgCdnMfrB/0YIuB4NPra
   tZVBY4siTM8iGDu9hJNfzE+OWu3AoSnkQHY0JK4kZax9WzoNj3Y3Agl2V
   w==;
X-CSE-ConnectionGUID: c+1/xn4LTXO++bMK051iTQ==
X-CSE-MsgGUID: eMil3TMVQi+G5vj5VrG7fA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294789"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294789"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726140"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 58/74] x86/cpu/vfm: Update drivers/platform/x86/intel/turbo_max_3.c
Date: Thu, 28 Mar 2024 09:27:52 -0700
Message-ID: <20240328162820.242778-58-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
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
 drivers/platform/x86/intel/turbo_max_3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/turbo_max_3.c b/drivers/platform/x86/intel/turbo_max_3.c
index 892140b62898..79a0bcdeffb8 100644
--- a/drivers/platform/x86/intel/turbo_max_3.c
+++ b/drivers/platform/x86/intel/turbo_max_3.c
@@ -114,8 +114,8 @@ static int itmt_legacy_cpu_online(unsigned int cpu)
 }
 
 static const struct x86_cpu_id itmt_legacy_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,	NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,	NULL),
 	{}
 };
 
-- 
2.44.0

