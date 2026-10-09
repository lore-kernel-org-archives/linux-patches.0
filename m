Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE13D5C1E;
	Fri,  9 Oct 2026 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555466; cv=none; b=MIgCnf+YwKhTI8zeioH7SHMFxljWmEqYjGlByJQTxIyuGPornGvAgE3gq9q4AizulKSEyglouNyd2tmUNhyr5tL5J6xHHJn3wrcbbNedm8/4M/MW9Jk7MBawFJFJHZLGSU9D6arZ97OdXdOAvwzDNzTBtKf/nSa5eHyJbgnRj3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555466; c=relaxed/simple;
	bh=cCBACytssC/luodp04yd8vfCdGM8EGqLU/YSnxwZUTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO1eVumEvN1WA9HlmnxKDuepru7yFvzb4S1FJ+y6h9LYuKkWvpBDmlttq/B1iFhrgbH2C2ynXRUY/fO8Gj2QEdcyUoNwllfLOg768IAKJdzvDtNXRORdvQAX7cWUAao/1ckdb7vJ0nK3D0C6rEdMiQ4+QLkQys6L1zVzf0XSGCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV4EwnKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV4EwnKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FFF1F00893;
	Fri,  9 Oct 2026 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555463;
	bh=tD63DkInhBi79oruLytSLIBFprm1wvf6M1dmxE6x46w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV4EwnKoQCXcPoev/Vy+qQsU9tiE8qxtTLJSJ0iIyHPpzkDLQTy4JHi7LviPs/5/M
	 aU+dbBQ7hR4ub2f5qYmzFVvNwBB+P2NrskvlQDEL9eU2ZpqGAJ9nj/gv07ssasbTfw
	 /C/oo2pQtgOKlNzs8zr5US61mJzEVTgXXls9Du/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/403] random: fix vgetrandom_opaque_params kernel-doc
Date: Fri,  9 Oct 2026 16:07:03 +0200
Message-ID: <20261009140953.547800053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 703749b069d53b55f92499e088b30b031e47b8f9 ]

struct vgetrandom_opaque_params contains size_of_opaque_state, but its
kernel-doc describes size_per_opaque_state. This leaves the real member
undescribed and adds a nonexistent member to the generated
documentation.

Use the member's actual name.

Fixes: 4ad10a5f5f78 ("random: introduce generic vDSO getrandom() implementation")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/random.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index 1dd047ec98a12..ef6614d9c7049 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -58,7 +58,7 @@ struct rand_pool_info {
 /**
  * struct vgetrandom_opaque_params - arguments for allocating memory for vgetrandom
  *
- * @size_per_opaque_state:	Size of each state that is to be passed to vgetrandom().
+ * @size_of_opaque_state:	Size of each state passed to vgetrandom().
  * @mmap_prot:			Value of the prot argument in mmap(2).
  * @mmap_flags:			Value of the flags argument in mmap(2).
  * @reserved:			Reserved for future use.
-- 
2.53.0



