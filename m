Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBA515575F;
	Fri, 13 Sep 2024 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726270043; cv=none; b=JJaw11v/gBi34wxI3hr9q7iAkSaXrWC8l6YZ+jdGxL/KDoua3zz/ngHYtdbA91/+M1ZTYnxthSpyy7HXr3h0kWXItolIMziA4c945fAwNaeh/QkxI6TZ4uyWG0cfd6OtfXmvRChl0O9EMb2tGqCjHoT/l+MMJvCV4g3mcIntX5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726270043; c=relaxed/simple;
	bh=afGcFBINdDDu7aR6dn6Z/IY+fQ1ixrLHuQDmeNf89R4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=L1BSNkGAyMbWZLyzva4cqatoZ/n3H8k0671AP8iZHSDeuVir0/5T10KxrjH6kFnc+mgA8GscTiUYQJsgQicO41eYfJadHaLSEMEnSeYpbRgB9lmAb0m/rRgwVdkrG5pDcv6VsFgGAN7maF97Vwra+xWN1jAJuK7iKG/F3/ky7OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OD7+SdTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OD7+SdTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CA1C4CEC0;
	Fri, 13 Sep 2024 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726270043;
	bh=afGcFBINdDDu7aR6dn6Z/IY+fQ1ixrLHuQDmeNf89R4=;
	h=From:Date:Subject:To:Cc:From;
	b=OD7+SdTHbIVPrVUOS8ooB7KEv1KD3Agbn2iGe9LlEYXaf7s6CQA/jPst8P0zgrO7a
	 Fjvbd6MkHNrjGXfgbuZcY3VnK5uDofSAKq3zFfeBhvyZ/BKXxNdut4ezuPofcfrirH
	 sazT6sMnqR6YftBjrrpdABOvLdqNHkVjQfgQljgvTE6Y3q1VtZZpGSlnA0wRoiFt4F
	 jDHSY8JGfpO7SDEVd4/Q4OpNDc4j1+7QpG2ivtZQplQSLpUaQ1ot+DslD2yoCjytoX
	 MjvQBIDAX1C6gf42jzxlnkzm6aYMiAY8PIUkryXGFYbRC+wrm+vv5n9Mym3+kMMn4Y
	 SXds8KX1zn3mA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 13 Sep 2024 16:27:13 -0700
Subject: [PATCH v2] x86/resctrl: Annotate get_mem_config functions as
 __init
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFDK5GYC/5XNQQ6CMBCF4auQrh3TFsXGFfcwhBQcykRozbQhG
 MLdrdzA5f8W79tERCaM4l5sgnGhSMHn0KdC9KP1DoGeuYWW+iKN1rCaChhj6hNP4DC1M85tH/x
 AriWfcALylKC0g9T2qkrZWZHP3owDrQf0aHKPFFPgz+Eu6rf+TSwKFJhO2spYcyuVrV/IHqdzY
 Ceafd+/1U+bC90AAAA=
X-Change-ID: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba
To: Fenghua Yu <fenghua.yu@intel.com>, 
 Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=nathan@kernel.org;
 h=from:subject:message-id; bh=afGcFBINdDDu7aR6dn6Z/IY+fQ1ixrLHuQDmeNf89R4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGlPTkUdS9gQmy4iknqiIHyj+pQylxWOP06/DNYp4f/j6
 8T8+n1pRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIujkM/2xuh8W/OP3A04Cr
 UvN/hucX/Yy5fZJbFd776hlPL1+YFcLwPzEv+t/x66vOm/XNP/OQ988XW8ETs5a9z3r4YdGFqQe
 n8DABAA==
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
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
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

