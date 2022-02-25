Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247DE1B60
	for <patches@lists.linux.dev>; Fri, 25 Feb 2022 06:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645768857; x=1677304857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bWlKNfh2ogOUVi22RWouW3AeWqrfGQg0sAdn7A2eQww=;
  b=QJSJCThoKaN5kSCCcm+NaAh+A7KrRNgrbAdEAs4peVQ5vlkrIlRB00/Z
   MNc64chFLp5yTk0T85txIxRckL+tlntZctkiHzNnyfuNDVUOpb9RLM7GN
   4iF5OXU6+M/0HO4KjDxPs01r8C6LJNVcP7Mt2DJTBMr2vvDITT54KbCRo
   nZ8cs2ihHE39G9wmYy3+ofOoGUVKjViPEZL5bcHxwvUK0jMcCyZeh665W
   w8xb4cXoryWQf2lBGU5xnxnIDGGd5LJD3s+FydWqS58/q1CgWW5vBTdLk
   OWhfO6OOuhiW72HrkW+a38drS0LhuV9eA3FY7NomadXKN4x9bzrbf6QbH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277063332"
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="277063332"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 22:00:56 -0800
X-IronPort-AV: E=Sophos;i="5.90,135,1643702400"; 
   d="scan'208";a="549108223"
Received: from tperters-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.138.9])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 22:00:55 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 0/2] Region creation/configuration ABI
Date: Thu, 24 Feb 2022 22:00:36 -0800
Message-Id: <20220225060038.1511562-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I'm looking for feedback on the next generation of the region configuration and
creation ABI. The primary changes from the v3 posting of the region driver [1]
are:
- Decoders instead of memdevs for targets
- Substantial rework around creation
- configuration sanitization at ABI boundary
- teardown region on memdev/decoder removal

With the new changes, it makes the most sense to rework the series so that
existing region enumeration (setup by boot firmware) be done prior to allowing
region creation. This is because the changes requested will require claiming
resources at configuration time rather than region->probe() time.

That said, these patches do reflect the proposed ABI and they can be reviewed in
parallel with that work. I'd appreciate feedback around whether the proposed ABI
is missing anything, and, whether there are inherent flaws in the
implementation.

[1]: https://lore.kernel.org/linux-cxl/20220128002707.391076-1-ben.widawsky@intel.com/

Ben Widawsky (2):
  cxl/region: Add region creation ABI
  cxl/region: Introduce concept of region configuration

 Documentation/ABI/testing/sysfs-bus-cxl       |  82 +++
 .../driver-api/cxl/memory-devices.rst         |  11 +
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   3 +
 drivers/cxl/core/port.c                       |  26 +
 drivers/cxl/core/region.c                     | 568 ++++++++++++++++++
 drivers/cxl/cxl.h                             |  21 +-
 drivers/cxl/region.h                          |  93 +++
 tools/testing/cxl/Kbuild                      |   1 +
 9 files changed, 805 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cxl/core/region.c
 create mode 100644 drivers/cxl/region.h


base-commit: 3bdf187d313e067de2a81109f9a1dd3da7f3dc2c
-- 
2.35.1

