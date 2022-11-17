Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7817D8
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657660; x=1700193660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPEjBcX35onzk13t+gpBWDfzAecGrtv8ptzMtVu7P4k=;
  b=X2fxDchf+arj9sr7uYl/DIzGs6VlaOf5wfVqD3BSDKyvo8ursnWgv1dn
   D3kIeXBgC+FhyufJy125r/VX2VIPExg36gMdRIBSIeyIM6UuSyFlj0Yp7
   Dhe3MsR7bjNtDX910WEoGSXXcEbIJI9bHCxxLm/3drDZaDH7fuo8w1NI4
   GvTfIg5Wn8gIyGDXuYFAuVrpco+wggKSs5tj0ZqpFO+JhHpQi64dl/gg3
   fvCnonrbdi7SoUgc9ez43jNyhDzs37sW65h3/LtPBwG1ItqHU9oQRLFJG
   r7n7Ods9oaOZ7KfejG+eeljKmesRtTsAMep8YrKNVW4vdKuPZRJazq0j9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038878"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038878"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462644"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462644"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:55 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v3 01/16] platform/x86/intel/ifs: Remove unused selection
Date: Wed, 16 Nov 2022 19:59:20 -0800
Message-Id: <20221117035935.4136738-2-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221117035935.4136738-1-jithu.joseph@intel.com>
References: <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221117035935.4136738-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_INTEL_IFS_DEVICE is not used anywhere. The selection in
Kconfig is therefore pointless. Delete it.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
index c341a27cc1a3..89152d46deee 100644
--- a/drivers/platform/x86/intel/ifs/Kconfig
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -4,7 +4,6 @@ config INTEL_IFS
 	# Discussion on the list has shown that the sysfs API needs a bit
 	# more work, mark this as broken for now
 	depends on BROKEN
-	select INTEL_IFS_DEVICE
 	help
 	  Enable support for the In Field Scan capability in select
 	  CPUs. The capability allows for running low level tests via
-- 
2.25.1

