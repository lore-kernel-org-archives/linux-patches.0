Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C149FBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC96C433EF;
	Tue,  7 Mar 2023 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214996;
	bh=wTO27QD7+Qf8YepKu2juaJoOTGv6Wlq2CqqJ/it4C1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wbltpSLMxvgxOVRdcmCmmmp+gSNQUP0Qc1uhfhoL5/7ro2wDY69jrMHnTIAO/oNP
	 znkDhSS51+CdtqdfgwheFC1OgT4jdKipwvLjwir6TgTqVLpCmTdPxYWMdl+eS+dtEX
	 Iw1GyHCQX/PiViU8x93WxxTq7jXX8paYvS2/iCaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	Borislav Petkov <bp@suse.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/567] x86/microcode: Print previous version of microcode after reload
Date: Tue,  7 Mar 2023 17:57:32 +0100
Message-Id: <20230307165910.931229755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit 7fce8d6eccbc31a561d07c79f359ad09f0424347 ]

Print both old and new versions of microcode after a reload is complete
because knowing the previous microcode version is sometimes important
from a debugging perspective.

  [ bp: Massage commit message. ]

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20220829181030.722891-1-ashok.raj@intel.com
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index dc346bbb06777..a7fc2d47a4ace 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -508,7 +508,7 @@ static int __reload_late(void *info)
  */
 static int microcode_reload_late(void)
 {
-	int ret;
+	int old = boot_cpu_data.microcode, ret;
 
 	atomic_set(&late_cpus_in,  0);
 	atomic_set(&late_cpus_out, 0);
@@ -517,7 +517,8 @@ static int microcode_reload_late(void)
 	if (ret == 0)
 		microcode_check();
 
-	pr_info("Reload completed, microcode revision: 0x%x\n", boot_cpu_data.microcode);
+	pr_info("Reload completed, microcode revision: 0x%x -> 0x%x\n",
+		old, boot_cpu_data.microcode);
 
 	return ret;
 }
-- 
2.39.2



