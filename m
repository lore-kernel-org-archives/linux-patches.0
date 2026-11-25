Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620004;
	b=nmOYB2cBAEkTpoto/mwrCikMCw8H6AtDuFIxuHki8uWFNpH8gzsTnaTsA8i0F8sdJmhO
	 JG/fNEowyUbDsDT0qeEES76+9IRbrqflMRWvU5jDLdUyW32n8JJMAi6Yb36r8VEIiWdfk
	 fdSm7HJ65eYZLYgMiV4ACD/WwWYaCPQS7eAO1M4WJDJsVGsJexRyyofpR8/tex66By+LV
	 FXXANUPJCimVlzlRDp8M/X6jEa/Zaqn6ZDxM3BNN8ilJ/5l/8O3Mu6C6+ZpRUDpsQehzl
	 e5/R5AnbBTLGwDXZlCvGKwrTG/ccAUwH/FoEDxPTg/Q0PXSf6QL6ibL8LmlqAIXOWjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ofIRBpPwep2yKCz8TFAEcc/mdQRbF9H2LAvMms5vqg=;
	b=zet7X05o70+ticLjW/+m1MKuiGJH3vC0e7atkH4xUbGb0Fci3CHeU3s/YC19h8wr4kSm
	 zScVjrvDvDBPcn2rlaiIvrSTHqA0xzjHo3WOD2NvG3QOyA3CO462xfLypAu/e1oXNSZxa
	 DOBklYQQNSPUm8uy0Jf1iyB2w9eyG0z1GyaWhG2ebPhHE+jPDVtcbsIbWPP3bJW4tUEfQ
	 JDtdHbmhqA3oOCBpxof3NJfPWRz8jA1iXLqT74llh+urNucMYzgsnGA7nF4jjvn0lCUgB
	 LCPmfpOHhDkOJeudrWy3IuhkHIYZ0v4uG44n/XfrRYzGrnPQg63p+TDeTaRvc6k3OOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uvn9AwAv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C0F606A31E;
	Wed, 25 Nov 2026 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uvn9AwAv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE41F000CA;
	Wed, 25 Nov 2026 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620004;
	bh=8ofIRBpPwep2yKCz8TFAEcc/mdQRbF9H2LAvMms5vqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uvn9AwAvMW9/g4dt4BOLcTdjWvyedMRw6i7dzE88Bdyl7VG7Ee8v26R1yEJnEZIX4
	 nN0UOmETuYZ8CYZDhDMtsE7atgcxN9lO9bj/OQHP6xywF3fxlSwPfnYOvjXuOgvyID
	 Bib+OXJr2REVYlEuwL/0picgo0duEOqEqTG99FCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0776/1005] LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 25 Nov 2026 15:35:14 +0100
Message-ID: <20261125143839.920050529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 065dd1636abef6b9962fd5af82accac69850bbe8 upstream.

A retry allocates new elf headers and overwrites image->elf_headers,
leaking the previous buffer. Free it before assigning here.

Cc: stable@vger.kernel.org
Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec_file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -166,6 +166,10 @@ int load_other_segments(struct kimage *i
 			vfree(headers);
 			goto out_err;
 		}
+
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
 		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;


