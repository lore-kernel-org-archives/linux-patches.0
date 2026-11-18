Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036238;
	b=Vt8bfhs7/gx94+RzRgOB33rjNFWRta2C3L1Y+/DOrlmmPHihx8UTT36StSEJW5hIIPSS
	 aD4Cl4d7zIqeBEb3tECJxM/Y2NiPjrdL8ZHhlXfDnzRf+s3D6cygsz1dJ634B5dXN0/6B
	 bGMy0b2iU0G8iL54bdlN1LXUpP7vRwTBlUKDPDpEicqIaHZeJMh0e74t7USVQenf7mktS
	 v8UPj/xFHhogsXuTaJWuTZUuB5RKzilCL0M2YDo0jFDeZGqVbr93hpXqNtSwmNLawQSRH
	 Xb+867Shlok73wNh7fiGL6ch26XaZsNp9LY7x8yU4hANLqDuJU0kAvnWiPqyzfhIR8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QLkqV7fBE9W2KtCXwF8cPdNwuEyIuN5F7wO8jGw6UzY=;
	b=ofcUXZlP3gcKUUSg/bQZ4jf9ewTi1xILfW1U6+mTj4GmkHGg5b81TARHX9HVw/Wovtbs
	 lSs2zj2CKuOI5XLcGK9fyPP1d5ASEXaCzWEIcMl/tC5dzAG8XKdzF6ZXGdah6UpGhnLNG
	 +29c6oSLHrmryw5qZXgb52jwKQRx8btPFQSLmxmA7vRgBGuHoeCt1sQvlIubP+Z8/Eluw
	 6DQ6CD8eCXzXotF8DMzr4A994swkegkLSbBOfRxqUiMriZMFFM9VPQHEKP78gyRZWEI75
	 yJAm28y62hM7XBx9XUi6VKselWmvcdjemWRinMF1zgdsLsfVXouhC1lVWkRJizCFixA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVZHLaw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BC0606A320;
	Wed, 18 Nov 2026 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVZHLaw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F471F000C4;
	Wed, 18 Nov 2026 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036237;
	bh=QLkqV7fBE9W2KtCXwF8cPdNwuEyIuN5F7wO8jGw6UzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVZHLaw2lgzP8h+n4L7j2fQQyG+NbngjApKJjvNtSKIP1K3/3QIPpBKBCniwbJoAL
	 pA681c8oyPQupvAb1oNiwRBisUwHD99jWYV0rl5IX9rxwDmFSTYA5HfPbFFcCvRmU6
	 umHFYfCXGLcLnhQRlnhMcJQWztLXraAO/IlZA7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0988/3318] hwrng: ba431 - fix reported byte count
Date: Wed, 18 Nov 2026 15:26:50 +0100
Message-ID: <20261118150349.430188849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e638679883ceff5b6e7b6dcad09c21a105e941f ]

Use the size of the buffer element instead of the pointer size to report
the number of bytes read. Since data is a u32 pointer and sizeof(data)
is 8 bytes on 64-bit systems, using the pointer size reports twice the
number of bytes actually read.

Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ba431-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index 9de7466e68962..c33fbc25b7cdf 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -148,7 +148,7 @@ static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		}
 	}
 
-	n *= sizeof(data);
+	n *= sizeof(*data);
 	return (n || !wait) ? n : -EIO;
 }
 
-- 
2.53.0



