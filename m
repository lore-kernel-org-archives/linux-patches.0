Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE40D8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21169C4339B;
	Fri, 10 Mar 2023 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459741;
	bh=Jn35S2Wz0hogJ3ggSn60Ls/U8FBnNR+F87d+3fk5edQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0AN9sAGmLrkSQChRuMkEgdh4P3/d2O9m8pXtr6iORHAqNPKZhlWyFg4b01C4yXr/
	 nr0Z/B14sYTARBLBaNn/BGy4tyXWuFOU+DwgkyInGPxwSu58TI0FqxsnfboWdOC5Wl
	 E/PwlW8NKvE3i7rWJRKU2e8PEn3kU3dCmaikE6/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	Borislav Petkov <bp@suse.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/529] x86/microcode: Print previous version of microcode after reload
Date: Fri, 10 Mar 2023 14:34:07 +0100
Message-Id: <20230310133809.790402151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 5b27030714e43..707a385943b41 100644
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



