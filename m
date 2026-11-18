Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034920;
	b=gAYv8f/5FsZ9hoJ3utFupPnAI95yZ1uXG4Ev1YISsTTDOFua1CeZCrXjXb43KaPlI1k+
	 FhKxQ03b92huVqu8cudbIJPtHegclN2R+97vxiib68J/uH/cC4x/eGH0lpzCdUNXP6ESk
	 IvTJWq3T6f0OaeRUeiR2z8iLY6IRT3xAz8l0Nw0ExmsEwmgXg0BCyQvdu8IdkkEppqKw/
	 KTEMm+QXw2wmAEVv3g1LUuJcUm6GKAWprUoEwF9OhlbPJ9SO6Ny0VBF32W9K2u2OMI4pv
	 ntFeC6f7pZTG2mrUq3tQkZEOEVXk8WO2oWyn3qIwFJ2nKfrFlPkMS6W4I0Ek+fOWIZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKkI2KjiQ2ZaCmunU634TCL7Nf1I/L/zlT90PGnVXCE=;
	b=MNYODHiofHula4WRTYvrOhPASKvTvmVKYqjMQMTgLWLpZlL5+7H9TR781eyBwyWH8VUK
	 yOPN3mfFLX4O6yKcHvVR8nCGMkia0oS+whN8+NpNnML270B6OB1aJ1EniuWST/qYzujJ2
	 V37BQeTSnT2ftECfpce5e9moE1eYajCLdTUrlGxBUkzgdVHu5TqKVZeM++wiBTYueilir
	 Z+DIZcTsNJOb2dtL2qtQcqSQhzOdVgq4sFiQcjx8dZwEFL1roIzJe7TpDwof2FpUbIGGQ
	 6JHF7EvXc5OjhwHahYiMq4nFEXFFPq9+5q15tNuxUe8eG2s9ripZalEuccFAesF025w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SM1bB7Nz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9FD606A320;
	Wed, 18 Nov 2026 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SM1bB7Nz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD01F000C4;
	Wed, 18 Nov 2026 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034920;
	bh=qKkI2KjiQ2ZaCmunU634TCL7Nf1I/L/zlT90PGnVXCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SM1bB7NzhUEgnCUUgT00/vRFuJw20iYUiKcIE04oI1CkWHf9syIOdLIChOQTB9Fxb
	 ytVhBz0lQaNTQv2/2EbC9CmAqVhE7U/aOwKGQRZ8/k2VGtUx4tw+PXkWTwXt+5EblC
	 Xv9iZ2l+PbwV9zr1S/jhDLA4il4cSUwcfz+uwBIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0491/3318] x86/microcode/intel: Reject problematic loading on Granite Rapids systems
Date: Wed, 18 Nov 2026 15:18:33 +0100
Message-ID: <20261118150331.728310948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chang S. Bae <chang.seok.bae@intel.com>

[ Upstream commit e7d3e2f46dd5a69046e6d95a0f189155a5516b93 ]

Microcode updates can usually jump revisions. However, there is an erratum on
Granite Rapids systems. If they "jump over" revision 0x1000405, they result in
an #MC. Avoid it.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916225939.1144524-1-chang.seok.bae@intel.com
[ sashal: Dropped the minrev-based context in parse_microcode_blobs() and placed the new check after the signature match, and added an include of asm/cpu_device_id.h so IFM() builds. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/intel.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 4e5a71796fbdb..433b54f56ec29 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -21,6 +21,7 @@
 #include <linux/uio.h>
 #include <linux/mm.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
@@ -257,6 +258,26 @@ static void save_microcode_patch(struct microcode_intel *patch)
 		pr_err("Unable to allocate microcode memory size: %u\n", size);
 }
 
+static bool revision_is_safe(struct cpu_signature *sig, u32 rev)
+{
+	u32 vfm = IFM(x86_family(sig->sig), x86_model(sig->sig));
+
+	/*
+	 * Erratum GNR98 can cause #MCs if "jumping over" revision 0x1000405.
+	 * Avoid the jumps.
+	 */
+	if (vfm == INTEL_GRANITERAPIDS_X &&
+	    x86_stepping(sig->sig) == 1 &&
+	    sig->pf & 0x95 &&
+	    sig->rev < 0x1000405 &&
+	    rev > 0x1000405) {
+		pr_err_once("Erratum GNR98: skipping revision 0x%x.\n", rev);
+		return false;
+	}
+
+	return true;
+}
+
 /* Scan blob for microcode matching the boot CPUs family, model, stepping */
 static __init struct microcode_intel *scan_microcode(void *data, size_t size,
 						     struct ucode_cpu_info *uci,
@@ -278,6 +299,9 @@ static __init struct microcode_intel *scan_microcode(void *data, size_t size,
 		if (!intel_find_matching_signature(data, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header->rev))
+			continue;
+
 		/*
 		 * For saving the early microcode, find the matching revision which
 		 * was loaded on the BSP.
@@ -516,6 +540,9 @@ static enum ucode_state parse_microcode_blobs(int cpu, struct iov_iter *iter)
 		if (!intel_find_matching_signature(mc, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header.rev))
+			continue;
+
 		kvfree(new_mc);
 		cur_rev = mc_header.rev;
 		new_mc  = mc;
-- 
2.53.0



