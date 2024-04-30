Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84AC8801;
	Tue, 30 Apr 2024 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475886; cv=none; b=AfvxKLquNHulxtXxkpYT6z6tdtguxbcc8rcJzqPsnhA/Hfoha5bJ3lUcNl1vPVQ8XGOnJpWOS/v4te6d7auxfEB9HdAlVKIsaw1/fIrIqx2NZjcrbVPgXShe0U/L7SdDoMIYzHba0IkgjvKZhdQ6iAgZc7sH+nn3mlRX8so4hJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475886; c=relaxed/simple;
	bh=A69j/f1y22bXD1Iv5dMfJpeaF6gVjGtyu7MUysaGG8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbsgtzXERB5PIr7GK2KRI+Mm9od00lEHX5CJHe9x5OGGsQTaOie5Yf0Xrlh0ooj31Fnx7ydI+6Js7zLFquXTOu2S7TO/9hsPnBbWG9D/wAtLnCzuATwcSDYgVY8QiutFgiZKHnQW4WYZ2bCFSg5913qqkBvQ3hApZI1UiXS0n2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahV8vyop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahV8vyop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3403DC2BBFC;
	Tue, 30 Apr 2024 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475886;
	bh=A69j/f1y22bXD1Iv5dMfJpeaF6gVjGtyu7MUysaGG8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahV8vyopPkzg5EI9uYSl2C6daMuAlNnyt1bhjDdD/xD4v/CFdJgIOcRUfXSur+jWB
	 0JiHVxBec5cb3mwNJ91kfHtTXWOQnJLX34V/vUQda/0OqMJI+K90P1IpT/Qo0CzGYo
	 jK97Qxwy1JNsE3c+WnHlIlk8Io336g2+rf+3EUHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 48/80] Revert "crypto: api - Disallow identical driver names"
Date: Tue, 30 Apr 2024 12:40:20 +0200
Message-ID: <20240430103044.837839304@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a6fec6324f518991d63360693224b42e0ea3144f which is
commit 27016f75f5ed47e2d8e0ca75a8ff1f40bc1a5e27 upstream.

It is reported to cause problems in older kernels due to some crypto
drivers having the same name, so revert it here to fix the problems.

Link: https://lore.kernel.org/r/aceda6e2-cefb-4146-aef8-ff4bafa56e56@roeck-us.net
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algapi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -258,7 +258,6 @@ static struct crypto_larval *__crypto_re
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
-		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


