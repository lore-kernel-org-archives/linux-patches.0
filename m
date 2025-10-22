Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3AC2FF17B
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 20:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761165933; cv=none; b=SPDIsRNfxQLKstcwcuN2Jm1IElIuSNSQXrYccjkbBoaxh5O1p5PjKQIe1LIkZ9wLlMg80/V3YBUh74vRexQnVXBdCBXFrZvQiccUdN5eENNGBVKM1EoBbPnsRCgvIvVkUA5gntm/XBEndhqZo/kT9JorBIra0G/s1pXQY2MUm20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761165933; c=relaxed/simple;
	bh=YWlHyzihnVjS1Y22x469698+jpX/0sqFDbsHjYf3Hto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U0g5oeASJ+AxJDBY0g0M+x/i4JkrQ2mR/w+F7oLpoWzHNSZb0zHJV4YVJ2rd1mz3Iue0dnVGLYQNnqqdu7LxJ2lITg0/eeb3jCF8fp6VWVfdgwfNMbaYWGjsZtbOzmlvq640AiwSDN+jdl5UkMsBwoWc+85pvmcFvYekiZ+Tew4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MquQ7tU7; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MquQ7tU7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761165930; x=1792701930;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YWlHyzihnVjS1Y22x469698+jpX/0sqFDbsHjYf3Hto=;
  b=MquQ7tU7ShCd0CHlKGp3JaC4CoLAIt5VH9NETr1jg+I4BEKNxqNgOwGP
   KRlymK/Y0GQxrfVvCeKNxMhyOeKbUD6FrVzd7ZPJdIu+G9IaADRaxA+xj
   pAV9W5qr2JFcHVywMfDR/hK4gn4JFDRXPsenfEkGcpZM1wdQdq197DMM6
   olr01kHjJdE1IttShxcyanmDkNQsLfUPujtxGLz2ZKPlDUvTt6mYNkOvf
   Lu0ex2nc6OsirG3vybNiyqdimorMo4qToa5aIcvedEOvVhzYVvoVJL09P
   iW/5z4LlSO6AlWAjVhfXXSFlBUauI4ZLRnqYdOvPxRjwiB/ouKewiw5K2
   w==;
X-CSE-ConnectionGUID: 85Yt/5hwTqO6FAPdM3Bc5Q==
X-CSE-MsgGUID: oJC1uGjSQhKHapMu8UaaLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73932464"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="73932464"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 13:45:30 -0700
X-CSE-ConnectionGUID: crn79BJiR3O4ihpirT+QTQ==
X-CSE-MsgGUID: DAXSrVtpSCGKonvPjrHizQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="189096027"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.80])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 13:45:30 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ACPI: MRRM: Check revision of MRRM table
Date: Wed, 22 Oct 2025 13:45:23 -0700
Message-ID: <20251022204523.10752-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before trying to parse the MRRM table, check that the table revision
is the one that is expected.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/acpi_mrrm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index 47ea3ccc2142..a6dbf623e557 100644
--- a/drivers/acpi/acpi_mrrm.c
+++ b/drivers/acpi/acpi_mrrm.c
@@ -63,6 +63,9 @@ static __init int acpi_parse_mrrm(struct acpi_table_header *table)
 	if (!mrrm)
 		return -ENODEV;
 
+	if (mrrm->header.revision != 1)
+		return -EINVAL;
+
 	if (mrrm->flags & ACPI_MRRM_FLAGS_REGION_ASSIGNMENT_OS)
 		return -EOPNOTSUPP;
 
-- 
2.51.0

