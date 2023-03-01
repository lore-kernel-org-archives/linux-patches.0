Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0720847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D88C433D2;
	Wed,  1 Mar 2023 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694329;
	bh=PnrC8HtF2I1HgxrxHd2s31gER99ED1QIu/0VtEeXpmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSmwhv5gB0J4lR85fMLQ9geULsrEQNfTZNJ+ikmmAr+6AKUM0CR2F3Z4K+0H43+Wy
	 dDWu0KxA/mCGKQyaNY+v4YQ5y5iKpouHk97uFbmmXAIb1fTZvrbUSwgBg/XOjZxFIf
	 Grka1QApIxBwtxlVsCXED+7Eebtp+vI+UQKkrL24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/42] x86/cpu: Add Lunar Lake M
Date: Wed,  1 Mar 2023 19:08:44 +0100
Message-Id: <20230301180658.090562733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit f545e8831e70065e127f903fc7aca09aa50422c7 ]

Intel confirmed the existence of this CPU in Q4'2022
earnings presentation.

Add the CPU model number.

[ dhansen: Merging these as soon as possible makes it easier
	   on all the folks developing model-specific features. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20230208172340.158548-1-tony.luck%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 347707d459c67..cbaf174d8efd9 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -123,6 +123,8 @@
 #define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_FAM6_METEORLAKE_L		0xAA
 
+#define INTEL_FAM6_LUNARLAKE_M		0xBD
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.0



