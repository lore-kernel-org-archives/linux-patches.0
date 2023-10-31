Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD60208CF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiA94Fpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B80BC433C9;
	Tue, 31 Oct 2023 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774644;
	bh=Bs3XP0BsloPrT3sn9EmpV687UrJfOQXH2Gsg5KUyCsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiA94Fpuh0sp5n1AOqph3Wg8TlfhWW3QAMdINMspAarn/pN7VPexNgkNwfEXoNDIl
	 g47R9g2RJe7vxctCJ9Kw8gPTL40ZTZJNidz5sUY8GFftQsm3oyLelRQxc/yVGRvaDf
	 WBAK8jKXlCvpNIIXRFpf9249+Re8DIuD5YuJJzxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.5 104/112] x86/cpu: Add model number for Intel Arrow Lake mobile processor
Date: Tue, 31 Oct 2023 18:01:45 +0100
Message-ID: <20231031165904.551353848@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit b99d70c0d1380f1368fd4a82271280c4fd28558b upstream.

For "reasons" Intel has code-named this CPU with a "_H" suffix.

[ dhansen: As usual, apply this and send it upstream quickly to
	   make it easier for anyone who is doing work that
	   consumes this. ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20231025202513.12358-1-tony.luck%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -27,6 +27,7 @@
  *		_X	- regular server parts
  *		_D	- micro server parts
  *		_N,_P	- other mobile parts
+ *		_H	- premium mobile parts
  *		_S	- other client parts
  *
  *		Historical OPTDIFFs:
@@ -125,6 +126,7 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE_H		0xC5
 #define INTEL_FAM6_ARROWLAKE		0xC6
 
 /* "Small Core" Processors (Atom/E-Core) */


