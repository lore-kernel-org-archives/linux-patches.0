Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1253C09F7;
	Tue, 12 May 2026 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608155; cv=none; b=AidvMKmuDbFzXG+fVyOS8cKjeRu8ioU7VjAono/wFUIIsT3oUkhe4IVHQ/MeTCoUfqmHpj9BHcZOzIu53jTUts9XCZMq9GiRONnF5OGvoRoHPXkn179WNskeLaGctBeLi5/tyccJcS3Q47yhxubZlTg8piYRKp5lJJ5jkRqMYSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608155; c=relaxed/simple;
	bh=h2Yr1875Q04TYSv8sGRmqngtWSlYKncMRnFQzKnX3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX8N/vez4axArIZgshcX6gvMR9EyaO/Q3atNWEcGdXuxgBVr7KSHkz7oxGMWYWwcT+TOSkkIqzYDhsm8EH6p0l+Prc+Of29jA4cCY333lQBHjOxH6RTgltThvuf6+qRmzi0XnQdCjbA1GR/OpXdDGVxZFaFdf79/7o5DXAWQrNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdQoLoVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdQoLoVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5299C2BCB0;
	Tue, 12 May 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608155;
	bh=h2Yr1875Q04TYSv8sGRmqngtWSlYKncMRnFQzKnX3tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdQoLoVnei6/idKE34KkjZaawzJfg82zc4reIwYpHvx0FROh5g/JML5dpwAiL/7xF
	 hd50gOeZzsHvMJ6kUmVvz2/JFxe7gcx0RMckSZuqsnKUWfrypvl6H93FBST8x2mdb2
	 LnHpKlTKN5ASwHarHTLKnyK5ioq4Vtz7u2PIc214=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 176/206] LoongArch: KVM: Use kvm_set_pte() in kvm_flush_pte()
Date: Tue, 12 May 2026 19:40:28 +0200
Message-ID: <20260512173936.588329833@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


