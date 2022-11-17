Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0910B17D8
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657665; x=1700193665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u9Rornpn2IRVhlMZez6eTlRt7/YpDQ3KZjhhPoPTdn8=;
  b=KppqzE5EPGzG+UxryWoIr5dXjpNS1XOhZqVHH4XUOQNIx6ue//wPe4m7
   EE7pP7/JGJaqbiO6xjOYOZU62+ztCAEdcqYIEozpRPLKxI1BBu0W8UBLv
   dihZ2X82kPOi5QXHCRL/Ca1d95QmN/830hyx4h3iUdm6wl9IH3wy7QPvf
   caKk+xlG3hd1DK+vcuqCIHCrvNhS4GbWvDd+ZjdIQK5kqsM98modXdqBR
   RLYUgjWqKB4wF+nGsD/2RoBN8oekCIz3moL93RdnTHbxY1wnypV8fgWKc
   DHgqTc6XJJL0pEpDYa0Z0YA2ql+xp8QemdDnsm7YVutXqntKX10zsZIpi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038903"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038903"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462694"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462694"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:58 -0800
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
Subject: [PATCH v3 09/16] x86/microcode/intel: Use a reserved field for metasize
Date: Wed, 16 Nov 2022 19:59:28 -0800
Message-Id: <20221117035935.4136738-10-jithu.joseph@intel.com>
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

Intel is using microcode file format for IFS test images too.

IFS test images use one of the existing reserved fields in microcode
header to indicate the size of the region in the file allocated for
metadata structures.

In preparation for this, rename first of the existing reserved fields
in microcode header to metasize. In subsequent patches IFS specific
code will make use of this field while parsing IFS images.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/microcode_intel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 2a999bf91ef0..6af1e703cb2e 100644
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

