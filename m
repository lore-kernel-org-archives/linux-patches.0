Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029576;
	b=UaNUVUl7SBUASQMa6gmFQ7bNH7jipkYpTvTZz1NrIa3IFWAissVnFd3QRn9aL01TLPyx
	 hFoFCWt3OFZkHstc0wLASCB4ShCT5CY16QO4rrf/OI75DgowGQAdFzJ7PmfpRk+qgTSdW
	 Byw84u2MOZZvCINXGI7S2BgSBfMWTZPyB3lPQ9AMDSiLTVB+SSjkF582tYfqrSMu6wWBS
	 B0HawbQr3bgHSCqazQ6XIC6zUMrDUA3yvTxEJnvaoPr7rMAckaUEIw51xVS4sDa0+PApI
	 TPpGmzxOs/EkhIJf8A+C883/iq1USmy0tE2Ra/usrtONnTUS+7K+k/JwyqT+zCpbGQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y/9VJwS0YySnqng/y+sysAAzrJ20vXUUOKw2bAX2utQ=;
	b=AbdMRZtPtuAuPZpKj84/y2wEH/eWEMIYf52MGc0YdydgSyCSo9+04tN6cQaO2LQEAbo2
	 1rVVEiJIxdZZeUry9cxM2B6fJWMEhXzXD+UQz82G8o7s/Tc4BsjxRh+0qgaaUYIM4wCgj
	 z96EyjoFJXblTlw4nOSgwbM40M54pJ+VYV0UtjZY0Y+4j01Sct/dnWrymg78I5/CYPRNp
	 0wTG2pri1MUZ5CKuv1g8bSOhVXT6rJdsm7nVA/ViKRBk3busvT3jFEjGv9y4AWXpHv1CJ
	 iwq9f8agl70xjfvaWtxbD4vhUrcAL1LpUkAAesNIBmFMJfNXEEycVVQgeF+hQ4j+7Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khLTdl8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C110606A31C;
	Wed, 18 Nov 2026 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khLTdl8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D085D1F000C4;
	Wed, 18 Nov 2026 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029576;
	bh=Y/9VJwS0YySnqng/y+sysAAzrJ20vXUUOKw2bAX2utQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khLTdl8oGD0bsC7r+J/tgN+TI6lRO2mWhxZf8DRMkR7SQKjrLDkkYg8qsBrassY10
	 rTs0ny59/RHk7SddBtCFx/jzZ9bvnY3RLOjl4XPrf0d/8LyKBuT4vkAf+34KY+iNgB
	 RaCENKLhagaE1JSEerD0GrOvsq6SmkM1G02/7pcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0399/1756] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118150024.648533898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3aab2f17e0462..ea6653dc2e68a 100644
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



