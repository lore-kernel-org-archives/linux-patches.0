Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA015C94
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861690; x=1699397690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9L4yTAcmbDrd8Wtf0AHUAz+/qaAhDmvRMsfLMW5DI0M=;
  b=mUiuhmQ5bdFXSynXTDy3lWoW/lux1uTlaQG7kUFC1DU1eL+xus+qQ2n6
   r79RgIubsSqGf/ve9YABkZpGcTbyOxY8BH4ghDfV725kucdMs7FFV877z
   RGRYm+vL831Eotpeq970Z/urz5O63fbZnt6g/9aKbef3LfdiqdKx6izYq
   ym0WHvAx3Nivz61Kifpu8UcpsTSUANWtuMv3DpJgLz2TUAK1Dzon9mWOC
   xnvT8VDmWSY/tqzAmw+jEeF9LpYjgK3r+GGIyCT7/fJ6vMIyOlzvk20hg
   jEcSSNE0EDEXbUT2DZ8AWUFmmrFKdVhScHfrBz7y+lRV4KVIH4U4GWPoQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697410"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697410"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012979"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012979"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:46 -0800
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
Subject: [PATCH v2 07/14] x86/microcode/intel: Use a reserved field for metasize
Date: Mon,  7 Nov 2022 14:53:16 -0800
Message-Id: <20221107225323.2733518-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel is using microcode file format for IFS test images too.

IFS test images use one of the existing reserved fields in microcode
header to indicate the size of the region in the file allocated for
metadata structures.

In prepration for this, rename first of the existing reserved fields
in microcode header to metasize. In subsequent patches IFS specific
code will make use of this field while parsing IFS images.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/microcode_intel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 6626744c577b..0ff4545f72d2 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -14,7 +14,8 @@ struct microcode_header_intel {
 	unsigned int            pf;
 	unsigned int            datasize;
 	unsigned int            totalsize;
-	unsigned int            reserved[3];
+	unsigned int            metasize;
+	unsigned int            reserved[2];
 };
 
 struct microcode_intel {
-- 
2.25.1

