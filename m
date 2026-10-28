Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215827;
	b=gWtp5vkZ3q5uvnKnZpIBt+mIfyAS5Bb/5/k55Y4GdhGyY4H7WlJ3DbLrhdmfMlKUZSYK
	 zCrW9j/Du9360wqJaWMNqzgfViewOXkx2dV0EVXx7tIw+lr8moVOxbJ642wB+B71C6x/h
	 YYEB2BKZDnsPt8Y9jiC0tehkuP1oM7VJcfxWW2HXW663+Bl9bE1SIO/kq/05u1OSPIIoT
	 Xzzh2bss94uwzpM/p5xt11KmGx2q84SWkGjpYHWP9UGqIljFCbNIQZfDXZlX5HwTAVxu+
	 fhkEZbPzg/DMWhqdS0P3vJpRvhCwB/5a5xzYxRr3It49GmCvyNGV3bmMpEctVE/A3jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20p7f64Lb8BtwCgSEwiOoWlXUPH+Pa0b7cSuOHwdJ3M=;
	b=HzcinblOXlshAxq+6yKZofTyVo7PqcthIcI4f9jJ1cGDE3uXvV/spMDKrk27nIqj5wax
	 2zvidkeUwDycZVKWxbUlH2/v8HIatBE2W1ckNeyRKOzoWAu90yisJolDajHLyPLSounUQ
	 PZTV4BUysIAdMuXooAvTO++tgoc+XdFjSRsVCRy+ln8Kz1hZCpkxey/yTXWkf9Ys2Tqhy
	 y1BykGQnUoBpdsX7vZQrJs4x+R/w9h00Ywy8HBspH6HFyK3zk8aDFzIbJ7CXxthIGxTz8
	 KM325YEYWNJ+CigqysHRbslEDCoxcp6vTucD8+zZwu8HRFfqa/5l4r81ZsVoih8cwbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQRFtkBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC0606A322;
	Wed, 28 Oct 2026 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQRFtkBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC411F01825;
	Wed, 28 Oct 2026 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215826;
	bh=20p7f64Lb8BtwCgSEwiOoWlXUPH+Pa0b7cSuOHwdJ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQRFtkBirOoODDg5eKHhry/tlIkOKBuY5aOpLuU0HEh+jIFlq64SC5+12gO26obpM
	 9JMgZsEIcXy3+Wsq8dCNyViyCcnpsarttMX5wSZfLmvZFf7VQ2t3jK5pgH4HXzGRCc
	 2+C6BpkNg4cciIV04tSnRus+mVH7agG1BgW6Z6uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1346/1887] selinux: reject a permission value exceeding the class permission count
Date: Wed, 28 Oct 2026 17:57:22 +0100
Message-ID: <20261028170530.070388692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit d14b5d0e97fccd27974fedc03b903408872907fd ]

perm_read() bounds a permission value by SEL_VEC_MAX but never by the
nprim of the owning class or common, which is taken verbatim from the
policy image.  security_get_permissions() then writes perms[value - 1]
into an nprim-sized kcalloc() array, so a class declaring fewer
permissions than its largest permission value drives an out-of-bounds
heap write.  The top-level symbol tables are validated this way; the
nested per-class permission table is not.

Reject a permission whose value exceeds nprim, which is already set when
perm_read() runs.  Well-formed policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: tweak comment for line length]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 42bcd861bbfb7..e6aa1069fd415 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1126,6 +1126,10 @@ static int perm_read(struct policydb *p, struct symtab *s, void *fp)
 
 	len = le32_to_cpu(buf[0]);
 	perdatum->value = le32_to_cpu(buf[1]);
+	rc = -EINVAL;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
-- 
2.53.0



