Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19104746C
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662061401; x=1693597401;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pcVzr7tYohFd78StOkXJ4fl2PO+pFHjQpd6/c1NYsSE=;
  b=XauZUFpJC9X9ElGo9VaxudczQAqbHOlPLpiSOc2ccvaO2skKPrvXl1Ai
   91i6L72Pbspd8Q6hKMtc/HLST549ms0UniJrZ+oF6eDd7LttTn5pR+df6
   z2X8py14Vju+/2jjVV7oMg6A3MRWP6jdVNPUsVI0WFYS809maYGYxGO29
   Mv5Z3cAL3X0RH+l2lotCYDIThhMBO6xuuImI3yWvS69bl7vZmeQtuq1q+
   GH8c5yWqYfAjWfQ55Tl073q+s6XWATTlStWUI5dY/CPbu/xFwjgEtw0Pc
   QRFLMJcF1HX3aSShQbqCekA6SyqWuiBTAFlUyyU2MN9DfLerxcRsyAGS0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296595788"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="296595788"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674020246"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 12:43:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-edac@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Youquan Song <youquan.song@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] EDAC: Improve memory address decoding for i10nm driver
Date: Thu,  1 Sep 2022 12:43:07 -0700
Message-Id: <20220901194310.115427-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling firmware to translate memory addresses has a high impact
on system because the call uses SMI.

The 10nm server processors (Icelake and Tremont) provide additional
information in the IA32_MCi_MISC registers that can be used to decode
the address of an error in DDR memory.

Couple of prep patches before the main event in part 3 that decodes
the address from the MISC register.

Qiuxu Zhuo (2):
  EDAC/skx_common: Use driver decoder first
  EDAC/skx_common: Make output format similar

Youquan Song (1):
  EDAC/i10nm: Add driver decoder for Ice Lake and Tremont CPUs

 arch/x86/include/asm/mce.h |   1 +
 drivers/edac/skx_common.h  |   6 ++
 drivers/edac/i10nm_base.c  | 134 ++++++++++++++++++++++++++++++++++++-
 drivers/edac/skx_base.c    |   9 ++-
 drivers/edac/skx_common.c  |  21 +++---
 5 files changed, 158 insertions(+), 13 deletions(-)


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.1

