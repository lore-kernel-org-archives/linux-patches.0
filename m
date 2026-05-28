Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802A2F691F;
	Thu, 28 May 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998862; cv=none; b=BOQs6+mMDHOlTOe7g7hXhTZNYnkrVf4RZil3PIyWfRBSEQdlIhZBi5ebtMBjC8E1O6jTZ4b3WqTtm8lrzZMJUjw0w0jbqemBjO51D94/Aq7hGttWi4jiQl8zv/Vsb+8rZhGD+5KB0Py6iv32+zQk0GXsYJuDsu02el9DFQc7D30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998862; c=relaxed/simple;
	bh=BKYEJ0vt7qnz5kKrncXtGU6WsDG1WYWi1QLPBcJh8d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlFIfvbW4QJfBySUVDjwc/vZp5ko/h4qYGYC7Dw30EWO/I0LDcwYjBPBQr/7YQcnv890QSleBg7DW3eyPW4JUEtRlL2Qb+rfffgfw2L2RdpzHwgEi3tWQMOf9Gj3vMWAIZVQz77tCqflHZR6d/X3+n8z9sEKuau22LTmJFHaI5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2rkee+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2rkee+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2107D1F000E9;
	Thu, 28 May 2026 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998861;
	bh=CSF2k3PlWiv1MXIjhX3tWUXika4t0QrTACjNeIX5/5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2rkee+jxkvaKmrENfKEpO0HOLN52IDr9T9NJq80HyZLAFSNzf0+VRGba4sIxBvD9
	 8sg8wCold96M9sFe9WtLT+LbS0oYTC78yu19YwRKThhbzoE1UXN7yp7P3+H/24vkKY
	 QPlIY4BYKY/o0JrgirJFajzy+WeuG/J5We52b2aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Saitz <ingo@hannover.ccc.de>,
	Ivan Bulatovic <combuster@archlinux.us>,
	Christopher Cradock <christopher@cradock.myzen.co.uk>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 325/461] gcc-plugins: Always define CONST_CAST_GIMPLE and CONST_CAST_TREE
Date: Thu, 28 May 2026 21:47:34 +0200
Message-ID: <20260528194656.731731038@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 905c559e51497b8bfdbb68df8be56d2f70f0de8e ]

For gcc-16, the CONST_CAST macro family was removed. Add back what
we were using in gcc-common.h, as they are simple wrappers.

See GCC commits:
  c3d96ff9e916c02584aa081f03ab999292efbb50
  458c7926d48959abcb2c1adaa22458e27459a551

Suggested-by: Ingo Saitz <ingo@hannover.ccc.de>
Link: https://lore.kernel.org/lkml/ab6OKoay0OWkywjK@spatz.zoo
Fixes: 6b90bd4ba40b ("GCC plugin infrastructure")
Tested-by: Ivan Bulatovic <combuster@archlinux.us>
Tested-by: Christopher Cradock <christopher@cradock.myzen.co.uk>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/gcc-common.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 8f1b3500f8e2d..abb1964c44d4e 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -309,7 +309,9 @@ typedef const gimple *const_gimple_ptr;
 #define gimple gimple_ptr
 #define const_gimple const_gimple_ptr
 #undef CONST_CAST_GIMPLE
-#define CONST_CAST_GIMPLE(X) CONST_CAST(gimple, (X))
+#define CONST_CAST_GIMPLE(X) const_cast<gimple>((X))
+#undef CONST_CAST_TREE
+#define CONST_CAST_TREE(X) const_cast<tree>((X))
 
 /* gimple related */
 static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree lhs, tree op1, tree op2 MEM_STAT_DECL)
-- 
2.53.0



