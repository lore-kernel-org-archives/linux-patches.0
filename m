Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016228;
	b=o4sagnq/L1G4jTGmonZwu7KPVqr2GpyFMuvh44RoH9HlMGQNNTqFbnrGlcBEItN4IB9+
	 KxsFAfJmFQ0JU98/0Qw1ED/TEAc9cqev2UKSP+BeAo3Ma3tnBy4GUx1r/WGqxhgEHQoo+
	 V0pcnh4Kw0YythICuhwz3M6bBZnbpzu5/X1ujwe0e9MAJTJnBjHw5BzqSMkvACngIjegU
	 0e9dcnIUPu1YZ9seA3L3ge3NvPkpmNF9cyq+2Z4SXMdwJLiJsoYDZbYgdkwdoN57nsMPf
	 9E3Mo4XjZVTC0ezwZnNG3PXEwXE8c3kuhV3X6Nf607CYm4zpYPBPROEAgE+ccIP9g0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kmrhpzwLHOVFIg52MG6x/tn/ms7/KXrCRHfbAm2d7DA=;
	b=qW2jsmalTsMKtS0GfTVq2K5+y1oKAJKvVgtovYuOonL+gWRACXjHx++l7h57YWT2pGkQ
	 sBQ47CdwkokgweU/C32o1JXtk5eqvets7NeFu3HputoDIDdwHhg4Hg9xaa/Jz12pxwVpr
	 x6DVM45fMviflzF4qHrQ6dyJcJT3HpSmaipsAmo57do8jKmrBJ6gagfgeRp63wPU+0wjB
	 X/aGhSAzy59woG2Io36fU7LbAqt4v4E9njn0a6Mvly7k0wlGbSAH1aT4lsmuY7P8Cm1SK
	 4iHEVUuZKKgzbUtjL4/yUA4Nu1A/7N6bk9jKclMF5IGRH/0f/aaV02xw/0HkApiJy2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpiYWnrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EEE606A31C;
	Wed, 18 Nov 2026 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpiYWnrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A946D1F000C6;
	Wed, 18 Nov 2026 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016228;
	bh=kmrhpzwLHOVFIg52MG6x/tn/ms7/KXrCRHfbAm2d7DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpiYWnrjAqZE8eatrmWR25ufmt4nrXb79nsnXDG16FeThBLc9wDYKLt/tlUwa+K9d
	 PbpSXri23tW5WeowJSI5n8KFn9pjA3edWvoVDSg+gitAKbmTRT5slDP+bHm7GLICAl
	 QJ8zQCRzG7UidrbiemXO8/o7wGOJnt4woGv9e5kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0454/2651] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:28:14 +0100
Message-ID: <20261118150304.151501112@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 54c35131e628e1a18f02365495a24a73a1fb515e ]

On failure get_user() is supposed to zero out the destination variable.
This is documented in the kdoc of the microblaze get_user()
implementation and validated in lib/tests/usercopy_kunit.c.

Currently that zeroing is missing.

Add it.

Fixes: 0d6de9532663 ("microblaze_mmu_v2: uaccess MMU update")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: David Gow <david@davidgow.net>
Link: https://patch.msgid.link/20260914-kunit-microblaze-v2-1-7d5756e858f8@weissschuh.net
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index afa0dd8d013fb..77203af255e5f 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -95,7 +95,8 @@ extern long __user_bad(void);
 #define get_user(x, ptr) ({				\
 	const typeof(*(ptr)) __user *__gu_ptr = (ptr);	\
 	access_ok(__gu_ptr, sizeof(*__gu_ptr)) ?	\
-		__get_user(x, __gu_ptr) : -EFAULT;	\
+		__get_user(x, __gu_ptr) :		\
+		((x) = 0, -EFAULT);			\
 })
 
 #define __get_user(x, ptr)						\
-- 
2.53.0



