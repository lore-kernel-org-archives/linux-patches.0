Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063699;
	b=XPYFnhV4Zm7kjaOfgNemtlOP7RD4ovETmoIkZu0NCNXu2XWHKssBQvqLDb26DCKqxYg9
	 CCkcbtAkFfZ5Sd8/MsEg6+Mz/m75u1S5TWzqkAu/NGyrU2/Yjms7OUFEWP6IVAgnhYbHE
	 goKWWkLaSDy3d3xp3zTWLzyP8w5ZSIm9RWuJBzihF5lDDOkWif2ugkjYaU2W/4//fy0mg
	 TJz638RdGFuCqngjTbbjmwvCQL6m6cONrVAOIeI+9briWPCgeHgTFLHv/b5ffdYyNylGX
	 fIycnmfluY5pN1y+p4oUO2mXvalhWsheaG9F6ZaEx71MDHtmuEbFj0AIesG0oUgakyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdrsRuvZVGu6FvjYljfJh7lQ6SpJLXm2GDFy6MRgtwA=;
	b=4PiB+yYzPHLbeRdJlCpjQ07dyAksuCWo1e4wLsgEfggDjlCo8tben9WkMbvQ6z/F7SWs
	 989AhYBIuZzFuIBEB0gvEJyCy0tDRC+9OqjQm+ux2guwnbI0Lt5gJUOQsf5SxSJ2ZJnDD
	 qxIFw7CxoB/19hWSIScJ6j3f56+6ZMQmXDToF9vIhctzH1w3yUuLnYvyB8asiwrHqVUwD
	 5UAt7AE1eZggt1zjYPGtI6HIY7bQcrdbmOjVM3IUImZ1nbaQPfRf6fORERsz+xj3hqrdB
	 ZeqiwpN8a6k5mKETso4/yvSh9xHYoO74g9Aum5jwc5Rvom4Hzc5zo/cYCQgru0epcxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qJRYHef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB38606B8A4;
	Sat,  7 Nov 2026 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qJRYHef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1E91F008A1;
	Sat,  7 Nov 2026 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063698;
	bh=QdrsRuvZVGu6FvjYljfJh7lQ6SpJLXm2GDFy6MRgtwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qJRYHefT5uXrDLvKkFABrz+OqS7o+sdQqO2g78nSK3eIbAxiTLz60tmGz5mPxoL5
	 3xTZMrb0+y0xv5tOr1Fl8uVvXMNXfFLiV+y3DEFBUdz88vnu+onalOERNu/K0qisDE
	 /IXSUFoYNTR8UJhtXei4Cp/Vq3LSnn8QNmDpIMsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 802/869] LoongArch: Call cpu_final_simd() with pure_initcall()
Date: Sat,  7 Nov 2026 08:58:04 -0500
Message-ID: <20261107134920.112638142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4ac9c95991670..9f0f9fdac011b 100644
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



