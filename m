Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FE16A8D6;
	Wed, 21 Feb 2024 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521844; cv=none; b=pmryV3JClVVBz0LXykQzczIYPQ7HrAUTML6KAFzLMeaHEY3uHGioZSR+haInJxWAOnCHcIZ34Cr+/2Ul2d50Uuk18ug1xvhPg4RI/1G8Jq/VUFYAZ49TfKYlcRet7XBtSSBt08yplQoZsPRb58w6jpQLA7qNtJGTwIOuDe8AkBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521844; c=relaxed/simple;
	bh=wfgPBowR8X/6ZYZBhvEil41/tS6czf2ATbaDVq18fXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/IRiA2Jd4hv028OqAxBqUy9ssadiKfuHs9piPyzzmI89kHQeORGB/qpgAwtv5D/9h/uon3L7wTjifk2K8rRjfy+9QeIwJ3PqUUmHUafkxQU6kYHxnPdphqRrK/8t7UHCch0PETTt5DyuVW6Ml2U1C1mrBgTwMVwYMfCQgb7w3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT+0EbNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT+0EbNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A7EC43399;
	Wed, 21 Feb 2024 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521844;
	bh=wfgPBowR8X/6ZYZBhvEil41/tS6czf2ATbaDVq18fXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT+0EbNGzeVF6bsK6MlCp2y6R59KY9DmCngqRiTd1ow/FL8Q3cgnXEJzWYvmsgo6A
	 OlFNqidoSvJybAb2Eh/baQc6RWxGnJDyNtrBkcTK8RZjFSo5oYScK8alQxY2g8JiYT
	 XOnstrSlB5P1SUi7dpdprSfcwTqGmUdTpAjqzNC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 015/476] crypto: api - Disallow identical driver names
Date: Wed, 21 Feb 2024 14:01:06 +0100
Message-ID: <20240221130008.448540236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


