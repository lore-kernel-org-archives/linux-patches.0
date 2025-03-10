Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972C017A31A;
	Mon, 10 Mar 2025 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627844; cv=none; b=AWP+Zc2U3OBzen2FY0xxnxKCqa/a7gIq12leIOocvhgnk1mTyVV3M6PCKZYDjEwNq94lEdRE2T4Mk6FmIUh/ACK/G4qw9OANm4WpUwY2sFlcjduVP25yeH1gQWYiftnZt22umUsXcOX233XJJGKSEK3+Bg8aIpGlnlxXkJ3Sdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627844; c=relaxed/simple;
	bh=3oMOZ7+yO9G9DC+dSUMtmze/O96W8hLMiUvyav6auyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e55CqWyJTuHc7hctleyplJpXT/v7Bl11At47xKavXUGLrUcunPas6GkrYRyptsD3DRkBQT9+T5z47Day+hYRgla7T289U01HNATB466T/0koWf9E/myk2QOus+M4EGl9okk8VdyJ9S6EtNxfYk1MOtF5YPukgCgR53iJri+RXKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqyZcT64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqyZcT64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE83C4CEE5;
	Mon, 10 Mar 2025 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627844;
	bh=3oMOZ7+yO9G9DC+dSUMtmze/O96W8hLMiUvyav6auyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqyZcT644M9TELDSEYp+KCtIqvT7z87uWbMOrzjIOsbdLdNXFvvpOsPdyGcjMgtpL
	 A86gTVGoqFGcD1K9NyU+aD4vQvhWiehz/9myNNWmr12M+1MyHe9QGrKTZT/o+Nq9hg
	 kA+mlT/Rr558g3MW4Vu4ff6kucImIJmU38+pkoMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.12 269/269] x86/mm: Dont disable PCID when INVLPG has been fixed by microcode
Date: Mon, 10 Mar 2025 18:07:02 +0100
Message-ID: <20250310170508.508019517@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,28 +263,33 @@ static void __init probe_page_size_mask(
 }
 
 /*
- * INVLPG may not properly flush Global entries
- * on these CPUs when PCIDs are enabled.
+ * INVLPG may not properly flush Global entries on
+ * these CPUs.  New microcode fixes the issue.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	X86_MATCH_VFM(INTEL_ALDERLAKE,	    0),
-	X86_MATCH_VFM(INTEL_ALDERLAKE_L,    0),
-	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, 0),
-	X86_MATCH_VFM(INTEL_RAPTORLAKE,	    0),
-	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,   0),
-	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,   0),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,	    0x2e),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,    0x42c),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, 0x11),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,	    0x118),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,   0x4117),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,   0x2e),
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


