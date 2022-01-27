Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96A2CA8
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643318973; x=1674854973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQO89et669dzx6ow2bGppQogeEOsPa/FRO7ZoBM0oT4=;
  b=nYysLpYRLSG40QpbzRnnJVI0OwigaZEK0EkOPhnkr54UVITdBysrQ0rp
   dX5Ig34JVL2ZbH3TftMnETIX+GElzLxOIVR4ZCOvRqs6LU7PvckAtMXqG
   Y+dsWDhYWTMVDLWhhtUMZwTZwWFp1CoX2Ixz/xJFymUreMam4qnvyOvNd
   LIS4IAgYi7v3V1FjC2qvryvWqvEfcf2ShuLoszqaXZOM4x4C2v1MkZsgN
   HZ2IHqjEtoP2tesv51xjyf3eJRHOTGZIP/v0a7qOvOJ3ZTBcp8X46xFiG
   rFe06mHv90fRnj1lakYtyPZGm87BIAtQieahsW7cgHr9dQ48ypxIf3qHm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246746132"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246746132"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:29:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521402187"
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
Subject: [PATCH 1/4] cxl/acpi: Store interleave granularity absolutely
Date: Thu, 27 Jan 2022 13:29:08 -0800
Message-Id: <20220127212911.127741-2-ben.widawsky@intel.com>
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

This matches the usages everywhere else in the driver and matches the
existing kernel documentation defined for CXL decoders.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index f64d98bfcb3b..f99cad8350fd 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -11,7 +11,7 @@
 
 /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
 #define CFMWS_INTERLEAVE_WAYS(x)	(1 << (x)->interleave_ways)
-#define CFMWS_INTERLEAVE_GRANULARITY(x)	((x)->granularity + 8)
+#define CFMWS_INTERLEAVE_GRANULARITY(x)	(1 << ((x)->granularity + 8))
 
 static unsigned long cfmws_to_decoder_flags(int restrictions)
 {
-- 
2.35.0

