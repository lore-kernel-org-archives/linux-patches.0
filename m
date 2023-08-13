Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78DBC433C7;
	Sun, 13 Aug 2023 21:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963241;
	bh=TZMjdabBjw2/2tyqneGql4z/t5/47nnBPKJ9NoYOqXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdQhCHHwPNvdrLNebRRYIk1xVqwb8m0AL2R6+rKPBDQv+btpfglnQmr4SuX1w39Mf
	 CnBVamn0xwpSpwdLvsYpk3J6/58YEBo6cokloFe0sYUzI7A+TaHzEfQi2EBYCFwUDL
	 Mq5ki9RZEc+Qojmw6M7A5WfxBebljbFP74BewO0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 15/39] x86: Move gds_ucode_mitigated() declaration to header
Date: Sun, 13 Aug 2023 23:20:06 +0200
Message-ID: <20230813211705.362752336@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit eb3515dc99c7c85f4170b50838136b2a193f8012 upstream.

The declaration got placed in the .c file of the caller, but that
causes a warning for the definition:

arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]

Move it to a header where both sides can observe it instead.

Fixes: 81ac7e5d74174 ("KVM: Add GDS_NO support to KVM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/all/20230809130530.1913368-2-arnd%40kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kvm/x86.c               |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -986,4 +986,6 @@ enum taa_mitigations {
 	TAA_MITIGATION_TSX_DISABLED,
 };
 
+extern bool gds_ucode_mitigated(void);
+
 #endif /* _ASM_X86_PROCESSOR_H */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -226,8 +226,6 @@ struct kvm_stats_debugfs_item debugfs_en
 
 u64 __read_mostly host_xcr0;
 
-extern bool gds_ucode_mitigated(void);
-
 struct kmem_cache *x86_fpu_cache;
 EXPORT_SYMBOL_GPL(x86_fpu_cache);
 


