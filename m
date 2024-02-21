Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F3A53816;
	Wed, 21 Feb 2024 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521214; cv=none; b=BvhXQ6/0AQegEGswLOk/HZDvNWOhvu1m/cm9UvP5+/Lw5oN8rolfGLdoy/dMqMxqf7OXWSUO+wbOhPSI4Zrd3tTkvsMnelyTMwFMLRYegBoqicqVSgK8ILMAT3U4Dz0NgNkBWgBSie3zCsVmlLKiWqjKhCuymgVYfzKeSSehjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521214; c=relaxed/simple;
	bh=g+Kpc4ruL3kD2MvqZsWlX92O/AdegvMBoLzaHWbPJzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyClewBQ8q4JnCN/Pc+KN2XdUy7TaRHQwVcqJvmfOv8+9n3+9bX5Uik+By/AqsOe6YXgkjDVcnGAffPB+maHcrwEZfBvkJeFbw2Fp3gK6QiC1Pd++wpSxxf08X/TYb1MeVj6tiGyisJTqxQIl0xg/5Li6RSQGsZeqt6QvyJkg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpzjFhXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpzjFhXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FAFC433F1;
	Wed, 21 Feb 2024 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521214;
	bh=g+Kpc4ruL3kD2MvqZsWlX92O/AdegvMBoLzaHWbPJzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpzjFhXQ4t/QpyQXaxQ8ZFmjJckB5++ELY10KnTs3UrBRi6r0ZSrKxZ6m6jkvdDS4
	 c89xmvG6ioT4/mDIx8CRGhUeG6ffFhCxJTVynChikJ4HtgKxjuUQUyZfW2gxdMTsgr
	 UQxKz4qcfA5EekHepBBkGRnesG3/+uyqmBLWunoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 011/202] crypto: api - Disallow identical driver names
Date: Wed, 21 Feb 2024 14:05:12 +0100
Message-ID: <20240221125932.118666997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -231,6 +231,7 @@ static struct crypto_larval *__crypto_re
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


