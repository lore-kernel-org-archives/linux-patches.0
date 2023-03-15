Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D58193
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678921061; x=1710457061;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tDPZ/wPZz6V1SdFA6mDCQhkpN4FFm6ylvZiLfFxCqRM=;
  b=KPZrdyt6n/U+FvIiOsO/j7rSLCwemGh/10FEAFUjKWy1z/SdCaCFo8yT
   vflaoLZ0HiOj5xVZgq/Iv/tPYjsrLqyUERd02Y1jJ6VVz8oJWThAeiHNj
   5gxp7Dh7s9U9KyQIiTlQ220LaX9EVqJ+4S0Quh6Qla5PacDBJtpsL19jV
   RDC98NXGn9SC2TzAU1OzwTyg1W/mT5eiGQc2NxoCcq+YUUQs8fhyX+AO/
   jUUYL0q2aORK0PmlVOl3K2jbbazZYWaBreaC8xJiYx5qcTMes0wmhmCUH
   21ATUoD+qs/TwtA57ZTD9k9+iNC+r1C3PxnKmDN5tuoAkTwIzCAYqokSj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340200312"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340200312"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 15:57:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="672908595"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672908595"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 15:57:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] Documentation/x86: Update split lock documentation
Date: Wed, 15 Mar 2023 15:57:22 -0700
Message-Id: <20230315225722.104607-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit b041b525dab9 ("x86/split_lock: Make life miserable for split
lockers") added a delay and serialization of cplit locks. Commit
727209376f49 ("x86/split_lock: Add sysctl to control the misery mode")
provided a sysctl to turn off the misery.

Update the split lock documentation to describe the current state of
the code.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/x86/buslock.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/buslock.rst b/Documentation/x86/buslock.rst
index 7c051e714943..31ec0ef78086 100644
--- a/Documentation/x86/buslock.rst
+++ b/Documentation/x86/buslock.rst
@@ -53,8 +53,14 @@ parameter "split_lock_detect". Here is a summary of different options:
 |off	  	   |Do nothing			|Do nothing		|
 +------------------+----------------------------+-----------------------+
 |warn		   |Kernel OOPs			|Warn once per task and |
-|(default)	   |Warn once per task and	|and continues to run.  |
-|		   |disable future checking	|			|
+|(default)	   |Warn once per task, add a	|and continues to run.  |
+|		   |delay, add synchronization	|			|
+|		   |to prevent more than one	|			|
+|		   |core from executing a	|			|
+|		   |split lock in parallel.	|			|
+|		   |sysctl split_lock_mitigate	|			|
+|		   |can be used to avoid the	|			|
+|		   |delay and synchronization	|			|
 |		   |When both features are	|			|
 |		   |supported, warn in #AC	|			|
 +------------------+----------------------------+-----------------------+
-- 
2.39.2

