Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272051C26
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657477529; x=1689013529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ag19OIdVMzRzdhqat/O5TJVp4xTWh8Hj62iiQEx2/c=;
  b=YraPwMUdcZ/OQs04tDLKWJCK72hUhm++wnbarqJvbQ80Fo9N63AcNKgT
   gHUUkPwlSFg0ML1GslHPNMyBkGhU8GzmQPz0EcKPP2sAAGZfGX7H/LFfT
   z8bTTsUJ+iia7rzjECs9GCMshtJiwHvdnflnxq2kmRmKr+XdQXEmzzJT6
   lHGreLe5St99VZWUVSXKPteuvu8/Fh2IbfkSwB+DLijjr/BHZu46X5lY8
   +qEtCrkzukSFUtZc9PAcTmS+souXlcwfWNwTLqoHMIdGBYOEKVT8UkUnO
   8e9frd7JYKZSxWSUzq2QWYVOiL2qTQLsurXet4QweK3WHE2Lv9Ziy+zEj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267572506"
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="267572506"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="736864829"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	markgross@kernel.org,
	ashok.raj@intel.com,
	ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/2] Documentation: Correct IFS reload documentation
Date: Sun, 10 Jul 2022 11:25:20 -0700
Message-Id: <20220710182521.60642-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220710182521.60642-1-tony.luck@intel.com>
References: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
 <20220710182521.60642-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

The location where the scan image is stored is incorrect
in the current documentation. Fix this.

Fixes: 34604d289167("Documentation: In-Field Scan")
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 73c8e91cf144..622a246b62cb 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -39,7 +39,7 @@
  *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
  *
  * Similar to microcode, the current version of the scan tests is stored
- * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
+ * in a fixed location: /lib/firmware/intel/ifs/family-model-stepping.scan
  *
  * Running tests
  * -------------
-- 
2.35.3

