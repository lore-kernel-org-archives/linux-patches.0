Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406B6192
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977546; x=1702513546;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7jbLM0XghqsToxyKzyLdUFEETSZIgZS6zF4ttJpczw=;
  b=I7fVX1ztUNxVYHb+V/gHKrBOqAC2W0wExU7TSIpIJRPlcGf8YY5tmtmG
   cRh+MulW+DoFtAsyCMmsV3aqD0mCiLazCY0oy1hpOf6B/POylW1C2OeaR
   APYjsyhau0iYL6pqi0gD/pY45d5PBUP9cgI362uKWi21TRiB/78OUrToh
   tbSsePuLNVy7+Yl5u2OaF57GyDl3Pudx/4eJqa1aroKOMH/p25KMzvjck
   IN23kXz7fa9/WZIzjzW3Jw4HA0arpYZ9EEn0xkKYbtBZ59zrEUvdV94hs
   72cFmO/fMBy9Br2v7A4X7nwhuyvKPsL6SWrf0xaCVUC7tOn0toZLerR/R
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540183"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540183"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084723"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084723"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:27 -0800
Subject: [ndctl PATCH 1/5] cxl/list: include --endpoints in -v listings
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Matthew Ho <sunfishho12@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>,
 vishal.l.verma@intel.com, patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:27 -0800
Message-ID: <167097752718.1189953.16557353877320313731.stgit@dwillia2-xfh.jf.intel.com>
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

From: Vishal Verma <vishal.l.verma@intel.com>

The first level of -v (--verbose) for cxl-list is meant to include all
topological details of the CXL hierarchy on a platform. The endpoints
listing was missing from the first level, and also wasn't added at a
higher verbosity level. Fix this omission by adding endpoints to the -v
verbosity level.

Fixes: 8b61e8e75443 ("cxl: Add list verbose option to the cxl command")
Cc: Matthew Ho <sunfishho12@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/list.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/cxl/list.c b/cxl/list.c
index 2f5e83d86578..e3ef1fb533c9 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -123,6 +123,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 	case 1:
 		param.buses = true;
 		param.ports = true;
+		param.endpoints = true;
 		param.decoders = true;
 		param.targets = true;
 		/*fallthrough*/

