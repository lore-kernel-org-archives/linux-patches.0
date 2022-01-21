Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209472C9C
	for <patches@lists.linux.dev>; Fri, 21 Jan 2022 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642787289; x=1674323289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nR54sbM3jfoKwrWn8S3jngx1W/C1FuURDqkpU392O9Q=;
  b=VRFMP0cH99cIHKv4wIc5NZPUhvDUpndmNDSkAj+EFAKg28lFH+GUECBR
   BlEqC3dsWTqLj/zv7e1GgZRbuGlnHjxQyUBP3AV3iE66B5jyG0VXocObO
   esms+seqEdSVCe0sISmsORGUqsm5juVDd9OdXIOQZ4SNbA93RIabuy0ZL
   01wxcrj6XGKCtRsfk9bwmB5FBG8la9jRsBw9XxZG3GbCsdGhN+WNCMW7b
   3sdnZusVQDWNIMFkEqNmFplUp7PPEqPnthMfsy5xZZ9IMhuMf6xIWqvrh
   SJhKj8EbGn8tROhIA/y76cq0JSRu0YKw8cF8X1GEALenxNCgz5embqX/r
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="225694168"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="225694168"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="623394788"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:51 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Ailin Xu <ailin.xu@intel.com>
Subject: [PATCH v2 1/6] x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN
Date: Fri, 21 Jan 2022 09:47:38 -0800
Message-Id: <20220121174743.1875294-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121174743.1875294-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missed adding the Icelake-D CPU to the list. It uses the same MSRs
to control and read the inventory number as all the other models.

Reported-by: Ailin Xu <ailin.xu@intel.com>
Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index bb9a46a804bf..baafbb37be67 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
-- 
2.31.1

