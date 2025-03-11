Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF91825E818;
	Tue, 11 Mar 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706814; cv=none; b=C7PH1ELDwh4We6HznF1jYYogLrTeubKLOcEmP1UjC03iqp3DydVqICPU30sLFqQ7mUVZyG7tZkG4MkWsFBWwWK1LVNLd66doeUKJyJQ67wlEJlhua5UahVMeG7OxDPACdkBxiJoaPNUEHcdq+BZkTvB832OshASOCdHHLRRqMG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706814; c=relaxed/simple;
	bh=cMmaC/pfuFQtInEjnkWRJqPf/w2J9OCi7nGVQfdtuHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5wB71Cqnai2PAGfGVzLXE/qyCk7Is9EkSYU6zB97nft7esFv0Q5X42uq3SJJG0haTh8o1WfBPIj2KuSJXhgGkYmGvzI4XKmmCfTLchCCABW4OmhI8ptgCqKRd8XqkeLjDIcOevQxX1vddMYWFRfL5v3SRlbctrgiPCDZAB2Bus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqkoc7cW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqkoc7cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F17C4CEE9;
	Tue, 11 Mar 2025 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706814;
	bh=cMmaC/pfuFQtInEjnkWRJqPf/w2J9OCi7nGVQfdtuHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqkoc7cWwtzw+iqYnUjY+e3NHMEdgrl+8iCIiNAnzbUn71tb9ygpoVoZ4wE5elRGE
	 Sfvpfl+9vSl/RNdcpwURP0AMF3WPhO1dPbe9lu9wzydk9sGz6aD/hZvLNoObmSX9g5
	 EQMKn8csdy2i0eCpaXqWg3zMatF/pxo5GFKBUb2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 146/462] x86/mm: Dont disable PCID when INVLPG has been fixed by microcode
Date: Tue, 11 Mar 2025 15:56:52 +0100
Message-ID: <20250311145804.120385209@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/mm/init.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -258,28 +258,33 @@ static void __init probe_page_size_mask(
 }
 
 /*
- * INVLPG may not properly flush Global entries
- * on these CPUs when PCIDs are enabled.
+ * INVLPG may not properly flush Global entries on
+ * these CPUs.  New microcode fixes the issue.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,      0),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,    0),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,    0),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,     0),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,   0),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,   0),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,      0x2e),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,    0x42c),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,    0x11),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,     0x118),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,   0x4117),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,   0x2e),
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


