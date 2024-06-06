Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B14819AD8B;
	Thu,  6 Jun 2024 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683691; cv=none; b=cWuB7LXjju2GQFvr+ubiP6WY0rQGPFh0AMH5y0QQzchKPfkp87jIDw76p1nAAoLO2qxtBcRUQ83fU+enmI4ZartUBjyzFu3F83WeJUmtt0AT0duNgsMl6eFPdGhik9L/OS2+fIvxAKVzVuHTHVAdDYCZWfai+/YY6nI+5LsuEyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683691; c=relaxed/simple;
	bh=iHlMk+IZuONKm0L47hSgbPg5vTEmKSMWZ9bepgsRg7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh+7/WeJNDUERPERDE6+pXkCiF5ZHEIU6q6LJPSYn78lyZYQAMrtv+4JrCmPFf2I3BCR+FXiYkMXV736msyRsTWTwwT57EjIhosydlJP0lNPrqLJkwWZVIHk/h+XQTtyLDuItzBIvg0Cv6UFNSg+5BA2VeiiJ/r0GaGU6mmueCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCD/VEC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCD/VEC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F4DC2BD10;
	Thu,  6 Jun 2024 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683691;
	bh=iHlMk+IZuONKm0L47hSgbPg5vTEmKSMWZ9bepgsRg7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCD/VEC6UGDzBrEkfdFqrFoDYc3x8H24wTGx5B8AVLj3v3kCGruTR12Unsr0FQTn7
	 2JyvzT/QFSdYc3RnF9Oz02yJDSFvUh8DQLFUxNKIDmBcZQfgQAnBpgFcgH0vOqD4Z/
	 o0ojL2Wn+zR5bpuM+FUYAonEbnZ4zMeAom54SDKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 601/744] um: Fix the -Wmissing-prototypes warning for __switch_mm
Date: Thu,  6 Jun 2024 16:04:33 +0200
Message-ID: <20240606131751.755852025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 2cbade17b18c0f0fd9963f26c9fc9b057eb1cb3a ]

The __switch_mm function is defined in the user code, and is called
by the kernel code. It should be declared in a shared header.

Fixes: 4dc706c2f292 ("um: take um_mmu.h to asm/mmu.h, clean asm/mmu_context.h a bit")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/mmu.h           | 2 --
 arch/um/include/shared/skas/mm_id.h | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index 5b072aba5b658..a7cb380c0b5c0 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -15,8 +15,6 @@ typedef struct mm_context {
 	struct page *stub_pages[2];
 } mm_context_t;
 
-extern void __switch_mm(struct mm_id * mm_idp);
-
 /* Avoid tangled inclusion with asm/ldt.h */
 extern long init_new_ldt(struct mm_context *to_mm, struct mm_context *from_mm);
 extern void free_ldt(struct mm_context *mm);
diff --git a/arch/um/include/shared/skas/mm_id.h b/arch/um/include/shared/skas/mm_id.h
index e82e203f5f419..92dbf727e3842 100644
--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -15,4 +15,6 @@ struct mm_id {
 	int kill;
 };
 
+void __switch_mm(struct mm_id *mm_idp);
+
 #endif
-- 
2.43.0



