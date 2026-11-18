Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055070;
	b=lXGHudIiPyTI+VBNKJrltRaDcs70Jlmtm2bjHVNxY3Q6pXmL8pcDPwPdL8d0fgSaxjEF
	 yOIXpjMoj3iJuzVzwC/hhUtIcFeF5Ec54VMeJ8YtWtdbrNd73OEE1nNQUELlzs3maU8oJ
	 LDqSu0ejla98COMn1+aONzgHHJ3VpTskZyYLJaAaabxcShjzIdeZZ9kMQCVV9eCdyOHR5
	 +Q5638A8Pp9D57PuIewSdqlMSc5kwCzTn7MnYPCBEM2Z9BQlIzGh4aBhcTKVmArgVzggu
	 Oa9pln+qGEixABOQV5b0kkSDG9tuxrxdJw/sC6xnx7xNKR5OTG2a9Od8fjVhgwVULdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ijVMt08KvdDVoTMkKjUBGzIXisFnaeafTjWNvs4On8Y=;
	b=GN/Fmtsyfk+5Cr0CwvSxkX4JJXUZwjCjKd282CCYO7zXJNGXf5m7sr9oCKLzsMqF+B6N
	 fc8njTNOYOO2EEP7sQOkcWcyHN75a+4k8Px7BRdlcDecA96Lg9LW3ULWFooW1Wucdr+oC
	 lfszq0R7NWoWOF6sctyNdmI0dXuK7o/gndWV272jE8RMl4TaLBdvj3x842RqyJJJb8Pc/
	 DFUhb48oDDh/5XVn1vwcQplPIYOlq49cC6Wf3fSZkJV7GzNIAzpKzrIXO8kvZfvguLEZr
	 L0Y2xLWFygXW8l+ebBjWEqfHyZJ0ItTmjyFXkvKtKvDQs6oKQTiw9euLSyLxEmM/rfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnv2k8LC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D7606A335;
	Thu, 19 Nov 2026 02:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnv2k8LC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5951F000C4;
	Thu, 19 Nov 2026 02:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055070;
	bh=ijVMt08KvdDVoTMkKjUBGzIXisFnaeafTjWNvs4On8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lnv2k8LCWi7E3EhzpQ/vXJY7oQA2909i9YnhzwOnQmn+wGWWzEPrdFapGLA0LYLfE
	 p7zsdqZitcb+AndmUNiQEKik/VeBDgzpCnQM+CFesymZtwrfBAh3acAWaQbqPYyTJe
	 SSmpcJK+lNcbOEnPgMYHZJX5qiuprp4JOGjGs/hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1499/2214] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150111.650605402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fe96979d2c62..d09e6430785af 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -125,7 +125,8 @@ extern long __user_bad(void);
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



