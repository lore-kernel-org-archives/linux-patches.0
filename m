Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494B7BB19;
	Wed, 21 Feb 2024 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523649; cv=none; b=VEDALdP2/RNbMQyDS6h5C3dX8Odp1FbyUV338ND3S8oUpQ/u/OZQKcyKmauwgmRqt2WA1HNQGj7WXAVIB7+ZMGE8YtHucUw+6+xwdMnEI5wBmiwsGe+B3V6rSzE1P8foaYcgWoecNONADABqwCQQbLKBVBVqxlpkpDKMEAYG9iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523649; c=relaxed/simple;
	bh=1ZdRPm0uxxrhC642UEy7jSOi2ZAoHVtA/JOjfDC+JGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljE+lzjLEx8OOECi0BnkjFKLjU5EOcKp4raUW3JVBQjd3MR4o6ZmvuFuprl0vJuPYxDhJQdg4fg3+Oz2ArE33BiajwU2zdhFLMAezdM2oU8Cmqqysp2Sngr+TDJpAgAWip4Ld3a00ZywoTY3YId65C6Luw+G0EEfpgmaRArwFXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBFBWF3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBFBWF3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B861CC43390;
	Wed, 21 Feb 2024 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523649;
	bh=1ZdRPm0uxxrhC642UEy7jSOi2ZAoHVtA/JOjfDC+JGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBFBWF3I16GKuU2z6urOvpBjX3wy9jbLOskwavxzu7zkrjFuBH+97YIHIXDZiVjt6
	 S6usKnjJg09dIPOcL1d/+DJyUeHUm5TURxkOhxFPTtsl9vGMdQktI2j+SFNWVOim4N
	 FHrf0/4MijVj9fryHhSgz2IvWSkYUFhAHGVpljpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 018/379] crypto: api - Disallow identical driver names
Date: Wed, 21 Feb 2024 14:03:17 +0100
Message-ID: <20240221125955.459799634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -258,6 +258,7 @@ static struct crypto_larval *__crypto_re
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


