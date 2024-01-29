Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5315704E;
	Mon, 29 Jan 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548023; cv=none; b=tn5yP2L/GTNpjSyqVEkR2uIBI2VrCNGQkVNxpQBWi18UyOAUlK4lBb0PoXMHQLMwcTLmMUZWHFfRwAw/tx44KRTdmBxskJ+UQZETmi0y8Q6rFv0dTy3VUcvY70rjfZvYa/olIqesnbc+Qj08/5I3ewoGHc7OIaz2FfHocyFgTCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548023; c=relaxed/simple;
	bh=AdYjquvG4nffkSTdVBMfz7mbwHwMCU2Nm/BmzmYo4Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kASh5X0kVdQ1B3uI/rzVWRxg/SPR8lXYWbgVOL8/tw1UljCQYa7ueHUd8yC8f9gthQ1whg2yLjHz9Z3sMtxXPkKtWbkPtlzAYeT7K1Fa1/RHreLNK5++JjX/qWbJV1wMaH9ihQEVQGJP7mAnMb9CI5V0CyCRFUpmzj3fyoEmivk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDGuHwya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDGuHwya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA38EC43390;
	Mon, 29 Jan 2024 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548022;
	bh=AdYjquvG4nffkSTdVBMfz7mbwHwMCU2Nm/BmzmYo4Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDGuHwyaue3OFYaTjNIIhf/pHm4g8wT44/0P2LlVH9jWF7EYnAo5r8NRXUXsNV2TY
	 MAU/1UaArLZOgp/QTjifcjwsO5LY+7TOa5R5ecRy8hXRE/2xwjsQ9v0oLMHjYSQixV
	 Td/8ojKmjVOqL+YNGt8rrs614X4cET3rwDAaKQx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.7 016/346] crypto: api - Disallow identical driver names
Date: Mon, 29 Jan 2024 09:00:47 -0800
Message-ID: <20240129170016.839038663@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -341,6 +341,7 @@ __crypto_register_alg(struct crypto_alg
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


