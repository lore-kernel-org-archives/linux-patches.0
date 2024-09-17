Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1828183CB2;
	Tue, 17 Sep 2024 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726588982; cv=none; b=Dc8NaboCoH5ESFAzm2+grlLyLGBad7U7K2uTgHww9n9m3yE34p8tfWzzdqTOK0aNidParmIeYTygb0OB2XXf9px0JcRs47q9c7SajKyPBX5tGQ31eG2IFbd2YjW8oOMu8Nj16vsdc57O6T6RRp/b8DSz0pUoYFpwPyDg7jkuXY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726588982; c=relaxed/simple;
	bh=ut7+hKu9XXGBX1hORm85Odfx/e7qFN4ndLnDPCa+X3I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rpQvCOYQL4OZMjpl0CG/vHrVF3/27BupPzIof3hkugjB+5QO3ls05iiY14vIHWz2kdTq9Hsn9x4NxmTyKEX3nT6H4olDXDJ5aHbQCvbeVdPQJQ/3EEWe3ZqJsUTPLo1ONTakI+q6c45K9bDfdH/OokWw3o/a3f3PT4Pw/9KO7K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEkZCG2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEkZCG2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD527C4CEC5;
	Tue, 17 Sep 2024 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726588981;
	bh=ut7+hKu9XXGBX1hORm85Odfx/e7qFN4ndLnDPCa+X3I=;
	h=From:Date:Subject:To:Cc:From;
	b=eEkZCG2/JXhLepF4DxvWOELqtyz8KKdBisdG/oIgyZjg3AorUdC2lyDZyovU9khrZ
	 En59hN7RSvuBgIVFC++IXWyoaV4B41yF4/v8SueS9hmN5PJaAZrr5xGPxZ2IYYuSUX
	 MphyS51iBk+7QCQSnwHLWtQqJgQe5iCsdgQ/E37p1IvSCrt4puhToAfVMkbklu+Hjb
	 +UhbMlNlWXHgLEm34PGuVRxVKePu6G9S578iFHYy4qPJ+hTePXv8GzDqRaEQv7EN9D
	 Kc18+ytt6NB+ZmAY7OCZbJ9oTjvcOTpgIhFSw6A50bXkqCmgPb71Hpu/Me/qsNQ7S6
	 E5I74NzxuTkhw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 17 Sep 2024 09:02:53 -0700
Subject: [PATCH v3] x86/resctrl: Annotate get_mem_config() functions as
 __init
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org>
X-B4-Tracking: v=1; b=H4sIACyo6WYC/5WPyw6CMBQFf8V0bU1f1OrK/zCGFLzAjVBM2zQYw
 r9b2Bh3upyzmMmZSQCPEMh5NxMPCQOOLoPc70jdWdcCxXtmIphQzAhBJ6OphxDr6HvaQiwHGMp
 6dA22JboIPUWHkUrbMGELLlllSZY9PTQ4baHrLXOHIY7+tXUTX9e/E4lTTk3FrDbWHCW3lwd4B
 /1h9C1ZG0l8vCcuf/aK7K0aVWlV5BNKf3mXZXkDa3ybMzUBAAA=
X-Change-ID: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba
To: Fenghua Yu <fenghua.yu@intel.com>, 
 Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2944; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ut7+hKu9XXGBX1hORm85Odfx/e7qFN4ndLnDPCa+X3I=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkvV5iEL/jct1WmlslIdFNntfkU+Qufn16e0lWzjI81R
 azd2epqRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAbjJDxkZNsR9j3tqxOrwktm6
 5DKb8GSpK98OfnZIu3GOT+15nsF+NkaGX4qvpletEHxaN93heuZd5QkTohLvKjkv4chZX3yH8Xw
 vPwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent LLVM change [1] that deduces __cold on functions that
only call cold code (such as __init functions), there is a section
mismatch warning from __get_mem_config_intel(), which got moved to
.text.unlikely. as a result of that optimization:

  WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)

Mark __get_mem_config_intel() as __init as well since it is only called
from __init code, which clears up the warning.

While __rdt_get_mem_config_amd() does not exhibit a warning because it
does not call any __init code, it is a similar function that is only
called from __init code like __get_mem_config_intel(), so mark it __init
as well to keep the code symmetrical.

Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v3:
- Adjust subject to add () before get_mem_config to highlight it as part
  of a function (Reinette).
- Carry forward Reinette's Reviewed-by.
- Link to v2: https://lore.kernel.org/r/20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org

Changes in v2:
- Move position of __init within definition of __get_mem_config_intel()
  to better match coding style guidelines (Reinette).
- Apply __init to __rdt_get_mem_config_amd(), as it has the same issue
  by inspection (Reinette). Adjust commit message to reflect this
  change.
- Link to v1: https://lore.kernel.org/r/20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org
---
 arch/x86/kernel/cpu/resctrl/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1930fce9dfe96d5c323cb9000fb06149916a5a3c..59961618a02374a5b1639baa7034d05867884640 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -199,7 +199,7 @@ static inline bool rdt_get_mb_table(struct rdt_resource *r)
 	return false;
 }
 
-static bool __get_mem_config_intel(struct rdt_resource *r)
+static __init bool __get_mem_config_intel(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;
@@ -233,7 +233,7 @@ static bool __get_mem_config_intel(struct rdt_resource *r)
 	return true;
 }
 
-static bool __rdt_get_mem_config_amd(struct rdt_resource *r)
+static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	u32 eax, ebx, ecx, edx, subleaf;

---
base-commit: 7424fc6b86c8980a87169e005f5cd4438d18efe6
change-id: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

