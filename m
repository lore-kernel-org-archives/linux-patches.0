Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048260;
	b=avue3tMq3lyhf8NfVZ61B99iCHMoOQdY20ATD+W87WZtN085GBmuAZ0+QHKonAG2fd50
	 LPC9nrzZ3FgL7PHJRYFuQrZ0EhS/4iZMEJTIem15EAEmcMXn/kxxu/BkurrqI9MZUHwzD
	 HrN9HC/bK+Jr6xi6nqbcK+gephWZ6Cc8wcq1312cJDcNiEhqZ62bjXYGfiK//PIBlc13l
	 RYN7KSGVPYs5HM9psl0D0VDZMfSE6Eb/mqO5c1/Kw23yRtlQDGBOBEdOqAMPiuWxwe+3C
	 u9us0rpGe01qnphvSJhEP6lrva1nC+vGafz+mKXxoinxkFFDLjUnwFpLSgMzhUWyLoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5ma3reD7eJqd7IEcpeP8x/ns/WogkxKL38g0YR3xiHE=;
	b=ZjGOJgxIjiR1YNoVafqEgki2hqN8AhWCiOU103u1TD5KW0jZ4UwY8JzKz/ENpqV6VZ9H
	 eyx2cAufpKlR18yX4AAFrIkduM7m3jDrh6XrMWnZqA8F9VWf0TZFpuavcGY3umg9dc36n
	 q+UgBqGGS6FIpbNPRpHsYHsAZeK0015oDeTrvJEaHUzObNjuI9c+nKyJzEO26RkkBTX6h
	 i9/kaqaNm7LJ0CBAxBFry9uZdvvrMZ4UCJZXtLI22ekEoaGEivNL8LqN1qvHJ7AT9U663
	 n0N+DIy8uq0kSxnS29AQlf1w8sIFp/x35I8jE/HEiSiGGKSGrkHHxrlCh9L0XFRehEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p11J08yl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0741606A330;
	Thu, 19 Nov 2026 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p11J08yl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A171F000C4;
	Thu, 19 Nov 2026 00:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048260;
	bh=5ma3reD7eJqd7IEcpeP8x/ns/WogkxKL38g0YR3xiHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p11J08yl07ITms8RKjV6xSWrloU3B+cuQ/6EtilJWefA2GuY0LBZ8fiCBHPX2OsK8
	 M5n5H7L+Q7U7WvAYqvGrGYb9NujKBayG+CKqkceNhf46Z4pBryDzCZ3ateSdaIfzXc
	 EHT1uuT9iZ+yKeCWmwI1PRjWT00HKn+N5iIiDJPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1930/2857] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118150310.704577583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



