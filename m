Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044080;
	b=qEmCfvyKlKPntVh6yBNhDW2IyyHs7h/4dnPP8SbwPZK9brJikFz/41YK5T4IgxH5jL5F
	 QwDUimYmg8kfbDNoLEFKB36LVMdCud8Ik/oegg21VlSRyuN2SC03PkI32SUksrKOCXruD
	 XguwJBHsWfT+Q+Rz8ofQBtKE+7MrsPaPMgRsAq9lMOQLiXBni4PzlRzUjIiAUki5i6r1I
	 7b5dSWT38vOoVxFDnqL8/ECsKHiavcn6eCY7pDMiArwyAjWfIRusb7eo8MYjRm0BsesUU
	 kwaihleVsQRYmHRuRIyS3fbcQv7DsgDaKnvx9YVgR0w7eONk49rADiCRR/uzeqn+HVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sinaxi9NbL//TdyHn4rxOJDz2+4bRURMs0G3FjR0uj4=;
	b=116oNUJwoL419fkO1BgtFZacb5xu7ubKgEVOFyUATYc4eqvU6UrXO1w66bM5M2aB+X+G
	 rgq11m3cxLvd+hMsSR/b6kBcWlXCPiT+AsVLitABfrJxCgaK9I//b85gM1Xc8PiSDEnY6
	 9jjtrzdwhIVSxZzcNJDJIXk14N8LAM4VVhpgO64ZflyovHyZepytjqkLQNrau23Ih1JwJ
	 MBTzqJZHIpJ3+NaMtGLIMTtwSyRFmDqSdu2WF+W45XjMoAmT7jCkj1pQpqPgZlqFiBYG9
	 jpltat0oPwNPKMzB32v01MCt8OkX+OwY3RAMPfhNxs8i/51XzaZGx16le9oBRIS0dCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6wfDpkw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AEB606A325;
	Wed, 18 Nov 2026 23:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6wfDpkw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115351F000C4;
	Wed, 18 Nov 2026 23:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044080;
	bh=Sinaxi9NbL//TdyHn4rxOJDz2+4bRURMs0G3FjR0uj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6wfDpkwed4gOkljEusVORobzzcqOISwt56usG4h8jged5hFJxifTpF/xj1HCHk/d
	 xm5ghxlwZiTw+toKIpo6cF2X7UcEIkgvd9UAEaRH+Gx3XiGdKo2FY7AX0pZX/i8kOk
	 lL3inm6gX7LBnuTKFJkKbr3hQtDl63t5g47ZnUP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0440/2857] x86/microcode/intel: Reject problematic loading on Granite Rapids systems
Date: Wed, 18 Nov 2026 15:24:34 +0100
Message-ID: <20261118150217.216864319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Backport hooks the Granite Rapids revision-jump check into the older loader's extra paths (early AP load, patch cache lookup, late apply with real-revision refresh) and uses family/model checks instead of IFM(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/intel.c | 55 ++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 1def66118b03c..07efc44d227cc 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -261,6 +261,23 @@ static int microcode_sanity_check(void *mc, int print_err)
 	return 0;
 }
 
+static bool revision_is_safe(struct cpu_signature *sig, u32 rev)
+{
+	/*
+	 * Erratum GNR98 can cause #MCs if "jumping over" revision 0x1000405.
+	 * Avoid the jumps.
+	 */
+	if (x86_family(sig->sig) == 6 &&
+	    x86_model(sig->sig) == INTEL_FAM6_GRANITERAPIDS_X &&
+	    x86_stepping(sig->sig) == 1 &&
+	    sig->pf & 0x95 &&
+	    sig->rev < 0x1000405 &&
+	    rev > 0x1000405)
+		return false;
+
+	return true;
+}
+
 /*
  * Get microcode matching with BSP's model. Only CPUs with the same model as
  * BSP can stay in the platform.
@@ -292,8 +309,19 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 			continue;
 		}
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header->rev)) {
+			data += mc_size;
+			continue;
+		}
+
 		if (save) {
-			save_microcode_patch(uci, data, mc_size);
+			/*
+			 * Only cache what the BSP could have loaded: a newer
+			 * revision was rejected as unsafe and must not be
+			 * applied on resume or hotplug.
+			 */
+			if (mc_header->rev <= uci->cpu_sig.rev)
+				save_microcode_patch(uci, data, mc_size);
 			goto next;
 		}
 
@@ -629,6 +657,11 @@ void load_ucode_intel_ap(void)
 		*iup = patch;
 	}
 
+	intel_cpu_collect_info(&uci);
+
+	if (!revision_is_safe(&uci.cpu_sig, (*iup)->hdr.rev))
+		return;
+
 	uci.mc = *iup;
 
 	apply_microcode_early(&uci, true);
@@ -646,6 +679,9 @@ static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)
 		if (phdr->rev <= uci->cpu_sig.rev)
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, phdr->rev))
+			continue;
+
 		if (!find_matching_signature(phdr,
 					     uci->cpu_sig.sig,
 					     uci->cpu_sig.pf))
@@ -706,6 +742,7 @@ static enum ucode_state apply_microcode_intel(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	bool bsp = c->cpu_index == boot_cpu_data.cpu_index;
 	struct microcode_intel *mc;
+	struct cpu_signature sig;
 	enum ucode_state ret;
 	static int prev_rev;
 	u32 rev;
@@ -733,6 +770,17 @@ static enum ucode_state apply_microcode_intel(int cpu)
 		goto out;
 	}
 
+	/*
+	 * uci->cpu_sig.rev can be stale, e.g. on resume. Check against the
+	 * revision the CPU is really running.
+	 */
+	sig = uci->cpu_sig;
+	sig.rev = rev;
+	if (!revision_is_safe(&sig, mc->hdr.rev)) {
+		ret = UCODE_NFOUND;
+		goto out;
+	}
+
 	/*
 	 * Writeback and invalidate caches before updating microcode to avoid
 	 * internal issues depending on what the microcode is updating.
@@ -818,6 +866,11 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 			break;
 		}
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header.rev)) {
+			pr_err_once("Erratum GNR98: skipping revision 0x%x.\n", mc_header.rev);
+			continue;
+		}
+
 		csig = uci->cpu_sig.sig;
 		cpf = uci->cpu_sig.pf;
 		if (has_newer_microcode(mc, csig, cpf, new_rev)) {
-- 
2.53.0



