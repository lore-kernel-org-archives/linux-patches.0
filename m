Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611FC3EDE41;
	Tue, 12 May 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608866; cv=none; b=hjNq2P6L0sDjlNFboiGxJ7JkDRbncg+3mKI9PzBAKsuhdjrBVefxIEmMInp0TZnw8W+RUX97FTdEGlm7FDTKoix7/1Vip6mcEk1N2WSsjis4jYsLHVUf0Xb1cLcQCrF2ua0vyJyfjQk8Ynp+Sx08u8GN6JzKGX7+0H7EQfudeag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608866; c=relaxed/simple;
	bh=7qBjzxrBnnQ+R8u22QQWO0ijVRSSd+3xk3B4DEhqJMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJbPQJAwVoERXtzRTz4FOOcrTBfG+IELFIerpcKv5UjoKVHIAU9NHGbNzPkuqFIq8iK29+9El3FGZ7Kgh/wUSEWtH7xWphAZY02oedaefjLSTBeKKDHJKc0ebAsP895Ev9yRBdYNJ/IqD3kaL37sPrbnKAv+yWv3uaPRp1hSAqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcAkHYvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcAkHYvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B4C2BCB0;
	Tue, 12 May 2026 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608866;
	bh=7qBjzxrBnnQ+R8u22QQWO0ijVRSSd+3xk3B4DEhqJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcAkHYvPRElhMosB5o9npTlR0m9zOHt5ZUX3+BKv58BragxAfcvubwSLUvwnsqRfQ
	 8477hKp09u69v+Accyb6miPiMF78dBR96/7YPxq17B7Oe0g3oDfNY58s9ZITICOCQG
	 FuoEVcK+lrFqsIHDfRWKL/sFtd6/qnzqmikTs7Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 244/270] LoongArch: KVM: Use kvm_set_pte() in kvm_flush_pte()
Date: Tue, 12 May 2026 19:40:45 +0200
Message-ID: <20260512173943.577046170@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 81e18777d61440511451866c7c80b34a8bdd6b33 upstream.

kvm_flush_pte() is the only caller that directly assigns *pte instead
of using the kvm_set_pte() wrapper. Use the wrapper for consistency with
the rest of the file.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -95,7 +95,7 @@ static int kvm_flush_pte(kvm_pte_t *pte,
 	else
 		kvm->stat.pages--;
 
-	*pte = ctx->invalid_entry;
+	kvm_set_pte(pte, ctx->invalid_entry);
 
 	return 1;
 }


