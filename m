Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94C192
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977547; x=1702513547;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JquNgRK/UoSKHUyZvjaqtUYZHzjpaqkSLJvYYN00Fck=;
  b=QouLutpB7buMuOSdBIJrze5m5sfPPfmZZku8/4lgSd2xZeKZ7YrRfL7q
   gKHIQryIqzZ5ZeV74tHzZupBOmJ2Fam9iRdvoIUsg8ckLZKAPF0A3artB
   g99TfmGL7VdMw9OmuqiEr2YY63TZ1QyukpEDTUHrHZAbY08ffDxyBwedZ
   N+rZKZw5KiSJUpG1fNfhHRdwZ0eRrKhnO1bVAkhmY5kxW0S7SaBER/Eym
   us/uzB1zxUkUkuILK6UsDfLm+ewIXQ8SpyeYG8CY/io36MqEj7yeOmkR4
   /ouakMyL2VW1IEdxqhHIXdX11Z3mpI/OHkI4fQZBUR4pIdjr0XZG4d2Fe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540196"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540196"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084761"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084761"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:43 -0800
Subject: [ndctl PATCH 4/5] cxl/test: Fix cxl-topology.sh expectations
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, vishal.l.verma@intel.com, patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:43 -0800
Message-ID: <167097754348.1189953.15721727640159522971.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
References: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When cxl_test includes an RCD there will be 4 host-bridge and 11 memdevs
adjust the test expectations accodingly.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/cxl-topology.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index fc3bbbe6b84a..89d01a89ccb1 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -117,7 +117,8 @@ fi
 # pmem size of 256M, or 1G
 json=$($CXL list -b cxl_test -M)
 count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
-((bridges == 2 && count == 8 || bridges == 3 && count == 10)) || err "$LINENO"
+((bridges == 2 && count == 8 || bridges == 3 && count == 10 ||
+  bridges == 4 && count == 11)) || err "$LINENO"
 
 
 # check that switch ports disappear after all of their memdevs have been

