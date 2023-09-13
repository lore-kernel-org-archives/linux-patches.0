Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB04B37F
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630279; x=1726166279;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m9uEFh1PK56Z7q+u6kDbQXw+ZQrWKN8Nj13N/OIjzBY=;
  b=Zr4aCMof2uYvwVCZPahYW9LLVW/7QinZnm1GPet1k3/DN0oJvQ9SkbtK
   EtLlRGdoSBOH+FBracjldxMdXke5BDwg7ZMRgfVnpstjlXEKhhDnFxYw8
   Dx4TW6uF6rX0pzJj0rZ3zIzOPhy+f3TyjGQ2FMCU/qOotBVdNUqdWSBQZ
   VGzb4edBDMKalqWW8ojfzC8xoI29oyIwuWyv3gNwfGkmNRQ29Gq8BTPnp
   RT4JUiZCHltYCkVikF0iovjK5H6+BB7tXPspm221YLRf5YHEREWqRyFgf
   I2gdySTK8/eHX/lg3eXqhwB3nH8r+3yRk2HHo/DVMa0JxDNXVaDJm0ppb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019103"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019103"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238572"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238572"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:53 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com
Subject: [PATCH 00/10] IFS support for GNR and SRF
Date: Wed, 13 Sep 2023 11:33:38 -0700
Message-Id: <20230913183348.1349409-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds IFS support for newer CPUs like Granite Rapids(GNR)
and Sierra Forest(SRF).

There are changes in the IFS image loading and test flow to support
these new CPUs.

Note to reviewers:
 - patch 01/10 adds a bit definition to arch/x86/.../msr-index.h,
  hence x86 maintainers are cc-d.
 - patch 05/10 modifies an existing tracepoint, cc Steven Rostedt
 - Rest are localized to IFS driver

Jithu Joseph (10):
  platform/x86/intel/ifs: Store IFS generation number
  platform/x86/intel/ifs: Refactor image loading code
  platform/x86/intel/ifs: Image loading for new generations
  platform/x86/intel/ifs: Scan test for new generations
  trace: platform/x86/intel/ifs: Modify scan trace
  platform/x86/intel/ifs: Validate image size
  platform/x86/intel/ifs: Metadata validation for start_chunk
  platform/x86/intel/ifs: Add new CPU support
  platform/x86/intel/ifs: Add new error code
  platform/x86/intel/ifs: ARRAY BIST for Sierra Forest

 arch/x86/include/asm/msr-index.h         |   2 +
 drivers/platform/x86/intel/ifs/ifs.h     |  47 +++++++
 include/trace/events/intel_ifs.h         |  16 +--
 drivers/platform/x86/intel/ifs/core.c    |  14 +-
 drivers/platform/x86/intel/ifs/load.c    | 159 +++++++++++++++++++++--
 drivers/platform/x86/intel/ifs/runtest.c |  68 +++++++++-
 6 files changed, 273 insertions(+), 33 deletions(-)


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.25.1

