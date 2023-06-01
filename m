Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA174E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F34C433EF;
	Thu,  1 Jun 2023 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625770;
	bh=D4MTCTpjvm7IxHqwydvDGEjfVeHiLOxANXVHVdYa/fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOR0WIf15/3/yIkvCo+8VHjIQkpflRU+GKfmSSsN49JSdL0jN+GFkprqqr9KyBECT
	 WQnwOXujzjrj12lDRnazYdKp20L8DNVf+XYDLorvjLmyQ1B59XPHHFEqZJjpUSO2Jj
	 OCkZj+O6uSNSmedhU4SSYbz4HIJx0988z/L/MIvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/22] x86/cpu: Add Raptor Lake to Intel family
Date: Thu,  1 Jun 2023 14:20:59 +0100
Message-Id: <20230601131933.793055249@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit fbdb5e8f2926ae9636c9fa6f42c7426132ddeeb2 ]

Add model ID for Raptor Lake.

[ dhansen: These get added as soon as possible so that folks doing
  development can leverage them. ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20211112182835.924977-1-tony.luck@intel.com
Stable-dep-of: ce0b15d11ad8 ("x86/mm: Avoid incomplete Global INVLPG flushes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 14b52718917f6..7a602d79bc38d 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -104,6 +104,8 @@
 #define INTEL_FAM6_RAPTORLAKE_P		0xBA
 #define INTEL_FAM6_RAPTORLAKE_S		0xBF
 
+#define INTEL_FAM6_RAPTOR_LAKE		0xB7
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2



