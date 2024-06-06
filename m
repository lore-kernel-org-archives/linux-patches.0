Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA02199386;
	Thu,  6 Jun 2024 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682994; cv=none; b=P+WJHQgSiayziNe8lHO85bl+nopP8QNgoeuk9YfeTfAbrrcYl0eMTTV/ynxpuXYwn6NIV/TVtOSVZFb7xNPdbWNeEpmDovL5P3KbEOoo1xN34uGVxH9L5K7yllSnzyvEnhvRAUgf4O4kdJOAC5HzPK2UooTRcx8ap8I8kssJStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682994; c=relaxed/simple;
	bh=FNTixjaoxqs69w1gqKhqOyaw48io8f85wiMUKvAiOow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIzME9T9r+ioaxX2UM/QycNVLkS6vk857uih5ET2/uvRkDGNEHJZmafwDszjPIGBYyIYFY2sZ3jFKuwUCNv/bBXWu4ldMrBGyCqr4WwZPlxVd0GO5yzFfi0oBGNJBxdrY2g7UmZCclo30H0tDAEzxxChjb0WFgsJMRi3TUFAYRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMyQvhFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMyQvhFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B59C32781;
	Thu,  6 Jun 2024 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682994;
	bh=FNTixjaoxqs69w1gqKhqOyaw48io8f85wiMUKvAiOow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMyQvhFSuLHY3mPlrXXLhCCWITvE2ETsSyGnxexOEhvQlXxRLTwFBrHzW8DK+LzB6
	 8s8HG/atGEjZIdcFKOQl2j+y3ObjW0Os2c0YRQtPfNI13rr1VTpu7/CFQyk4tIX+aS
	 3PbzoSdO3A7+pBJQH8HKdAh0+QOqu5QWK8LiC9F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 192/374] um: Fix the -Wmissing-prototypes warning for __switch_mm
Date: Thu,  6 Jun 2024 16:02:51 +0200
Message-ID: <20240606131658.291706885@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a7555e43ed14a..f2923c767bb9a 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -14,8 +14,6 @@ typedef struct mm_context {
 	struct uml_arch_mm_context arch;
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



