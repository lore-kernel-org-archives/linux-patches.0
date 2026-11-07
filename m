Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065533;
	b=WUk+7RhNGiiOjCwOUHPFEqDkImqtIEVFBPGWJ+dImab0DeRupdxn84NtHBZDOTKzYqzV
	 uBUgJV2IJ/pghUgHsw4V5ghJVvYwWbgoxe8XEO7F/T1BfaDp94rZwDE4DjyvWPo+zBBTk
	 7VUk7HgwjctGqPE+de1S451EG06c9E3lfcedBRw2fQ7vR/l+Rz3g7qKXfMLIOfE7DaZBY
	 9dKqLa1A4gieWZ3Y8Dt8wcxjMiVplnLyIKNGzWujDCDuI1FuEXexi305+mY5W0z+pFxf2
	 va3LnDq1Qctb0a4U3wj5csR/3amSgfFJPxgZPlhCE/Yc4BTvCsCx4J+sbZpbTqiBe3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91BfF7AD8RqEuJBNs3NiBfH7LutDNyIEC34PuOIVavI=;
	b=I2uxns8LgJ3a0g7iqAwt5IlEPkriVokPg+VTZnHkSSeSMjMmjGDNYAJ2a6CtH6qxPeUM
	 MaBYLLs+ZbcumBGOBTJ5V7Rif9bjl3LJs3CfbQjD5WK7HrohYpNordfH4SBRq7v2Xvx0o
	 ublvUJ4V/2efpjcMq1CfEhbIjJMFHO0aB0ru1We+qqoMPWQzmLTwBxlEWUNPuL7jxA+Mm
	 xFTs2WMAABYUwX4E6dMS3jOhCgZZM5tO+7FDKRG8O/H7ka2maTokBtljfXRKQXeqIm010
	 b61g54Vu4qbRQDWOEp17zcMsYLrCOSXvUOzH15tgG6QF5zVm/UEP4vsJxSd7b3WP2Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spAz5FbC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F6606D802;
	Sat,  7 Nov 2026 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spAz5FbC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD9A1F0089F;
	Sat,  7 Nov 2026 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065532;
	bh=91BfF7AD8RqEuJBNs3NiBfH7LutDNyIEC34PuOIVavI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spAz5FbCruam6flY8/TpdM5g24GnWH91ydID/8G7LhJnIHPicwbcEtrpZ5qEMrO6Q
	 ZdQc+MPtU6+Jj3Elk6uTA6wOf58MOWWhYe3zrLqS1QIuL+SjdcOujQf8yASI1nDdc0
	 wDl41a2uar86icBkhui0210T3dvifRoxKbezWDcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1162/1257] LoongArch: Call cpu_final_simd() with pure_initcall()
Date: Sat,  7 Nov 2026 08:57:38 -0500
Message-ID: <20261107135011.285514607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 9b56c3659a7e5d930ab3c07ea74cc46af65b6d20 ]

After commit 35ebc4de105989034f12 ("xor: remove macro abuse for XOR
implementation registrations"), using "simd=128" to limit SIMD on a
platform with 256bit SIMD instructions causes a boot failure.

Because cpu_final_simd() is called with arch_initcall() now, which is
after xor_init(), LASX flavors are selected but not workable.

Call cpu_final_simd() with pure_initcall() which is before xor_init().

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/cpu-probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 74d31f260dfd8..629c976c33c35 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -93,7 +93,7 @@ static int __init cpu_final_simd(void)
 	return 0;
 }
 
-arch_initcall(cpu_final_simd);
+pure_initcall(cpu_final_simd);
 
 static inline void set_elf_platform(int cpu, const char *plat)
 {
-- 
2.53.0



