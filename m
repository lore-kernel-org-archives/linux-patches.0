Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D136A36A;
	Sat, 12 Sep 2026 09:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206624; cv=none; b=ILJrBvAd5wi14Ma/TnIG+JAAmUO48TNXyA0oQ2lx6p/KEsEgNJGMMC4erMiLxkJ5xH5+mXhhHtjV8BFG5K08TudGCfdmyvOtYoeuaqylUaR0S+UAEBSLo2BDVIHIzX8i7rxy+Qk6Ama1mi/OvTUGyd9/RRaWw5o5dZ+6Bjzgvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206624; c=relaxed/simple;
	bh=27K8mKXq5QOthES8FBHXuWtkabPDhOPwTTO9PX9Nbts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFOHKWi1Ya1/TilHWXbSRS9h7jDB9ZmRL15RGUMJH1XCEroClTl8PX7b9RcqEIoV2pLNFr4ssn5jbxsrDRdmE9y5meT/0rZuTtgA9MaxtQ5O1Q8O7K+vK+Gh/2wD7h4v2FkvvaPTy7oJ2M2ouZfYKjx5cpzyo3YVSoSrZOXrQ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHS9gyQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHS9gyQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14A51F000FF;
	Sat, 12 Sep 2026 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206623;
	bh=T5biK4c9Zl0NFDAQRUujJZn+VGFpuoNQT0GIDSus748=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHS9gyQOmsHvkhxMIE1fHUxz5td7AfY96V6QsxyKm5Vo0cIVSsy5ZuSzrtlS6YW73
	 r9ysDXGiZJdIv4+DOW8YZhIi54PUWU+E4soULo9ZEWo5xCvyDJ2c5QLoNOsEwxMkz5
	 nZ8thsrW+ydMfTfxIRQOZaltDO6s+FSnivDOw7ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <ptesarik@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0246/1518] x86/tsx: Make tsx_ctrl_state static
Date: Sat, 12 Sep 2026 08:40:15 +0200
Message-ID: <20260912065629.045840878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <ptesarik@suse.com>

[ Upstream commit f018fca8f90bc383fefd97e3b2db03ea612ac789 ]

Move all definitions related to tsx_ctrl_state to tsx.c. They are
never referenced outside this file.

No functional change.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/all/cover.1758906115.git.ptesarik@suse.com
Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cpu.h | 9 ---------
 arch/x86/kernel/cpu/tsx.c | 9 ++++++++-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 92032422a8298..dca2d5845e427 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -42,15 +42,6 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
 #ifdef CONFIG_CPU_SUP_INTEL
-enum tsx_ctrl_states {
-	TSX_CTRL_ENABLE,
-	TSX_CTRL_DISABLE,
-	TSX_CTRL_RTM_ALWAYS_ABORT,
-	TSX_CTRL_NOT_SUPPORTED,
-};
-
-extern __ro_after_init enum tsx_ctrl_states tsx_ctrl_state;
-
 extern void __init tsx_init(void);
 void tsx_ap_init(void);
 void intel_unlock_cpuid_leafs(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 49782724a9430..8be08ece22148 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -19,7 +19,14 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "tsx: " fmt
 
-enum tsx_ctrl_states tsx_ctrl_state __ro_after_init = TSX_CTRL_NOT_SUPPORTED;
+enum tsx_ctrl_states {
+	TSX_CTRL_ENABLE,
+	TSX_CTRL_DISABLE,
+	TSX_CTRL_RTM_ALWAYS_ABORT,
+	TSX_CTRL_NOT_SUPPORTED,
+};
+
+static enum tsx_ctrl_states tsx_ctrl_state __ro_after_init = TSX_CTRL_NOT_SUPPORTED;
 
 static void tsx_disable(void)
 {
-- 
2.53.0



