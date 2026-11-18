Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025888;
	b=JpZjFN81NW6qk7T8T4HOCdR4LobsX1HPK0vTfgu+9cemunDM5n7X6VAYuA01/5HH6rC+
	 to0qHfXZnUf11hfh3PIq3yLMN06dMQfxOoGnyzpjNQt83mBm2EKS5k2Gq4lQhXkcAWpRd
	 CZsBQ9fD88DEhNKQsnbN9KPEQDMkca0TLKDM31PcKpm9yvsNQePeWzVdyNbtZdf1k7vpX
	 qKhzHvYJYdUgbe7tEsigocx9XyDn+pRBbRw13+dVnfcYvIdlx1LB/T4RN50PebQ3+owAd
	 cgdrYCRT22ihE/Wh+5tPaDLzD88av5zsaZtcHe1mMlLap5N0w/fNs8yoImRm1hUvd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piOX3NcbIr9bW2rbnhL41xhfjwNz2e3CbBHB3l+IYk8=;
	b=COsBYOixJCOdFrCEBJVh7bnQneslCIX5M6VqKwRt+Ayb7uDjs+lL/FaqlCQaUXYfB36L
	 7TpjD6LWHCI/corlqfF5FhpQqcOQDw8bzT9Ems1YBbeteTSWch8QF1SFOdHl7zFD/FScp
	 oURbQGWdRcEhAViXRNn0cUBgklDSfLnd4besoLYiZHiNU0Tq7xE1gB0Et3jLElRXOhOUT
	 uPbIu8z9ma1IZkNkwpBQU1LYF2EqcjLanEPMDd3KkM5g07Sn9H1LvVqsrt1Gqr50GL1of
	 yGUvbxwT6iW2wh/iybZYwVhbTi3xcBnV8HBPj1DB0zB/LiMfTssWJHYWxcwjBPcWj+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcJuuYmB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA4E606A31C;
	Wed, 18 Nov 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcJuuYmB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1F21F000C4;
	Wed, 18 Nov 2026 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025888;
	bh=piOX3NcbIr9bW2rbnhL41xhfjwNz2e3CbBHB3l+IYk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcJuuYmBUQsV/xTB5GIMvYiOgHysdBdhI6Tl8x4+rsbsN/MQaRODbNZNn0Cnpib1c
	 0Yy6u3EouMqN8jILpmFqHfZ1tT0DAFbBlUsQ8xcJbgcdMfsfMJqskxfloWxhVJGsgP
	 W888TPEwPQb+w1p235UuUCWJUCxm2Khhz51MqHVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1237/2151] kobject: Fix the kobj_set_name reference in kset_register() kernel-doc
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150207.237278543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dd3d42a41d0be..116aea4a2d7ab 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
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



