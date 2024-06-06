Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605B81BBBD0;
	Thu,  6 Jun 2024 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683494; cv=none; b=XfEs34hLUJThiJZ4cUJjcTUD7fbzPEwyOMZhpVD34S+h+1lJeo84D2JcC4HlydcY6TI7VC9Wi/3zibE7rfVbYy/YXB4tOIhUcfphgCInh6GwVJ/72KgoCFSwDuSzDPybWDyI0EqtkRRr0oXtbhuad2z97iOocF2YWG+o87N5fTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683494; c=relaxed/simple;
	bh=OPfFgP6+/ItiK0rBhKHmLob0nvGk0lu8GfnXbmWKqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ziwg2DJiMgbON7k93GGSzvxAG5fh71mud9AJ7radcrk1tRfXqbN2GfeL49ANT8911fhbSHwmHaZXMbmoYgBFEPHbTYUdf38MY8ly3jyjIFVrDzMHhZUU1OneVZMnJjCG4pSd+sT96JuJsZ3e/EWysnr+0bN0A7UBdQ+SuvPElJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYicXtHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYicXtHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1381EC32781;
	Thu,  6 Jun 2024 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683494;
	bh=OPfFgP6+/ItiK0rBhKHmLob0nvGk0lu8GfnXbmWKqzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYicXtHr8YXqF2nvdaoI5WBuFDK1QlZpSADwR2YSIpRU5Dlz0a4Bvhb9xtFW/8PVP
	 Mp6Ez3BpN+0sVcbEdtkMBaJq+wcSIP9ABpEnoNH5OpKQyWPDG4sb7AizxhLLrNUs7+
	 oFnNugLovTmcVAUJs6n6ozdimLn6/epUEcXkP1Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/473] um: Fix the -Wmissing-prototypes warning for __switch_mm
Date: Thu,  6 Jun 2024 16:05:13 +0200
Message-ID: <20240606131712.550956625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



