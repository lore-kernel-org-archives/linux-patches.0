Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3DA22D7A6;
	Mon, 10 Mar 2025 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628553; cv=none; b=Xd3PLnO1kssdWj/BTTGTbhrpR71iBqpcVtI1afjafOAJbub+5m80Wicvw4+Lis1YVHQriUvf5w7loaCVx53yt61aoF9bD6n0yw2Gx+lcQ5y7XpEz7wtkoc6oTmR4qSvMiSmj49MaYiczwCtFbOdbtB9QemfkPo/jjx4qiGnxo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628553; c=relaxed/simple;
	bh=sFUhukOp3igGTidZku8sPLnuZyHYoMg1Zfz+7xVOZSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqTrDvm0zFuvYcoqZTN7DDOimbR5gcz8JNsGefkFjJrbX9n7lIjc0dIV9/yWL8BGRb2CW2rhjcEvbvfScIaWmWh43l/V4jf3ZQDaiic/hPufBi5Pmjn01RlraWROOgm0//bIC0g7gyA8McS1BbSNVUpuWFJH+T7G2RI8YxioF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZprwCSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZprwCSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DC9C4CEE5;
	Mon, 10 Mar 2025 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628552;
	bh=sFUhukOp3igGTidZku8sPLnuZyHYoMg1Zfz+7xVOZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZprwCSS2UTG+a5OYK+B6NbVhpapSvLIArWgo1gNNa2v6HK1NvtZmzrCH//b0o0E/
	 azPzLxVEz/zi6aNEffVkiYTlUW+8rZqjjDiFxbwpttf456VMIZOeQioxQBjNBFVdNo
	 aoIpOTNSmNCBA5J8oo6KLRhT+X9NGRPN3uUm6Erg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.1 098/109] x86/mm: Dont disable PCID when INVLPG has been fixed by microcode
Date: Mon, 10 Mar 2025 18:07:22 +0100
Message-ID: <20250310170431.459252461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


