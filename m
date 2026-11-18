Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023626;
	b=W2sBMNe40YGgUso/MkxwqORhtdjEAkInIjIcg1I+PuDkfunWlmqzirT/1EYcZ6/pesjD
	 6gCbT9sc8ITjCQv2gg9Gh9lgRgmmlow1Mf59ZWUkZyrjNNMgSlV3ouLjc6uaa5Y5jbgOJ
	 cVYDUonjGG4IrRfKYpS4EChr8kjVkFyapHkbvPSoULesPYIwulU2Qw+bUmn8ItmAjz9VA
	 aNdGPEAl+xG7yZ5h/l05dwOke8WXnFsc28ZTYp44InW1MiOiJHW37rNR+Aul0e/f1BCtO
	 CjD5Nwo57xDq/ZFQhpDVSSeF3Bb2+CJi2UaSRwK4x6kz1CwBHyo+3+6hpo2DQpEOYXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=erbslA72A1JJcXa4druTBZnv+WymajTdiuPG+lo3vzo=;
	b=YITTp/iKxKdeKqPVtHLy01HrsO0nLDAqTVtthpYYjNsuS5u/edFTwloJOrudRJzWcwKm
	 YJgsp7nBL285hndE57SLlbrPiBSq/bzu3866J52vUWyN5DLJPpEaXdkWAv9cUBNpkqgwr
	 RQoICaOAjwT+gYsEXx3Wn7UZpvcaHSsPpCwNuiNXMfOcv3UUaYeD+doPUtDaR5kCX1hmO
	 6jNWm7yjeg7/7othKXTaP7JRa6ZMtvvqJXuay3WaAMadub20Th0fuDogwQ50m31gNQDbm
	 FZR4CptbCkBvhQo7Bng3S5nKyoZ7S60mzxmroH0VKd18vCw9PRaw/alsEKHN69JqxWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AV6gpEwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E99606A31C;
	Wed, 18 Nov 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AV6gpEwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA01F000C4;
	Wed, 18 Nov 2026 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023625;
	bh=erbslA72A1JJcXa4druTBZnv+WymajTdiuPG+lo3vzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AV6gpEwyDIg5qF9u12E0SFxEq7jFyRD5BmtsQnoL2yiNa2esaMZ+4c2RdYL1hbJHH
	 7+pLaLPlaKjHE0S9mnb7RR8ZXY89ZBtGVsTDAfGB5CAr20JA0HA5P52ZbYLaRLcFs5
	 kJF5X0q0hYJG9Jn1dUUYkW87jTFHbtSgpVwf6ahY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0437/2151] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:36:12 +0100
Message-ID: <20261118150137.957155928@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



