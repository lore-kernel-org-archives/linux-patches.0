Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36E34503EB;
	Thu, 30 Jul 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425173; cv=none; b=XON8cxBhJ3N8AeJLdfjMDDIORc+f+trb78qc90bN99GvQEoFuwWdRWCXGcd8hGXQhTszSUTZUhpFB6NFMZo2ZvMv8SHb4yT+quM0aSt8EFfSdjoscLVjSemopHVUpCIcdSfYDRfDSLWLuM6APkQNrutf9lquH9ntDU2Rlzdod9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425173; c=relaxed/simple;
	bh=oT4mR4tRVF/IivInsPYXoeefp17DnhcCXGEJ+xuAcJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni0TT0Qb0XaLxkW8pJ3SL7va+YvcwaUuOimVye9swsdlZVm8eAwPogg9W4WQKWsiGCttTECdz5iJIHkg6t1KUHj5VpQF6NWsFnvVDb+QW7J6t7EWWZDY8PX4NwZmzcnHOVBZJlQ3YV4BD1WfWw4/q0y40k0b4BVFZrN9Y9X4s/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psOKwn8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psOKwn8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33C81F000E9;
	Thu, 30 Jul 2026 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425171;
	bh=1wkd5nP67uqGTJXpaXEcu9Scxk1WtlyzrTyAgFzP4AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psOKwn8VnKyJqN5k+mlqngOuL7/874W8fBwkKjPeWwAbReYPvGhoV1qdhEEz/OQ/w
	 jQXqqLSFvhC2GUnT/43fzgpJhHXTFcSq403QAj0xG4UwPqCgux+y+RKFBouLfoBMhD
	 8JFWV/SMlgPM70WbrOJgpRS7mh26D+4LpI2oUmLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 605/675] landlock: Fix formatting
Date: Thu, 30 Jul 2026 16:15:35 +0200
Message-ID: <20260730141457.972607390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 405ca72dc589dd746e5ee5378bb9d9ee7f844010 ]

Auto-format with clang-format -i security/landlock/*.[ch]

Cc: Günther Noack <gnoack@google.com>
Cc: Kees Cook <kees@kernel.org>
Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260303173632.88040-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Stable-dep-of: b232bd12789f ("landlock: Account all audit data allocations to user space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/domain.c  |    3 +--
 security/landlock/ruleset.c |    7 +++----
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/security/landlock/domain.c
+++ b/security/landlock/domain.c
@@ -94,8 +94,7 @@ static struct landlock_details *get_curr
 	 * allocate with GFP_KERNEL_ACCOUNT because it is independent from the
 	 * caller.
 	 */
-	details =
-		kzalloc(struct_size(details, exe_path, path_size), GFP_KERNEL);
+	details = kzalloc_flex(*details, exe_path, path_size);
 	if (!details)
 		return ERR_PTR(-ENOMEM);
 
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -33,9 +33,8 @@ static struct landlock_ruleset *create_r
 {
 	struct landlock_ruleset *new_ruleset;
 
-	new_ruleset =
-		kzalloc(struct_size(new_ruleset, access_masks, num_layers),
-			GFP_KERNEL_ACCOUNT);
+	new_ruleset = kzalloc_flex(*new_ruleset, access_masks, num_layers,
+				   GFP_KERNEL_ACCOUNT);
 	if (!new_ruleset)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&new_ruleset->usage, 1);
@@ -553,7 +552,7 @@ landlock_merge_ruleset(struct landlock_r
 		return new_dom;
 
 	new_dom->hierarchy =
-		kzalloc(sizeof(*new_dom->hierarchy), GFP_KERNEL_ACCOUNT);
+		kzalloc_obj(*new_dom->hierarchy, GFP_KERNEL_ACCOUNT);
 	if (!new_dom->hierarchy)
 		return ERR_PTR(-ENOMEM);
 


