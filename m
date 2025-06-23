Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0281F7580;
	Mon, 23 Jun 2025 22:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716796; cv=none; b=CY9afLaa84Lrxr43o9ZuWlTLQV8LlZsNGmenfAo/Jw1ROsTcpdbMBopTLJxnS7L8uF8T/wrE/NaEJYCE+3iKaEsUbu2lolijdYZnz13In0f1Zem+v0xd9aFvxo/i5tvxKAOYJ9RBukJyMbD+006JFj7YLh2NbG2e9ztLlJ4hfR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716796; c=relaxed/simple;
	bh=XwVaDUe1ATspLoahMd0ZRKs/deUxhWmZEgUALPT043I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLzE/WH78m2DAUZ5NTv+aOrFZTgmi01m5/NqumJQqgUHYroCqRJWg+V2a1mD/sJhFICCEEWKavxdlwdHJuVqSkxadobGj1Z1oWVE15awAk14YUU5S7RsZDZsnMN1Epxr+4IWym5zdJ75M0MfD3Au+t7YmwDZpDvyGf3mpxbA/8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zimGTQxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zimGTQxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA954C4CEEA;
	Mon, 23 Jun 2025 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716796;
	bh=XwVaDUe1ATspLoahMd0ZRKs/deUxhWmZEgUALPT043I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zimGTQxXTnnjlz/MKhdeSRXXPFNf8QtVk/mEn75J0Lwc3Fi3Isgn9uiwn1ITx6JoI
	 p2ZR8773AT3e1QcUSGKhXpq4qSmBZ9zjfqlkfbR8H/tTP1XZUJLTfOEqR/BPhWF1Tj
	 ub984F7bQlLXKutCCV/3WuYOdHDKDBCEVkrzJAVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Song <liusong@linux.alibaba.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.15 393/411] arm64: spectre: increase parameters that can be used to turn off bhb mitigation individually
Date: Mon, 23 Jun 2025 15:08:57 +0200
Message-ID: <20250623130643.570935408@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Song <liusong@linux.alibaba.com>

[ Upstream commit 877ace9eab7de032f954533afd5d1ecd0cf62eaf ]

In our environment, it was found that the mitigation BHB has a great
impact on the benchmark performance. For example, in the lmbench test,
the "process fork && exit" test performance drops by 20%.
So it is necessary to have the ability to turn off the mitigation
individually through cmdline, thus avoiding having to compile the
kernel by adjusting the config.

Signed-off-by: Liu Song <liusong@linux.alibaba.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/1661514050-22263-1-git-send-email-liusong@linux.alibaba.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    5 +++++
 arch/arm64/kernel/proton-pack.c                 |   10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3105,6 +3105,7 @@
 					       spectre_bhi=off [X86]
 					       spectre_v2_user=off [X86]
 					       ssbd=force-off [ARM64]
+					       nospectre_bhb [ARM64]
 					       tsx_async_abort=off [X86]
 
 				Exceptions:
@@ -3526,6 +3527,10 @@
 			vulnerability. System may allow data leaks with this
 			option.
 
+	nospectre_bhb	[ARM64] Disable all mitigations for Spectre-BHB (branch
+			history injection) vulnerability. System may allow data leaks
+			with this option.
+
 	nospec_store_bypass_disable
 			[HW] Disable all mitigations for the Speculative Store Bypass vulnerability
 
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1023,6 +1023,14 @@ static void this_cpu_set_vectors(enum ar
 	isb();
 }
 
+static bool __read_mostly __nospectre_bhb;
+static int __init parse_spectre_bhb_param(char *str)
+{
+	__nospectre_bhb = true;
+	return 0;
+}
+early_param("nospectre_bhb", parse_spectre_bhb_param);
+
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 {
 	bp_hardening_cb_t cpu_cb;
@@ -1036,7 +1044,7 @@ void spectre_bhb_enable_mitigation(const
 		/* No point mitigating Spectre-BHB alone. */
 	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
 		pr_info_once("spectre-bhb mitigation disabled by compile time option\n");
-	} else if (cpu_mitigations_off()) {
+	} else if (cpu_mitigations_off() || __nospectre_bhb) {
 		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;


