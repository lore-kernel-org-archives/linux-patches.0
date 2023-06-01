Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A45E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98BDC433D2;
	Thu,  1 Jun 2023 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625826;
	bh=6hQR2alFunVx/frTJvBSGz/QABVxSkAdwSYQHzZBQvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTGCvhDCaCiyaJ5+oKxApbLhB2iCoR52tLrl4a1B99pekmsyazFNpMP5EbDE8rGQC
	 U1dFfyLMGNAxhWfg+6G9gT6UGJdkDPo9vMz3+O2b0j16eIevAOQ+8JL+50VIQDcHME
	 0b+j//KGjFqgreja3jO0qNNAjSrNO7lyOIxPiL3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Zhang <rui.zhang@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/22] x86/cpu: Drop spurious underscore from RAPTOR_LAKE #define
Date: Thu,  1 Jun 2023 14:21:00 +0100
Message-Id: <20230601131933.835316756@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 7d697f0d5737768fa1039b8953b67c08d8d406d1 ]

Convention for all the other "lake" CPUs is all one word.

So s/RAPTOR_LAKE/RAPTORLAKE/

Fixes: fbdb5e8f2926 ("x86/cpu: Add Raptor Lake to Intel family")
Reported-by: Rui Zhang <rui.zhang@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20211119170832.1034220-1-tony.luck@intel.com
Stable-dep-of: ce0b15d11ad8 ("x86/mm: Avoid incomplete Global INVLPG flushes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 7a602d79bc38d..0de49e33d422e 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -104,7 +104,7 @@
 #define INTEL_FAM6_RAPTORLAKE_P		0xBA
 #define INTEL_FAM6_RAPTORLAKE_S		0xBF
 
-#define INTEL_FAM6_RAPTOR_LAKE		0xB7
+#define INTEL_FAM6_RAPTORLAKE		0xB7
 
 /* "Small Core" Processors (Atom) */
 
-- 
2.39.2



