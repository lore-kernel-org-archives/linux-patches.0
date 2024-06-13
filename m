Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB961474CE;
	Thu, 13 Jun 2024 12:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280068; cv=none; b=eiHBMrn5Atd4Acch5CIoBKKztUtasJlUK9GdcVYbyXEE66OJUwSMMlGoSsTAZG/KGkYfTlC7c3UM1FB+9IIbGa7RK24KjlIiAjKyQOYSi4hPMw+XYIGPECyYpa35cxyo7tPz+7oPeE1BZzjxiYMpFbg6qL2PeQn8C/mPbYLWOe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280068; c=relaxed/simple;
	bh=ied6vMb6MMZ2oUXvJNY8j2yAyH2GZFkhEOj/7SKz9q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZdo9VaaQhbD+JeW05c+DfytQwLmMvo20Nv5N/c1YDa/k0XRaR7PCZMxz/xgIaraekOnsm61z8vZr6dR6uI7rJag8nqgHTggpMz5cLdC8ToD+VklBEmbGo1eHQcOxlQviGK4DSmcX9HYPF14zK+zpqAei4EfTO1PB7j08hPW5Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbKhP9CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbKhP9CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15365C2BBFC;
	Thu, 13 Jun 2024 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280068;
	bh=ied6vMb6MMZ2oUXvJNY8j2yAyH2GZFkhEOj/7SKz9q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbKhP9CBPmfpVdFeNOga0rLa/0/tY+7pDe9CMVz/aHI+RxrwduIbqOIO3ZZiRtyrw
	 1gR/pXCBBVb1Ts7XoR5CH0cJyvYr6HDS4Tr2aXVJKWSrBD3zJs+JHmMDqNkk35bEAF
	 cZfYaiKgGILkkKJ/7pVvp9CFx1MIB6K+X8orIqFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/202] um: Fix the -Wmissing-prototypes warning for __switch_mm
Date: Thu, 13 Jun 2024 13:33:50 +0200
Message-ID: <20240613113232.856020216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4337b4ced0954..9bd159649705a 100644
--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -14,4 +14,6 @@ struct mm_id {
 	unsigned long stack;
 };
 
+void __switch_mm(struct mm_id *mm_idp);
+
 #endif
-- 
2.43.0



