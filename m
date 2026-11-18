Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052452;
	b=wOZpQMW+bBmeyqMom5P+IJUbuZi6CoPiDJW8OoJUAnuhY+kB1peiwolY6Oz7AACGgT3Q
	 uLB8Bb1OH8Boy6LGwpstgeyELJiOST6pHRSiYXs7ftKscY5ZHzbBKLxeFDmdeIsvlH2td
	 diFlovejxZhx2z2WMNu/g6EWXyzqzt17mPDCPpdPGdse6LhpaYIxbUmEbnezQNxGa71WS
	 /zzmujeaAlwglI/j2oG8xqXwuBrCsqhnpLMWVORlgR2ouA/HgiuslXnR3RJbP7TeXbzFI
	 rziiEA4xAOHcBq2PG/hB4RBgSfp4Nq4gfqRvg4kVLhT08WLh1VCzMffw4nQuragfmsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2NU1DzagMyi6KM/LinQ1+yyAKr53GWaD3eEcIUGlEKI=;
	b=PVZPnvDbB/Oz3lSw/rgf89/5ba4L+aAM6SdKMgCA/t1tRpB6R4q95HGAxxGXeZzpULS4
	 j7kvyqdtyGUncUijX2zQb+RFMZf7NVRVEgCJu5z+EYQKF1aL5OHFPxG+06tencXUc8GRy
	 7iGe5UXT5ev7EVwlRhc+82BqS/673DBMv/06o+5FapkobYnAZiusXZcIoV9VPDLA1DKum
	 YlyXXzVhNEZQtmBMxlcqYzRDbbhXz7N7swWP17fj3n/LP0SIaKLq7NoRBTWlawyQ/UuM0
	 8LK0yQHeGcJ8D4J781TE8lhI6Snelnhj6EsJYSgq+XLlyqF0OJ/7c0oVH9B3PfUlUQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zJp/nqs8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4A4606A31C;
	Thu, 19 Nov 2026 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJp/nqs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7E1F000C4;
	Thu, 19 Nov 2026 01:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052452;
	bh=2NU1DzagMyi6KM/LinQ1+yyAKr53GWaD3eEcIUGlEKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJp/nqs8uUghGMF1tgm6hXDgVcM3NPbKEjU26WDUtDfUiVI0wj/0eEoUL3peJ8jKu
	 90ah5mP7ETtjnkezhpwGUy0GxbyLR6IzgNZg55uKe8aW1PDiG+wLK8q8pYQMSysDea
	 Zq1LNCkx+VM8QqG8e5utOtV/uCEHo+VoRTWr6iCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0567/2214] hwrng: ba431 - fix reported byte count
Date: Wed, 18 Nov 2026 15:37:23 +0100
Message-ID: <20261118150033.660102162@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



