Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08BB5233
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 22:06:07 +0000 (UTC)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5BCDB1EC04EE
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 23:06:05 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Mon, 9 Jan 2023 23:06:05 +0100
Resent-Message-ID: <Y7yPzTEiXtwgZQzt@zn.tnic>
Resent-To: patches <patches@lists.linux.dev>
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Mon, 09 Jan 2023 18:26:37 +0100
X-Sieve: CMU Sieve 2.4
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 755F81EC03B3
	for <bp@alien8.de>; Mon,  9 Jan 2023 18:26:34 +0100 (CET)
Received: by mail-pj1-x1049.google.com with SMTP id pi14-20020a17090b1e4e00b0021d20da7a51so7598500pjb.2
        for <bp@alien8.de>; Mon, 09 Jan 2023 09:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UAsri5xsDhrkkwk0ZRJw8bK2dMjpxZkLPzpH0GOBTv8=;
        b=Yf2p8qyLQ/lAak0v/Hl8yNihzlGeIjV57QySaMxsTwOP1+2dZaBGwEzylD2Nfabt1w
         sNN90gZxDL+CSrEgyywjZlvbPbMpRdrOe8g+VdsTEBmTTJpQ58S4fsmDvLg08+Z1TNfX
         3r8yPoA5wiY7ue3mdVqvXxMGI43E1/Y5d7Sz2Xmo+oYmh/C0rNu1sWBdUpkkNuVjbI/J
         1OS0F7iNddjKETuy6vsRG6ZSiPOO4E70h6eiNXOwkTBC7s38R5BuXcCAbCfFSVhhb9E6
         8GEJIIP9/ypmzW6VsjwG5rb61A1dSCxCh8nIuAr1ato8lGdC+Z55z28Q/8djBs6mdnUe
         ZNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UAsri5xsDhrkkwk0ZRJw8bK2dMjpxZkLPzpH0GOBTv8=;
        b=0CBT0zonz3Rh/y+9aRVfJbatADotCQMJMzeN6pA0b9TKAmOMIAXjN3+Rrm7EjvKMSQ
         mGmlvXvjK0KdYQrIEzDp7lt/wvJSoUUFjp1PTZS1ICZ7Z4F7Hb2sFAm4VD1aB/C+5JUV
         Wp3TZTD/LeFDa9acQcjyWwzbhWslB7563MybFcKy9lraM0yS44Mkd8XUTt5F9hUYeBZN
         4jTi07fSEGnP92KLuX5SnT8MctYjT3860vkC/JX5iXLscRvJJ648iWXrkknPG3AyGlX/
         ZfiUF02usOR+1H6lafVttEPbxNH+ftFBhDc9KWpOP0lboB2tgSlWytSBP3Kw5ZGG+JDp
         7ElQ==
X-Gm-Message-State: AFqh2kp4FzNINSdrCTcDxDo+yxfyjlPVHQ7/jB2rNNq2gvpTiZSBvPXY
	VLx/AxNoOrEQnm1yHQ6eiR5MrveD+3Fa3q4oxw==
X-Google-Smtp-Source: AMrXdXvwGtHpTf0lGXvxmFTCHO0NKVZntbUqQq+gJli/5fblPWaDaCVgsHJaqT9/Il22JGzs6nELcbn5OCmq3RDcOA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90b:34b:b0:225:ca12:dc2d with SMTP
 id fh11-20020a17090b034b00b00225ca12dc2dmr4021829pjb.192.1673285192934; Mon,
 09 Jan 2023 09:26:32 -0800 (PST)
Date: Mon,  9 Jan 2023 17:26:16 +0000
In-Reply-To: <20230109172618.560581-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230109172618.560581-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109172618.560581-3-dionnaglaze@google.com>
Subject: [PATCH v10 2/4] x86/sev: Change snp_guest_issue_request's fw_err
From: Dionna Glaze <dionnaglaze@google.com>
To: linux@vger.kernel.org, x86@kernel.org
Cc: Dionna Glaze <dionnaglaze@google.com>, Tom Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Venu Busireddy <venu.busireddy@oracle.com>, Michael Roth <michael.roth@amd.com>, 
	"Kirill A. Shutemov" <kirill@shutemov.name>, Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="UTF-8"
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=google.com header.s=20210112 header.b=Yf2p8qyL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (mail.skyhub.de: domain of 3SE68YwsKAvkejpoobhmb0fhpphmf.dpncqbmjfo9.ef@flex--dionnaglaze.bounces.google.com designates 2607:f8b0:4864:20::1049 as permitted sender) smtp.mailfrom=3SE68YwsKAvkejpoobhmb0fhpphmf.dpncqbmjfo9.ef@flex--dionnaglaze.bounces.google.com
X-Spamd-Bar: ------

The GHCB specification declares that the firmware error value for a
guest request will be stored in the lower 32 bits of EXIT_INFO_2.
The upper 32 bits are for the VMM's own error code. The fw_err argument
is thus a misnomer, and callers will need access to all 64 bits.

The type of unsigned long also causes problems, since sw_exit_info2 is
u64 (unsigned long long) vs the argument's previous unsigned long*.
The signature change requires the follow-up change to
drivers/virt/coco/sev-guest to use the new expected type in order to
compile.

The firmware might not even be called, so the call is bookended with
the no firmware call error and clearing the error.

Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venu Busireddy <venu.busireddy@oracle.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michael Sterritt <sterritt@google.com>

Fixes: d5af44dde546 ("x86/sev: Provide support for SNP guest request NAEs")
Reviewed-by: Tom Lendacky <Thomas.Lendacky@amd.com>
Reviewed-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/include/asm/sev.h |  4 ++--
 arch/x86/kernel/sev.c      | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ebc271bb6d8e..05de34d10d89 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -196,7 +196,7 @@ void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
+int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, u64 *exitinfo2);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -217,7 +217,7 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input,
-					  unsigned long *fw_err)
+					  u64 *exitinfo2)
 {
 	return -ENOTTY;
 }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..70b4cbd33c45 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -22,6 +22,7 @@
 #include <linux/efi.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/psp-sev.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -2175,7 +2176,7 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err)
+int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, u64 *exitinfo2)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2186,9 +2187,11 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (!fw_err)
+	if (!exitinfo2)
 		return -EINVAL;
 
+	*exitinfo2 = SEV_RET_NO_FW_CALL;
+
 	/*
 	 * __sev_get_ghcb() needs to run with IRQs disabled because it is using
 	 * a per-CPU GHCB.
@@ -2212,14 +2215,13 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 	if (ret)
 		goto e_put;
 
+	*exitinfo2 = ghcb->save.sw_exit_info_2;
 	if (ghcb->save.sw_exit_info_2) {
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
 		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN)
 			input->data_npages = ghcb_get_rbx(ghcb);
 
-		*fw_err = ghcb->save.sw_exit_info_2;
-
 		ret = -EIO;
 	}
 
-- 
2.39.0.314.g84b9a713c41-goog

