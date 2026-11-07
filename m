Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063093;
	b=gQnoQqspW91HgKtjDWQ3ibxHxFxURq/xau+o7/prC7OXj7SdLYH834m2lJ9Cb+fuCc+z
	 LaLad11RF+cMhR9trKbFIatAMx3M2liPa+3tH15lygawOC2krF6P+zuK9CqthaqmoFIGo
	 VO7a7yDPhxONPsQaVRHJy4knG03lLvL4US8EJIziclHXtIWRBIqHHZsY4Uj1B+B/cVVXn
	 e30e7wEDQ/IUMRtI/MwlKO6C2iEnncI7S4Tn+mF+u3zF+jLMSwRafOsA56OSKJ5lOJ8YQ
	 h9AZMKgP6+R460RPIyVOzW4wGyTmljdtPOv1TDeESRJmPHP7aGSiMJ4ay9p0Ix3xCxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RN5rO2hSzyJkJFaza2x2aGBZTP/J/esYI/3ST41vGs0=;
	b=SHrq0wQRG/yi1OaaO283F65UbF00zeWAWXulRollT2n8AQ3XJUFE+c7pDwAtHQcYoIfY
	 euWw/bCzKTL5P/kASYKx3ur5q8XicTghlUivqMOb8tTbJeWmPCWYTJH6nOZgyOt353kBg
	 Iu1VmycfJh6io2P//074P8BYSutwgd7aOO5EjFa5UvapouMbSQeTrH7C4JiucNjs2zBP3
	 NKPtMTz5S0RaGvsmtSOY3+rF/htb2LxM+c22N8KfjC0pOlqDx7DhI8j6EGjmc/qVFBVlq
	 PW/mD9lN3QB41GClSnVAtbpdxZ/1E7naGTwBRwmcHFnDYjPjxQRX/SThpcOqPJ/Tr8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPeBBVkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38408606D804;
	Sat,  7 Nov 2026 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPeBBVkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE9D1F0089F;
	Sat,  7 Nov 2026 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063093;
	bh=RN5rO2hSzyJkJFaza2x2aGBZTP/J/esYI/3ST41vGs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPeBBVkElG02S/EmAVdGm2Jjd7lvfX5ePQyBq7+S64jzNUoKDIFVUVq4zmqxqDR9l
	 7YZVqcNAmMSQK2iULNBg/YELyqzI4ypW4rvCmWBcNkg87vZ+CNO9uKwU/EMLk9Qndz
	 alM6LyG9qU3ERaaAHVw5T8gsjgqpd5d0dqZf84jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/869] hwrng: ba431 - fix reported byte count
Date: Sat,  7 Nov 2026 08:50:11 -0500
Message-ID: <20261107134903.591136754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



