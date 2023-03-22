Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA58B15A9
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679445485; x=1710981485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iC/ejTfRQ+T7oTkSU6HDeauMoGFLZcP67w8IIlZp0OY=;
  b=cY+YdrCNg86mee2FmPOE2AiRC/XOa1NEjmWtmlO9DOmnsqemm5oa9sor
   naudb5n3S5CrbCekzFxJbE+nSTfND9kDGsUrWTe8qfOc0YjVlSKfHsCFD
   voORdzZ2S+2crPvxLg/cNcCbWVXoSFdlaxehFKwUH6PKPFM0jNszXTAuB
   fFSYs6j8MH2rebDsC3a+u4ZOT6mNPkiFgqv76G3ru60oIHxadRPuxcJee
   u5VmgjPvvtDo5rQuB9RVKReu5tQdiijmaMy3bXhkU/edT0tWVLSnKcBvm
   dhnMuOt1owX2Qj2h6/OGQpcAmyJwr348YylVab4VQ+B5V33d5mZojir2X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322934915"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="322934915"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="675076039"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="675076039"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:03 -0700
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
	rostedt@goodmis.org,
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
Subject: [PATCH v4 4/9] x86/include/asm/msr-index.h: Add IFS Array test bits
Date: Tue, 21 Mar 2023 17:33:54 -0700
Message-Id: <20230322003359.213046-5-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322003359.213046-1-jithu.joseph@intel.com>
References: <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230322003359.213046-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define MSR bitfields for enumerating support for Array BIST test.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/x86/include/asm/msr-index.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ad35355ee43e..3aedae61af4f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -206,6 +206,8 @@
 
 /* Abbreviated from Intel SDM name IA32_INTEGRITY_CAPABILITIES */
 #define MSR_INTEGRITY_CAPS			0x000002d9
+#define MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT      2
+#define MSR_INTEGRITY_CAPS_ARRAY_BIST          BIT(MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT)
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
 
-- 
2.25.1

