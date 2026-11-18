Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031204;
	b=EmZpuiUN9Hg7Oko45+BQRqktBAcDtRKIFdttf1TQxhStpvibW3+/QJxv1YwhMrtGdNOv
	 Shq3gWz0THwv7IBbFTjxKyCYQ289+Gdc9mUsX3QPvg6xoLHyDtXce7xP+vJl5KSvKAZs2
	 dVomPozP7PiOJQT6gj3o1e/5tSHyfQxkyl34awcw0ZM0ZycsdqaeLQWWfNCzWyZpbTNdj
	 FvkptS45abIWuT4a+e3JJllF1E9whCOehWZpw+EbxmjLkUSXQBcglUXFXKrK1sYQlaMt0
	 ZcO5FjwtSgVd3bUqw1bhwF1P1PYWTu998mXo69SeEAfVk+xPHEeflQ5NWMpMPWBm/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tV/dZ6OJqb0LFQVgLgpgnkmd81v0rERwOhz6FJka9cg=;
	b=Fws9xWzkAdDst88YO0Qx9fynov9rFWnV0+JWqTzrUOe864daf73qNyaBUcBMOn9U5wOL
	 zmCUOR5aBqyvqg/VyBvSJqGcwnrfe7Rlu7cC7kyQ9sRqTpngfSgHRBmdWgrdPA6TBZhtQ
	 eEpC5kMqH5HwhMUNNaH1VTIMP6GMBZ4ARz/pNNv8LPkJ0+Wx/QR++l8lHkABdzkFIWimc
	 cemReGfo0INVGtnKpesQI+Y9B2ClNaUEadQ4/pi3wF5gedMypKaATf0Ag9JurMm+dotM0
	 lxEZZBKbtwhR0Gyl76pdRm1NP2d70IIHHoISElZEGH3QZRXlQOTYz3sWxe/kVG0QWXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4b8wbaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4703606A33D;
	Wed, 18 Nov 2026 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4b8wbaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13E21F000CD;
	Wed, 18 Nov 2026 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031204;
	bh=tV/dZ6OJqb0LFQVgLgpgnkmd81v0rERwOhz6FJka9cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4b8wbaMuT12ULPnIm2SOb0kESS++5r7VsFDf5u9835FRV+S0qe6mRIPtK9uZVOor
	 SlYDnLOktprKYNmcFi99uKiAK6X5v+Qv6ZYloqBr3qeTLFabnj+/aoAzYuKjaTF1Gu
	 Wn2+nP5ZQN8sSdkA1Xf6QQxLnxLQbrnMr4Ryikqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0977/1756] kobject: Fix the kobj_set_name reference in kset_register() kernel-doc
Date: Wed, 18 Nov 2026 15:51:44 +0100
Message-ID: <20261118150049.035984231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72fa20f405f15..1d930092a3f44 100644
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



