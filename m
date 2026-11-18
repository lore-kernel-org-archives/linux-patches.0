Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039103;
	b=NnM7C/eofB+9TbOxRFDlrDIebfSP9E3fwKKXMCabST3IBgJUZmNyShZnoCM3iuqzgwhz
	 LmyB6O4/hgyzZLKj0ofVYi91gM8iMfOsvDJiINJlCkVZQadefsBRQ1CCpZ5RzwCIjOnap
	 3q3PYnUCjRfcoh6pz2HBxM3vxxUjBQtztaySQhqUXLZA1VJSlQvjGrTLa+cf09xHrq8QH
	 mCVtaUFaLdqQ/xOKe7hLm09zBjvNKguM7VHyYcFQJBlxW6cCIcOevAYJZwtkNqgD5LloN
	 AYHSQHo0QeAGiQ997Uvyf/U9LlfuvBLrtRXjgGCQegCdQbXg4VPWP+3he6yNgesASng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rTyV/Fq+EKbyIfWLvCzeDVOpS8/DhAr84tOvfxTxkSo=;
	b=FJASRO06xNu1M/2KzXitwQVefivQrhIkZoTMOdXd1FnC7SXT0zcTVijPRfP3jP97s8Pa
	 54vP0ptNIscBgVZJOhqmq2exR3lyx7IJYwR0OawVaGpf4qFzNNZ9YEWIxFbVekPRnrlAz
	 7rnQDDRBPb4m8x4EyIQqr5Aj7HdzHAwzf1pOCN7o+Qxujb0awyQtrW1kHHW1TYFgaVpUq
	 bSzQb0QJi5Br4vDUU+RuRaTaV61STNpXAYJNqY5OXhp2zyG/WNDd+nWPMrqScMkkcOGhu
	 xQeLjdDZvX2ojyE7fiXmHTq8+c62wOto/I+tqTVS9WuSqXdtReObIhMh5TKS7k1hO1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaQ4FWEH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422FD606A335;
	Wed, 18 Nov 2026 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaQ4FWEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFD01F000C4;
	Wed, 18 Nov 2026 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039103;
	bh=rTyV/Fq+EKbyIfWLvCzeDVOpS8/DhAr84tOvfxTxkSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaQ4FWEHphgQ32sHJ2PoWaeIxXALx0xCI3Q44n7ghctzaGv8fSop4XDRYZ2KNdN9Q
	 Qb/c64f/0p1vCWV7jIT7twMu87+O1E2VRqBdBZsJPpLV5s4prb0YBpMTVxr5b5ZEi9
	 5Ut88J2m2krYlpH8YnlD1E2ArcDV304qk0tBEkQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1980/3318] x86/microcode/AMD: Move the no-revision fixup to get_patch_level()
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118150421.472361917@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 098bcea71b8d257d80b0037b97b66070806600a5 ]

On machines which don't have microcode applied yet, the revision is 0.
However, this doesn't work with the Zen family/model/stepping patch
arithmetic. So move the fixup to the patch level getter function and
this way make sure the patch level is always proper and thus the
arithmetic always works.

And now that it can be called on any family, make this Zen-only.

Assisted-by: claude/claude-opus-4-6
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20260530024213.86137-1-bp@kernel.org
[ sashal: Moved the "no current revision" fixup from need_sha_check() into the existing get_patch_level(), which here lacks the upstream debug/hypervisor branch and sits before ucode_rev_to_cpuid(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 70be98a6ab9e7..8f117ef095bbf 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -223,11 +223,6 @@ static bool need_sha_check(u32 cur_rev)
 {
 	u32 cutoff;
 
-	if (!cur_rev) {
-		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
-		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
-	}
-
 	cutoff = get_cutoff_revision(cur_rev);
 	if (cutoff)
 		return cur_rev <= cutoff;
@@ -299,6 +294,13 @@ static u32 get_patch_level(void)
 	u32 rev, dummy __always_unused;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (!rev) {
+		if (x86_family(bsp_cpuid_1_eax) < 0x17)
+			return rev;
+
+		rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
+		pr_info_once("No current revision, generating the lowest one: 0x%x\n", rev);
+	}
 
 	return rev;
 }
-- 
2.53.0



