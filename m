Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E4D7C
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977523; x=1702513523;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WuX5Ni1zMmbFtgxAUJWSCLA953JcY5rJhbJy8za9GUo=;
  b=T09CWk7Qy6LRkuGg7O3/40BRvA2cfZ9pcFQvua6HGLqqYJ6EyRuJjiIJ
   C+1i6xB1YbSMp1dQvrhoQnTMUudGnDOtqSdn4XYPQfBx1aYm6vpozobBW
   chmLtBZDxaCYW7E0TROocUeEqpf0GP9V+9RojyDRr7CN6NDD2pJaXoqL7
   X/SxhENP3nXxtWQOKS17g52dxdA8hxbRYHf8gNzyiNzmVI2WyM4QE/nI8
   Tcig1y0CV/3qeCeTLiBCkFhatteCeHJq/baZAMCsplI0f41wN02AqOo7i
   39VtLQXuHVXzUfcLgUBRItbB5Mr1XY55OADtoyUGWTGTOa+b6mRDs0yBt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540090"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540090"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084711"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084711"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:21 -0800
Subject: [ndctl PATCH 0/5] cxl/test: Reliability fixes
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, Matthew Ho <sunfishho12@gmail.com>,
 vishal.l.verma@intel.com, patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:21 -0800
Message-ID: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Following up on the last round of updates [1], add support for the
recently landed RCH enabling in the v6.2 kernel, and improve the
reliability of test execution.

For RCH support 'cxl list' now understands that some CXL endpoints do
not have an intervening cxl_port object instance between themselves and
the CXL root object.

The largest change by lines of code is support for flushing udev event
queue in response to API calls that mutate the topology. This reduced
the need for manually invoked 'udevadm settle' in tests and end user
scripts.

[1]: http://lore.kernel.org/r/167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com

---

Dan Williams (3):
      cxl/lib: Add cxl_wait_probe()
      cxl/test: Fix cxl-topology.sh expectations
      cxl/test: More backtrace detection

Vishal Verma (2):
      cxl/list: include --endpoints in -v listings
      cxl/filter: enumerate endpoints and memdevs in an RCH


 cxl/filter.c              |    8 ++++
 cxl/lib/libcxl.c          |   91 +++++++++++++++++++++++++++++++++++----------
 cxl/lib/meson.build       |    1 
 cxl/lib/private.h         |    1 
 cxl/list.c                |    1 
 test/common               |    1 
 test/cxl-create-region.sh |    4 +-
 test/cxl-labels.sh        |    3 +
 test/cxl-region-sysfs.sh  |    1 
 test/cxl-topology.sh      |    4 +-
 10 files changed, 89 insertions(+), 26 deletions(-)

base-commit: 95faaa09cf1c455a1b5d2fb934a0b96367d0f189
