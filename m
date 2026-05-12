Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0933B6CC;
	Tue, 12 May 2026 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609684; cv=none; b=tXPSLtUYS0jzt/Ea9uRGJnfkeK4GwZLvnsMDiovHGfdSEvXeGwMhoLPhGrC9JwnVQgnAUq+zMZQSGKqONmUNXV3EMCrHgfoUBcfWSR2x4z0tRutTjsrwRAlm9ldoOmi05rb6/ntrwDOPfluf6oEzWijUD5PpMtFigWXv5MBmN0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609684; c=relaxed/simple;
	bh=JlV0vLbRZhXsxE9WI80QjFcXPw5E3ZKlVgFdyFws2Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKikOZm7cTbxPy6vP8Q771Q3W+pZmk8VaCuK+Zncfi113Zz1KBT+nsbH1qX6UQ1wThyhgoDMrqPl2NfgQKAFEwXkZ9u1nmwP0DwJun2krosDppAetPp01ilV9NzZGQH0FO1y3h3usYGAo7byyHFesWzVfFt76ad4PV2wc/zWfMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mxBkOrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mxBkOrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411B8C2BCF5;
	Tue, 12 May 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609684;
	bh=JlV0vLbRZhXsxE9WI80QjFcXPw5E3ZKlVgFdyFws2Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mxBkOrRe1q6SMOABBfcVyKSyrJ1Kr987tQI9k+7ar9LR4XuZ7lN1c0bcm0SN+WkG
	 QUxFVC0TEd792Oh3jlpkqRWwtXzwRrtpou1g+Ejm/vR/u7FsB3dDJ5rBcyk4bLhULk
	 fG8dfaMV+nVVZHPMuJM3vBcrhA+RkG17d5OVgiGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 289/307] LoongArch: KVM: Use kvm_set_pte() in kvm_flush_pte()
Date: Tue, 12 May 2026 19:41:24 +0200
Message-ID: <20260512173946.224863607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


