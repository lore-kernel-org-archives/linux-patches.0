Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7114265E;
	Thu, 13 Jun 2024 11:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279014; cv=none; b=CNIFpcInO2oiLeWjy5h6y2bslfDIQ9yPbRsTRwDCk5qQb9U+HCHQM4IuAb/jOLnlC5q9rGNSc5FG+ZLrkJQpPmzUkHmCIX80R47Wq/HDXO3gEbDFVA722/j5DkloMYtaB03SyXGS3pC21qFkvK4tOMM05/46U+QkNhI4e8RoGmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279014; c=relaxed/simple;
	bh=UNaA7QTvfGDmokhfXF+qkmZysKxoeWpNTSbuVmQ3QUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8Yl9E5x9+TVeI34jPp2UiUKCSgNV1TQ/7z07Z44HULHB9ylkKDXa0tCZPA8IuhbM1emrd6vIL6q9BfydviF4Jm0I1WL79BEzh0vfCNCIf4T3GmaHs0T9QZi76t8wGOQmpIx0v86G6ua/GF6ZNR5npe1dl8/91opDzdfTlmJWCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=By8zPKe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="By8zPKe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742EC2BBFC;
	Thu, 13 Jun 2024 11:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279014;
	bh=UNaA7QTvfGDmokhfXF+qkmZysKxoeWpNTSbuVmQ3QUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=By8zPKe4jHokVcOVC6uDPAjKW7wfn2fEcuHx8H4Sa87+S8OpInqK9mNDAI9sgi1Fb
	 mhg/cAP45BzbuIrcBvqv5VNGIOUHQQK3+0ZZ3psn6V/FJVrkEap0I2gix4CmbtJokv
	 NN+Cc+wMT6OupZHr8SkAgOpQg6TfK2qooj7Sb4/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/213] um: Fix the -Wmissing-prototypes warning for __switch_mm
Date: Thu, 13 Jun 2024 13:32:44 +0200
Message-ID: <20240613113232.473983124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index da705448590f2..21fbe5454dbd8 100644
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
index 48dd0989ddaa6..169482ec95f98 100644
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



