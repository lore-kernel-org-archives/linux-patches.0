Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249A115AADC;
	Mon, 29 Jan 2024 17:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548195; cv=none; b=DGTHMcPf3IflVUbtgvDLjqx03Eg5WUZ3+cEXkhP9ofN5P3GrkftYoEVcScsmRLSTAilY6NOyEuhu70QmsvrrSqhcyRkM4zv0CY3uFof7EdEMTos6Nwz39MnMIn/3pRfLwNuUQ92ZKBaWQNqe/hTlWpCh6pVcTtik4+4vV/TeqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548195; c=relaxed/simple;
	bh=7Sz/VnY+uCYZ8ewkm8U1De8xRPxOot7qt8ptfPiXZBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgUl4dzaTz0g8BPI9FyufPaxqP3vntTWy5j2t9Nr/dS0eguWj1h2qyUYut6bZX1seEmaVtsUET/pYFRF5hdMsTpe7zb6tBkRSb85Kzb503zzO+PdFqVKaGmbjhl2gQ6oVarN1vQM3OjRi6cp0ZZk3m7pg1wrOHL9uYjWCNn4jz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2RXI+b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2RXI+b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B0C433C7;
	Mon, 29 Jan 2024 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548195;
	bh=7Sz/VnY+uCYZ8ewkm8U1De8xRPxOot7qt8ptfPiXZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2RXI+b6Rw3tV1FUDq5xaWz4PeDgBMq6MCM0NWQN3168C9HNcXZ5gWrHDn0HZo4aN
	 VdGmmJ+tIZ/4vj2UWgE1UaEvCuuQw2TvGGYDqseZDxRgayUF9GOm/9HvYWPA+IKrTN
	 QO2K93DfLRbcB1COTRQHHE3aBMM5wNAmN/rVxOak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 011/185] crypto: api - Disallow identical driver names
Date: Mon, 29 Jan 2024 09:03:31 -0800
Message-ID: <20240129165958.953575002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 27016f75f5ed47e2d8e0ca75a8ff1f40bc1a5e27 upstream.

Disallow registration of two algorithms with identical driver names.

Cc: <stable@vger.kernel.org>
Reported-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algapi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -290,6 +290,7 @@ static struct crypto_larval *__crypto_re
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


