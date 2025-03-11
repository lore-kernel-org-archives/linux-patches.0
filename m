Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CFF25E806;
	Tue, 11 Mar 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705614; cv=none; b=ZRMQ5CNEmms5nAewlwDhpo7DQJMXmfnvnHZQWf4owpvZDJdaRg6MrNQIpOHDRTO+rHtxqfc7EVRWLpvbm3p6Q90WKjo0qs51GsxvfmoRTxobwJ70nINGgxXRbp3yYLP3Ng0sOhF4O8YVNtFS4UuJ1ZuNfnkpXrE3jvnzrlL7Frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705614; c=relaxed/simple;
	bh=xGERKXDn2RgYdaxTU0rkWKVjHRUdiSYKZWLCiiE9qSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It8pX2/EBS+BrP2ZJNzc9sr8GLK6QwflLAClJmirjVHQq5gPGzLHy+OD9F1HTLVrRTfQJRODbZ8ToomXU8sw6BWqHbe6KREMlkjzR5b+E8qgmA2og16ASFA5bzbfvR01OADtqTevQzLhN7LNiCT6wfYtEOjzbAhB8877XzLfca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7vyUvcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7vyUvcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC06FC4CEEA;
	Tue, 11 Mar 2025 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705614;
	bh=xGERKXDn2RgYdaxTU0rkWKVjHRUdiSYKZWLCiiE9qSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7vyUvcCGWv7SuOHJAJmKp3PVsVFm79OaBo5X9jCmMw5opeZGrj1j5KYWGom0advn
	 ag3d2Wg+GTh49q0GDVxJLmhCX+RmSKUSw8vgYyi/4LhSU2Olk7c34GV4hw1VqYKKU1
	 Ub+Utb6nKoGqa9Z6rBHODOdJj11s6fPiW5NGPJHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.4 095/328] x86/mm: Dont disable PCID when INVLPG has been fixed by microcode
Date: Tue, 11 Mar 2025 15:57:45 +0100
Message-ID: <20250311145718.668295448@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit f24f669d03f884a6ef95cca84317d0f329e93961 upstream.

Per the "Processor Specification Update" documentations referred by
the intel-microcode-20240312 release note, this microcode release has
fixed the issue for all affected models.

So don't disable PCID if the microcode is new enough.  The precise
minimum microcode revision fixing the issue was provided by Pawan
Intel.

[ dhansen: comment and changelog tweaks ]

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Link: https://lore.kernel.org/all/168436059559.404.13934972543631851306.tip-bot2@tip-bot2/
Link: https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/microcode-20240312
Link: https://cdrdv2.intel.com/v1/dl/getContent/740518 # RPL042, rev. 13
Link: https://cdrdv2.intel.com/v1/dl/getContent/682436 # ADL063, rev. 24
Link: https://lore.kernel.org/all/20240325231300.qrltbzf6twm43ftb@desk/
Link: https://lore.kernel.org/all/20240522020625.69418-1-xry111%40xry111.site
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -211,33 +211,39 @@ static void __init probe_page_size_mask(
 	}
 }
 
-#define INTEL_MATCH(_model) { .vendor  = X86_VENDOR_INTEL,	\
-			      .family  = 6,			\
-			      .model = _model,			\
-			    }
+#define INTEL_MATCH(_model, ucode) { .vendor  = X86_VENDOR_INTEL,	\
+				     .family  = 6,			\
+				     .model = _model,			\
+				     .driver_data = ucode,		\
+				   }
 /*
- * INVLPG may not properly flush Global entries
- * on these CPUs when PCIDs are enabled.
+ * INVLPG may not properly flush Global entries on
+ * these CPUs.  New microcode fixes the issue.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE   ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_N ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE  ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S),
+	INTEL_MATCH(INTEL_FAM6_ALDERLAKE,	0x2e),
+	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L,	0x42c),
+	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_N,	0x11),
+	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE,	0x118),
+	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P,	0x4117),
+	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S,	0x2e),
 	{}
 };
 
 static void setup_pcid(void)
 {
+	const struct x86_cpu_id *invlpg_miss_match;
+
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
 	if (!boot_cpu_has(X86_FEATURE_PCID))
 		return;
 
-	if (x86_match_cpu(invlpg_miss_ids)) {
+	invlpg_miss_match = x86_match_cpu(invlpg_miss_ids);
+
+	if (invlpg_miss_match &&
+	    boot_cpu_data.microcode < invlpg_miss_match->driver_data) {
 		pr_info("Incomplete global flushes, disabling PCID");
 		setup_clear_cpu_cap(X86_FEATURE_PCID);
 		return;


