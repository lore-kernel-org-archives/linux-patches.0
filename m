Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F18E351C02;
	Thu, 28 May 2026 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000055; cv=none; b=V4nrZpuMl3qmpZ03vkBqf0bJR78ghO95DIjUwFr8qxVQyzjYiKdoUWaemYmgCN1KL34D7AjJfdfngHmDCvhIt98yi97OYqR/zhbLwzZzfH8dPsSudUsl+Z0MXRqMulrpqmVQBWChVbTpK4Q4LF6eBOJfafFXnMa2PuiFTgqeZ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000055; c=relaxed/simple;
	bh=LnEUFyEzaas6t7VHii+1rz9z+KLaql5AIo9+/OGtMiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIdQ0KBFz/fJcDnRCufsmuu7EbqLmbiC8nSRMPC+qRGwcYCi5niq5slIzVr87dxbOKfSi9cObu4WkoLUykHuEqCqT8XcO28InyRBV1a1Ad8/f61RrsV9ieZ7o5u0eYMXDkIKL/ddEe/ZOwbwLRNi77bTJU/8k0vC0s5f6lg+ILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewZoo+B7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewZoo+B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1761F00A3C;
	Thu, 28 May 2026 20:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000054;
	bh=u4WG8KQdW+ERQZl5CaIq7cndRHaTR1zz1ZimrSkdKq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewZoo+B7+HOCRh7FmUnOR82YMYEuT1TuzZjZoz0xT4oJR47wU5X3KXPp7mrNlt9LY
	 ZKMFuR5LPkxYbVBcF4WgoMVeFx8OtQSj1PENwsTRhjzVImlIWtEUN7MRTMqgoYTIqd
	 J4j31MQObDa5jNA7Qszh7DOLeMTHATAjvDgw01nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Saitz <ingo@hannover.ccc.de>,
	Ivan Bulatovic <combuster@archlinux.us>,
	Christopher Cradock <christopher@cradock.myzen.co.uk>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/377] gcc-plugins: Always define CONST_CAST_GIMPLE and CONST_CAST_TREE
Date: Thu, 28 May 2026 21:48:45 +0200
Message-ID: <20260528194646.661787065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



