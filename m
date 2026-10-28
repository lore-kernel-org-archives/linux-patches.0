Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209951;
	b=KNeLO9tXDEUNs+ef0r8Oc8Fta2o6JhHrzZGqzX392TvXYgDthUHJeD27CqwI/MtszzkO
	 H/mqM3OCXxKvrShcgD8q61fe+m9YukU1CXvj/Kw3EecFtCSKWEMyGY0LJ/Ozy/6t4CcRd
	 Zs7hjGPwffF9l0Wr2ANOhUgRjrwUY242jgBSef5JkWOrUjLSesC1iQ5LJl0f7ZyvLr+RZ
	 abw4bPlh4/wBWz1kzT5xSJeAkuyXPuIdX5fj/t1u1/mx6xHdzPf56NDNWXi3FxD9avNX9
	 W1SZwpd9A1SbeUxhKfpIeShdXtidNLDgEk8RBMUsOCH0WzQuScs0vffe5Re7orhgVdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/8BAwcQhuwK00+p0sxmABMVivl6VFS6qc4tNtIgIwk=;
	b=NdDGfuXTsvaZDdtRX8lwmyV766wWZGOBpDEeG8KWYVkK8cn76agQIuuIjjP2YEKdek4g
	 hEhCAz7p8cP47ukLeyPTZ6bwrPguqn7Gvzr/v4jXBh7L1aLF/ajsmgG3vvC5NoKL8lNos
	 9Oq6cpCOMD8wKp8Z1y0ftQdNFq/f+Vw7KynncczZQrum9HawFIzdpr3tr07CgDQNzvCLL
	 DlSNh/6dsiQADpIxDlgOb68JLxTqGD+8QNNHSY9RfY/3yzlzKsILLymq9pMGP9zeIZ8W+
	 XF9WkKogtGAsps/gUPbJn7aIV5+lFp3Tp0Yb52Zt5QX7R3ReU9soDoGDzUfZZf2Gbfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFrUJckS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A61E606A31A;
	Wed, 28 Oct 2026 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFrUJckS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF251F01825;
	Wed, 28 Oct 2026 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209951;
	bh=x/8BAwcQhuwK00+p0sxmABMVivl6VFS6qc4tNtIgIwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFrUJckSbpzEZvZ5R8aMgC5mRBMdmVx6+RI/F+Xsx5zyG7/Ar86cd/O/0N2V2eAHi
	 46dOfDxImzMYPCmb4gmta5izsiUw56EZ0tPo4KSARLqnXU1Tn9n+teO88z/6yOUtZH
	 F/63j4TgEyXYJJpXcq/5GZkFmAtS3UXKjhu5XVqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/168] nios2: fix __wsum type degradation in csum_fold()
Date: Wed, 28 Oct 2026 17:59:20 +0100
Message-ID: <20261028165943.669544472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



