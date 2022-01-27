Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD642CA0
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643318973; x=1674854973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LLFSoncEnmGCk0+bM6KWkrCNLOQXjiQ0xP9KGXtkU5M=;
  b=crrSiZHIeiWZoZwtsVo3hliV4pxlx4WKvnQ1tykud1F6Y7/2reI05xLP
   GVpuQ+qG0csow2/lw3i1WIt/iXRoYcSXE50Kv98wXWXR1GZSTzzvHKbtX
   JRuCQZx8yqiGsDYU7geN4cnMR5h7u8OOV8rt1NOfza9D9LYpqqm2imD6g
   v8lYnCMx9cV4deYiuqGpPyuozyzml9toiB4RJqIUILIBgSya5xL2uKJJ3
   vAu0wiCwxOjQ+QM3T4mc2geTbcm1JMkJNfyD1NPtuNMeccQM3gKFsWqIz
   4c+3qqrJixfNdoreRLW+IXRxyqmEdZUGqry+KrbWVcXgLzJ0IILIPMXmT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246746130"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246746130"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521402183"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:32 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/4] Unify meaning of interleave attributes
Date: Thu, 27 Jan 2022 13:29:07 -0800
Message-Id: <20220127212911.127741-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Interleave granularity and interleave ways can be represented either as
absolute numbers, or as their encoded values from the CXL 2.0 specification.
When region configuration and programming is created, it becomes important to
differentiate these two things concretely.

Ben Widawsky (4):
  cxl/acpi: Store interleave granularity absolutely
  cxl/core: Add more decoder attributes to sysfs
  cxl/core: Extract IW/IG decoding
  cxl/acpi: Use common IW/IG decoding

 drivers/cxl/acpi.c      |  4 ++--
 drivers/cxl/core/hdm.c  | 11 ++---------
 drivers/cxl/core/port.c | 21 +++++++++++++++++++++
 drivers/cxl/cxl.h       | 17 +++++++++++++++++
 4 files changed, 42 insertions(+), 11 deletions(-)


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
prerequisite-patch-id: 90de8aefc2999f55c7534fefa971d95653c4220c
prerequisite-patch-id: 32a5b56d83bf3372b6ed4b40f621eafb33a7201b
prerequisite-patch-id: f827831bb7a23e0789d16d7b8979b165253c6301
prerequisite-patch-id: 08b8febd42d3ab508b618937473807e553589e36
prerequisite-patch-id: 18049f47c948582c1dc26348d9765c934eb82a75
prerequisite-patch-id: 8f66d52af297449fa007a0ba963c5239b153ef5b
prerequisite-patch-id: 3e2e86cbc2631b99c1b5c0179f35799d3df31f91
prerequisite-patch-id: b88becd4997320a34e918cdef1b620e6dea14917
prerequisite-patch-id: c61df81018f2a93b87d10965b418afa659d9d6d6
prerequisite-patch-id: 73b31df62e00bb7af7082e2ca4d40023a7962abd
prerequisite-patch-id: 207abfcd5028c41df8875ee795a8ab697cd7c688
prerequisite-patch-id: 26978f021b3b0f4a6734ef8c0100c724dc88742e
prerequisite-patch-id: bf229ca5aab5c5dffe69ba5b9380749a66cf20ba
prerequisite-patch-id: 20ebefe1acfdecf184d048cb605368e1863646c1
prerequisite-patch-id: f34c26e902dd868dc1c3ef8ba8246cc063cf991a
prerequisite-patch-id: bcc59db1c6528244b649ced35eab015699c410fa
prerequisite-patch-id: 2f9f6cfbd6b73a563498c6b6d721bbc169a0a414
prerequisite-patch-id: dc8fb216dc8ff4f813bfc689273d9c5f5124e789
prerequisite-patch-id: da83e8074d339426c886c481070366afb189b561
prerequisite-patch-id: 501fe71f19065ba9f31cabd86756fedda853c414
prerequisite-patch-id: ceeef31c2ca85a426d507563b886347d28acc322
prerequisite-patch-id: f876c09942ae5a3223a36329c23262a05b2669f4
prerequisite-patch-id: 44fa61c5569614c8d9df854cde6fedfc2bc78c12
prerequisite-patch-id: 04ad90e1bbb5646125c4633fbe5341f572bc9548
prerequisite-patch-id: f4dbf89d99917f50c30e1ee56bfeff8d8dd6b0f3
prerequisite-patch-id: 2d7c3aacefcb8133897e3256ed6f76952555c2f1
prerequisite-patch-id: 7454df4bdb07381f02717845eb3b17011a89ab18
prerequisite-patch-id: 52ec0dfd506bb6a3f8d11a914cfc7320193a6445
prerequisite-patch-id: 9de14fa54cfba412e09d7b41f392c0f6d55d6a01
prerequisite-patch-id: ae39a482c2067a1f04baee5ce9131901e6d359ec
prerequisite-patch-id: 446240d2ed24d9e55ac9edfc65b511495659464a
prerequisite-patch-id: ba6bf6450e47df5e95e2fb1780d9edd126bc0eb2
prerequisite-patch-id: 3c0865b6dd062e677ef8e160e14f823622eafb9f
prerequisite-patch-id: 4503f5507cbdeb0770b420b4c26d87be2b173813
prerequisite-patch-id: c5a8cbda77c95b052040770eca0dc5b99876dc66
prerequisite-patch-id: e064003a6c48131fac401d9a48d4d6204fea6123
prerequisite-patch-id: b4c7213971c981dd5ca0fda992643a7c61548fef
prerequisite-patch-id: 2bd09e27f8a8df144a8ad386822390c87ef46ec5
prerequisite-patch-id: 60b3fafbd3bfa225405a6762bdb6b89c044b0b86
prerequisite-patch-id: 620068ae417bf0784809107e0dae3ec9793632df
prerequisite-patch-id: c3415fe92e29cd4afc508f8caf31cb914be09261
prerequisite-patch-id: 4c01f305244036afa9aaa918c8215659327dd0f3
-- 
2.35.0

