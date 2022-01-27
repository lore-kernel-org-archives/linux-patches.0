Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1212CAA
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643318975; x=1674854975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c1aM+hrXlpfMyS4zpoHXcSqxmp0h+TQpG3apP92+EwM=;
  b=JEUSNKAF9yyswGrEKww7f2nMBEIaB7TLz6kJfAfclpbRKFh0SqYG9EtF
   +2X7AygczSjWJQrMl8eWk+TJCcJkH4U5X0e07vatnDSXmWURk/R+9lHho
   oLQ76mX2IzIQgrwJn19U+GcYLd2rSxdVGT6yWX4UyVgdblQ/T8n/YjBoX
   ne3zbqzPTwR6RTxSf+QIHLAAIl5cemEYgLmyyrnEfyj5MGnKD4RU1ZCXg
   ZPXu513Aki9OyBfMPOql9qvR5PHwrEPH+wgr5VkhJtLX/Ry9lNKBSzHwv
   Nf3PAuHWQZXEeHscB5EyI2/XLSUNANxB0RI9lftl4JdtdvbkmlM0ENf3o
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246746136"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246746136"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521402198"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:33 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 4/4] cxl/acpi: Use common IW/IG decoding
Date: Thu, 27 Jan 2022 13:29:11 -0800
Message-Id: <20220127212911.127741-5-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127212911.127741-1-ben.widawsky@intel.com>
References: <20220127212911.127741-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that functionality to decode interleave ways and granularity is in
a common place, use that functionality in the cxl_acpi driver.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index f99cad8350fd..d6dcb2b6af48 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -10,8 +10,8 @@
 #include "cxl.h"
 
 /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
-#define CFMWS_INTERLEAVE_WAYS(x)	(1 << (x)->interleave_ways)
-#define CFMWS_INTERLEAVE_GRANULARITY(x)	(1 << ((x)->granularity + 8))
+#define CFMWS_INTERLEAVE_WAYS(x)	(cxl_to_interleave_ways((x)->interleave_ways))
+#define CFMWS_INTERLEAVE_GRANULARITY(x)	(cxl_to_interleave_granularity((x)->granularity))
 
 static unsigned long cfmws_to_decoder_flags(int restrictions)
 {
-- 
2.35.0

