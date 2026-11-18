Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045264;
	b=0vj0VgSNJZzTGJubFPyKm0am032P4SJqJGyAP/b6qj5o5ZO8JL8yUKIg4+IRJsJwQeZV
	 x3MJuS4+rS1EkKICcvyPmdfVugjrr9+TA9rPYw74D2qUtx8ayi+3nCiDeZ4zXSAhCOimi
	 OfgmdCUm/YBbEG0v/DjKuvoznYtCeQGcUr9L7K/4S7m4jsc6YVMMR0eldysfbrG6ehuuZ
	 6hY9YYRQOyUzuB4BwbQ5dmOoFdCTcNum3sw2AJDxRvmVs32iEeXBc8uANBvYUtIhHJsQR
	 5c4mPsEDhTqqEE8G2vMDmMbKLkd6dnVEWR49o1/4nNVXXqlnisnRBmYZmZXBZctAQXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrhY7WyjA+FtnEtvy0h/bCm70xqP5WuaBXj9h+00jaA=;
	b=ewfIXcQQG5JKY6PfExqe7YuPnYZbV7bE3kYDWYAg15GxQ4ZfmmutSW1kIn9+h4eaJJGp
	 O8KRKwmW+IHpvkZjH7NfV+K7ExdxOAWN093zv+gppplx//DfG4WfME5W83HPcB9Anepz+
	 dx5QeiV6wcznS2pU22bAm2WsJz0OPUnXqZBQb/OxKAVjnWlALRDFecwEhbHvQcPC/myF4
	 myj595Wc193qdL9G9T+GxJ+AhkdhKYdoagR6O6tBKkUVNcxF7e1vHyYdisu0YA7r1JQ4/
	 UtkU1c3PezHSaCGDUJW8ebTSsoPR8uFFLG+Xg0HSjWNhvObOFnWh9S16CYFQNav6Czw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jas5+D6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D8F606A320;
	Wed, 18 Nov 2026 23:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jas5+D6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860771F000C4;
	Wed, 18 Nov 2026 23:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045264;
	bh=vrhY7WyjA+FtnEtvy0h/bCm70xqP5WuaBXj9h+00jaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jas5+D6WT4guZna9n3Q6T/uaeAltbc+wdfmAdTPMGRgtTltPgv1vVDLD4nCbrVL3n
	 LsljxN1PNYfs88qGaUW/uQsEIY2WJkbqy+8OQ4BO3BW/SaZ3gzMVaOx2Mq9IEaXmOj
	 s7D9UH5Jf5/GoqSJ65KcgBHSk2ykQSxN2OjfB5dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0861/2857] hwrng: ba431 - fix reported byte count
Date: Wed, 18 Nov 2026 15:31:35 +0100
Message-ID: <20261118150232.566921439@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b7ca0416490a..787fafce8265d 100644
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



