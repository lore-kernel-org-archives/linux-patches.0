Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60583812E9;
	Thu, 20 Aug 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239156; cv=none; b=WOvd3mjQOekMiL+vuEqF4oCWZ29cfREznD7a+0+3IqwRy4mchEwWbi82ppSjMSBDUrWJK8botMf0GNoyH/IfinTdHEb0QkG6/pTraQYBE2/hpPUiHyUnkUIW0RY1uJdQMaYECxldTREgleWKDdi/FF5rVvn8dA/0VoJ8surWavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239156; c=relaxed/simple;
	bh=Idn92CpA9wcBrHIQEBCsUW6/Lcx2LRZm9DotM0HX3rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R39lA3k19DaKLXvsW4TzmeQPzX+89XavRdlUooSv+zaiYoh1B8iEHqPT062NzfdwMj0e1mn9decLFl2WotA0vjChdVlbDdLbbneuPno7a6rjVr5T8SDWNE+hxIj8Yin2BPPhK1AhlU3CGUnuQ9OYTW7575kbBJTZy8WvzSPmj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzc/GFK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzc/GFK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C291F000E9;
	Thu, 20 Aug 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239155;
	bh=1YEjdl4gZJQWu+B4wBLLskj4wZL0hWF7o9qLbrrW6+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzc/GFK+qOYIfHEU3kQWceYY6+h4YFXkg4s9B/oWy49mKLRjcer42CEIXiQ6KQN7R
	 N4L2DzyC/YFkp5SUvLbi9FbkcxGkiUgUr85/zyxPJHmv5tOwHC0oVHUL6FBihIPCEZ
	 fAyvu9AihAaqU2QEN+KPe7HJV8auPznZKH8ZTUTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/217] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:55:38 +0200
Message-ID: <20260820145242.859008947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 438f4896f78f69ec73d5f32d2c024193f1223569 ]

Set the maxauthsize of rfc4309 using that of the child algorithm.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Reported-by: Seohyeon Maeng <bioloidgp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ccm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 2ae929ffdef8e..916441e4f2b86 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -747,7 +747,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



