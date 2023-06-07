Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DA410FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4253DC433D2;
	Wed,  7 Jun 2023 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169624;
	bh=LftgIm+C2ArXOVnYBMfF1RS9cHuiIsdwHDueQ+8ADfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8UP2WSBdWE+pIE5OHVpApaVqylfMR1O2mjR4a9LBo6rP1l/IyvI76naO4f6iPlF2
	 D+mRXYaWYLshZPTxHBZzkwsOB6Rh29UgblSQgN6+MraRuvIFPbB02Ui03uP6zBcTQI
	 KnoxRmHfR0dJ8tSpY0m9bafsaufGDxWGQfD5Z/a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 151/286] arm64/mm: mark private VM_FAULT_X defines as vm_fault_t
Date: Wed,  7 Jun 2023 22:14:10 +0200
Message-ID: <20230607200928.037207044@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit d91d580878064b880f3574ac35b98d8b70ee8620 ]

This patch fixes several sparse warnings for fault.c:

arch/arm64/mm/fault.c:493:24: sparse: warning: incorrect type in return expression (different base types)
arch/arm64/mm/fault.c:493:24: sparse:    expected restricted vm_fault_t
arch/arm64/mm/fault.c:493:24: sparse:    got int
arch/arm64/mm/fault.c:501:32: sparse: warning: incorrect type in return expression (different base types)
arch/arm64/mm/fault.c:501:32: sparse:    expected restricted vm_fault_t
arch/arm64/mm/fault.c:501:32: sparse:    got int
arch/arm64/mm/fault.c:503:32: sparse: warning: incorrect type in return expression (different base types)
arch/arm64/mm/fault.c:503:32: sparse:    expected restricted vm_fault_t
arch/arm64/mm/fault.c:503:32: sparse:    got int
arch/arm64/mm/fault.c:511:24: sparse: warning: incorrect type in return expression (different base types)
arch/arm64/mm/fault.c:511:24: sparse:    expected restricted vm_fault_t
arch/arm64/mm/fault.c:511:24: sparse:    got int
arch/arm64/mm/fault.c:670:13: sparse: warning: restricted vm_fault_t degrades to integer
arch/arm64/mm/fault.c:670:13: sparse: warning: restricted vm_fault_t degrades to integer
arch/arm64/mm/fault.c:713:39: sparse: warning: restricted vm_fault_t degrades to integer

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Link: https://lore.kernel.org/r/20230502151909.128810-1-minhuadotchen@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index f4cb0f85ccf49..d1136259b7b85 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -480,8 +480,8 @@ static void do_bad_area(unsigned long far, unsigned long esr,
 	}
 }
 
-#define VM_FAULT_BADMAP		0x010000
-#define VM_FAULT_BADACCESS	0x020000
+#define VM_FAULT_BADMAP		((__force vm_fault_t)0x010000)
+#define VM_FAULT_BADACCESS	((__force vm_fault_t)0x020000)
 
 static vm_fault_t __do_page_fault(struct mm_struct *mm, unsigned long addr,
 				  unsigned int mm_flags, unsigned long vm_flags,
-- 
2.39.2



