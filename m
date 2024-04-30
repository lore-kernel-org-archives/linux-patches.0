Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAABB12B176;
	Tue, 30 Apr 2024 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475027; cv=none; b=qwT+4iLMegOO+ZeBkuRvNuQdgT/7cNn+8T9YycvYhzFnZz+LAXsK3V9dsMl88gcIK/79RCUk0GtIurcVvWGl8NUonhCNtgMOY06tq32/74lU8sxfWZGTVlpoIbarLF2Cb+IgL/BbdPO1h2HW2DCO9fwnE94E7h5hynuSI9iF8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475027; c=relaxed/simple;
	bh=hP3uZzoK0M+HzYdJdnokbgZVz+ozPUA7Dl+hH+gZNdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3FRqz/Rm9y4cS/Ngzlx1ZmQ7HasCunMkLNvmUl73eUPdKH3WbnyzUNdApfyt5VMwtMq3P01V1rkGAMvANpbgycG9AatL+uRQn3CrvVmJ0+Xtjvd5jdYLeoGSSBEee/jShAN+ZhDHnj9kQ0Wvrq5JuT5jAyCt3oOhiz28j8X6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=en/fALoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="en/fALoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9845C4AF19;
	Tue, 30 Apr 2024 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475027;
	bh=hP3uZzoK0M+HzYdJdnokbgZVz+ozPUA7Dl+hH+gZNdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=en/fALoFSA6MvK9ehIc8um19vvjYrkeRO2ns47aboB6vF3yah/2EaBWJW3bI9Q82+
	 G9yyfPIH54IZW3bPM8VXRdMFzkMk/C3yLLbms/LuV3qsq4R9iccmpOk1plNcuAZ9Ly
	 OjLzWgWU9QPQ/U7ZgiYL955GJkdmvCgGuPh5r228=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 109/138] Revert "crypto: api - Disallow identical driver names"
Date: Tue, 30 Apr 2024 12:39:54 +0200
Message-ID: <20240430103052.619564386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 462c383e732fa99c60aff711c43ec9d6eb27921e which is
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


