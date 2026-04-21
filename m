Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0303D88F6
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783749; cv=none; b=fjsInrpD7+r4K1it3pheHDyNnqjTZu5w8TJ3/6PjVnrk+MBX23pLIT9EtHz/KKNfExqdx05kizbX3xADVPXV6cNukjpABcf+1kBnVKu33oml3jmYNHhfq4PW3mWiwn56QDV+XSIdXPTxad/2IrsOFJ7HV5SGylnw9asdvfa3PeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783749; c=relaxed/simple;
	bh=Z3it1FnYZTdpjrbn0d8gzlThq0L4CYKV1R0qQlDNB2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xi2k1nJpuZlCea8C1s7xzpu+1MIEdhHqJyxPNvA7CRaMuEXfZx4vm7T0pWuTSvfMO63x5qvTViDsKYmnfC7rUk0KYVhlLPlnrJFBIU9ChsAWrs4tUAmIaGa813qmEw9Zpr8wPiCA88SrfXhUQPY8wT1anNZ8z/QvUofOiGUpR+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jrslfA4Z; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jrslfA4Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776783748; x=1808319748;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z3it1FnYZTdpjrbn0d8gzlThq0L4CYKV1R0qQlDNB2I=;
  b=jrslfA4ZB9JP6Gvbs3/Yq/2D5gcHb0bR+HyC9nX78oGCIIXJnrIx02+x
   yH4U/Wd3EUUDR7b1nED+FMSt4R+TE+VIAivKsPUlTop0GWI+7Eaar0EaZ
   G2nGLTErG0Dns5Ey1UjiVpj+o9ybgwgAmPHRGivon0l9O3J9Q2JeLbojf
   3meknzStjnIsxnwwb3XI8ttTuku6WJNNgkdsvFKpn1Fk8DU/1GP7zALjX
   hEONLqXQEabMH7QFNjSeHmtLf4zbn9NIXtc/EtjuWMfAxMBoFYwPFqHU7
   j6j75M+m+YxOMyxA3TyynczuNUKXmfhhBnPzsatj/6KzAd5Tg1zAmdbbb
   w==;
X-CSE-ConnectionGUID: 9dFa0E/lQpy2/RDoJ4KTzQ==
X-CSE-MsgGUID: Lb3dg3MaTce+9D53jMWhvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="100375996"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="100375996"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 08:02:27 -0700
X-CSE-ConnectionGUID: CpxWwhRDSz2ZgJTlJpPQvQ==
X-CSE-MsgGUID: wUO+gUeISpyQPnN7+9JxHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="227731223"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.220])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 08:02:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Herman Li <herman.li@intel.com>,
	"Lai, Yi1" <yi1.lai@intel.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 0/2] ACPI: APEI: EINJ: Fix EINJV2 memory error injection
Date: Tue, 21 Apr 2026 08:02:14 -0700
Message-ID: <20260421150216.11666-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EINJV2 (introduced in version 6.5 of the ACPI specification) uses
different values for the "type" of injection. Two places in the
Linux driver need patching to take account of the new type values.

Changes since V3:

* Moved the #defines for EINV2 types to <acpi/actbl1.h> [Change submitted
  through ACPICA tree with duplicate in patch 1 of this series]

* Sashiko noted that I'd dropped the test for "flags & SETWA_FLAGS_MEM"
  from my is_memory_injection() helper.

Tony Luck (2):
  ACPICA: Provide #defines for EINJV2 error types
  ACPI: APEI: EINJ: Fix EINJV2 memory error injection

 include/acpi/actbl1.h         |  6 +++++
 drivers/acpi/apei/einj-core.c | 45 +++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 20 deletions(-)


base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.53.0

