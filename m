Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019249;
	b=tvhAEy/XFLUhT/J6zwSR+A1CbedSb3N6ccFNVi66xLWS7lgxVQrDTm8tP7YKG5tf8f5Q
	 LUzj+MxLJ6rAPqb9r86gYGRMXuNtBzSZKlwPIb5tTURdfZkzp0/ND0eRv+HIENZID4H3K
	 yi8FseuafmpnH2T/iiFUbZ0xzUz+6yVv/2ESfAhe+S6gmKIqaR5NOhLPKQETg+DD4ZpPM
	 YyuuCELFkU8ut0dyMSbPzatqLcdsrEseBl0At6K1KYgx7pxVkulGtTnkXG4vKjKM0Sdd4
	 uJklQ3m3DRnGKh/vvNOI0zbDo9Nym48asEIdWH8WN5Nj6ildSriQkm8xzkastsUPokQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vRx39ZDuM9PcKrNrPUV9Hjeptkv5Cvi3rgCWzhQzGEY=;
	b=NoPpa5bpPhPwTJ66wfzYJdgCDZSJaZLFRKt6xKu8NLnFSZ2GX/K5Ao3ggg7GG8PEoPMl
	 PUKQ0pAkIxXmYLq0ZcbIpNFZ5b85rj6zRytkDztlLSk8SEG5ecJdgUzkbzMaqeOL/lmtb
	 yhv6Ne+z3s5nPLy4nRhSPxP26EoSPTSV5yt7xym+cdivEzZdw2k0X10q0S96LQ5674C4S
	 eJgFrQWwl34CbYpB+yJaX8mUpNzU15eNJ62b/E1LnXwI2O4QZNT0bmffJbRDfdkVhdn+B
	 jKkYRU6VskqcFuU/xx95ngkamK30uZ9l6BWIraYH7G+AeYUCedMX6BEhmoZrqVM/BqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkLghbfI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1760A2608;
	Wed, 18 Nov 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkLghbfI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F91F000C4;
	Wed, 18 Nov 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019249;
	bh=vRx39ZDuM9PcKrNrPUV9Hjeptkv5Cvi3rgCWzhQzGEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkLghbfIuLpncc6xueJEU70XiIt3/A8Jvzx3/lc0WMI/yCIVDLaPrOGddM89Q1E8a
	 8z0/5Uqvu01mDOPC91EVfxXUtfPoR0O9HEthBXocH8oecDhp7z54EsosSOLZDjfxZN
	 t6/x2dN2Wt3xcCQZGF4nznF4R398Ci/MMdg9/q64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1488/2651] kobject: Fix the kobj_set_name reference in kset_register() kernel-doc
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150341.585588865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3aac49b236c137fa77b97968d25338a28c49f0f8 ]

The kernel-doc comment of kset_register() refers to kobj_set_name, which
does not exist. The name is kobject_set_name. Say kobject_set_name.

Fixes: 1662cea4623f ("kset: fix memory leak when kset_register() returns error")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260911222029.7267-1-kmehltretter@gmail.com
[ Also drop the misplaced braces in "allocated by()". - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index e7b010a989fb9..76214cb6fd5ac 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -855,7 +855,7 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
  * kset_register() - Initialize and add a kset.
  * @k: kset.
  *
- * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
+ * NOTE: On error, the kset.kobj.name allocated by kobject_set_name()
  * is freed, it can not be used any more.
  */
 int kset_register(struct kset *k)
-- 
2.53.0



