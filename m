Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A3212B72;
	Fri, 23 Aug 2024 00:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372293; cv=none; b=nVsxGSN44/WfSfz7sYDp7WVkmdYDS9eCzOHLJ5ExA9rVWd6rKrmgnVcJdacuObdFSK7KpKOffuBoQGmKvhihzfUN/YfXoDNhJl4sOBodYs/Qo7LoF6XtReIfPSZ/UjMNvRsiQxBUi2puLE9Ci8W3mIQmtmqK/wsgjAsAY6AYWeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372293; c=relaxed/simple;
	bh=jsws4rS7MzgJKmjyves2GO3uHKbbhJfJ76ZtAXIwBSs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gmcqDskEMsYWUaBMU3iG2ZrcmWpcT4dl0kPLnvrWHZVbP6mD/+bAzzB2zUDbzDThHzIANv+gyBm0ZEdGKx3ELooHhVNaL0+JlVh+/GQw2tdZ+mffSEMMdfMyjhBBF1j7N9ousq0FtlLjMj+iBPDG2xVmlA4JUB0KJzfgWvQMShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su2uNQZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su2uNQZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206D5C32782;
	Fri, 23 Aug 2024 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372293;
	bh=jsws4rS7MzgJKmjyves2GO3uHKbbhJfJ76ZtAXIwBSs=;
	h=From:Date:Subject:To:Cc:From;
	b=Su2uNQZInIS/UMi2YYqbVXI4QKcBcd+ZTiJvw5xjyRtEQwbw2XMF+LgUzGb8gJDqq
	 z5o9ki13qQ6k1cGfCz/Jl9LEuFJowVM7bcBXyAs0mp/4t3fufJyUdouzKwSurqcBNo
	 aqWk/OkyP02vRpXbt89viI1XuFZZh9DWqBdWle+Qnxq/NbXORkiShtHMOksXhX/mw6
	 36cuIa9E2b88akE8tKupguG+h8E6O6Tc+KEpHugs4Z4HAK+KMFTkb0GZcszaD1kV8X
	 mDNR/PLO78MK41xeqNnnpSFUxIkNj4vAMTNUIPd9H4htUPiOUXMowcZN/FdwOcBf4U
	 2oeDLfmKAze3g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 22 Aug 2024 17:18:08 -0700
Subject: [PATCH] x86/cpu_entry_area: Annotate
 percpu_setup_exception_stacks() as __init
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-x86-percpu_setup_exception_stacks-init-v1-1-57c5921b8209@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD/Vx2YC/x2N0QrCMAwAf2Xk2UCt6xz+ikjZYqZBqKHppDD27
 5Y93sPdbWCchQ1u3QaZf2LyTQ3Opw7oPaUXozwbg3e+d6P3WMcBlTPpGo3LqpErsZamRSsTfQw
 lScELz2GYw+KugaDFNPMi9RjdH/v+B/ebwF94AAAA
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560; i=nathan@kernel.org;
 h=from:subject:message-id; bh=jsws4rS7MzgJKmjyves2GO3uHKbbhJfJ76ZtAXIwBSs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnHr7ro5QZUuR8xXZXd/bPitUH+rsz7s3TF/aZPf3/nq
 NmeBVYuHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAizZsYGdbKL7m6SI5bNbvF
 UMfCZFX4vS/adv+PL/787cbs/Udu3RZnZLhxpo3zxMaH3sFPQsS3x3/2tOh6uOpmRv1J91N91RN
 OrmMHAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent LLVM change [1] that deduces __cold on functions that
only call cold code (such as __init functions), there is a section
mismatch warning from percpu_setup_exception_stacks(), which got moved
to .text.unlikely. as a result of that optimization:

  WARNING: modpost: vmlinux: section mismatch in reference: percpu_setup_exception_stacks+0x3a (section: .text.unlikely.) -> cea_map_percpu_pages (section: .init.text)

Drop the inline keyword (which does not guarantee inlining) and replace
it with __init, as percpu_setup_exception_stacks() is only called from
__init code, which clears up the warning.

Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/mm/cpu_entry_area.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index e91500a80963..575f863f3c75 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -164,7 +164,7 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	}
 }
 #else
-static inline void percpu_setup_exception_stacks(unsigned int cpu)
+static void __init percpu_setup_exception_stacks(unsigned int cpu)
 {
 	struct cpu_entry_area *cea = get_cpu_entry_area(cpu);
 

---
base-commit: d4245fd4a62931aebd1c5e6b7b6f51b6ef7ad087
change-id: 20240822-x86-percpu_setup_exception_stacks-init-3eb56b5f075c

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

