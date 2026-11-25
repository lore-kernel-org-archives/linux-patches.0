Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619788;
	b=ArQcWlvKyUyqLKhTr22YnIzfJ6zp4JG2omUiftJy1SY/KzaAhhHwPQy+BN7Kay3hZYHx
	 Ag97uZ4uQgZlynKajrI4d6I2RCi/r9yaH2kXH/YJ2mT48+Rr8JVSx8HODCdAdLQvNrSZ9
	 l5OCF36Q+Qb7ZmScybkyvCfOaYQM0+Ix2OqcEjsZot7MCxyntFgC01ogmn4sbW55ozUhT
	 kxtAoEPVwT8LP5XbQNm/hUSXFJKcEnndlptpPfRJAdTPFFYsLSA4BJbtfjKTGp0fBYzqV
	 /vlGYYsPpfmGE0uiqDSIqHLFkd66WgXwypuwnC9a7XMRElXJhiAo/pIHcimEb1JdW6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cdvq5ne3RjhkYjqCoOyjp8DHNs6DEq83W0WCNn1L00Y=;
	b=KoT7j02RHGEsBewbSEmDop88qcuvZLH0nNgsPzm4FS75H82+h0KHCCnaEQqdDQh+mAQk
	 BctZgHvz9GAy+aT29sxsTZMLCAc1tPVZVEIxz7IlngjofmHgutr0fxTsMbtf5RFEjJLC5
	 W8MugY1ENZgNUeZHW6k2kRCjHb2diUfhmiLcMXmxaFGFPIngdmxXssenzg1/4NaaNaS+t
	 U1idiK9rgcPROPU2lx/CTeqXyMiauXsefWQaYFh1oHMbgexrG/rFvRLatfDe4STlqlSr1
	 qurEIpf67XRfEJCBYh2NtaJuKOJyPXIlFDkDl6RVEz3sSTZLAmU96gwtKwN2DtlzqnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUf1mPkv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D947606A31E;
	Wed, 25 Nov 2026 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUf1mPkv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C4E1F000C6;
	Wed, 25 Nov 2026 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619787;
	bh=Cdvq5ne3RjhkYjqCoOyjp8DHNs6DEq83W0WCNn1L00Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUf1mPkvMBefI4zlSMofLOo1YgthLIfWxVvc0V2jddfMOlBHts+n+h3hj+rzVjVug
	 baKt9xj1Wjw0LXSMs97g9n10ryO8x23POqOyiEfmT1kfTeAZ3a3R4yTrn8oQ/Z7Znd
	 Hf+IXNruwh0PNcqfMmJb8ygBSYfZ2we2yGV/0thA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0709/1005] arm64: kexec_file: Do not use CMA for images with a non-zero text_offset
Date: Wed, 25 Nov 2026 15:34:07 +0100
Message-ID: <20261125143838.367693823@linuxfoundation.org>
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

commit 18f2d01bfce99a885511c451cba95234eea190bc upstream.

image_load() adds text_offset to kernel_segment->mem and subtracts it
from kernel_segment->memsz.  For CMA backed segments this breaks the
load path: the payload is copied to page_address(cma), which is the CMA
base, while image->start is set to the adjusted address, so kexec jumps
into the middle of the kernel.  kimage_map_segment() has the same
mismatch when a segment has been moved.

The adjusted memsz also breaks the release path: the CMA pages are
freed using segment->memsz >> PAGE_SHIFT, which is fewer than were
allocated, leaking the tail of the allocation.

Both problems are specific to CMA segments, which are accessed through
page_address(cma) and ignore segment->mem.  The normal load path uses
segment->mem, so the text_offset adjustment stays consistent there.
Keep honoring text_offset, but load such images from regular memory by
setting image->no_cma: they lose the CMA contiguous allocation, but
keep working.

Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260921090450.807575-2-ruanjinjie@huawei.com/
Link: https://lore.kernel.org/all/20260921090450.807575-3-ruanjinjie@huawei.com/
Link: https://lore.kernel.org/all/au4JOjnQlx2aSpiE@arm.com/
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/kexec_image.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -82,6 +82,13 @@ static void *image_load(struct kimage *i
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	kbuf.memsz = le64_to_cpu(h->image_size);
 	text_offset = le64_to_cpu(h->text_offset);
+	/*
+	 * A CMA segment is loaded and mapped through page_address(cma), which
+	 * is the CMA base and cannot represent the text_offset adjustment
+	 * below.  Load images with a non-zero text_offset from normal memory.
+	 */
+	if (text_offset)
+		image->no_cma = true;
 	kbuf.buf_align = MIN_KIMG_ALIGN;
 
 	/* Adjust kernel segment with TEXT_OFFSET */


