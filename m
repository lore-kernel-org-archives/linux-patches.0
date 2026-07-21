Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793124A078;
	Tue, 21 Jul 2026 20:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664594; cv=none; b=o55e/6IVj9XmQVnF1KEKZOsRtaEW/zKV6rHc54HQoCvCkh+Fmu/31xaqQcAtmOOXxgd3k+EWgrtaKtYalZp7J7JCgmiIqPe86rsqjSV/TcxEJP0a9skinBFt2G61uUbWQfXVq7JwKLvQK6UT/mWAZ4+x/9BfTUY+rjJdMPlVt6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664594; c=relaxed/simple;
	bh=VM5s2HVpoAqeN6k08OrEa8VjCPkRs+Tc7sRViyj1or4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8mlGOtTv1sMf5E7fzWHTaJckmJZG+YeBSZdALLbiJocjGunfjvUPOuUH3Ae4nHtUzEWH3FemCc+1RgKWEvidvk6+0YwkxdTuam6YdkJNHP6n1GaLBZKBGAJ7A1sQxJFoUjwZivR/ujgfocXoM2g/96cCLMV/CpiE0k32mZnKgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyUaxJxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyUaxJxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D9C1F000E9;
	Tue, 21 Jul 2026 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664593;
	bh=Kltr7B3m/AbrH6bMVNeVNbt3IAKwBkvgbRBCZohSsrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyUaxJxwc9grxUO9+FEJpeS5LHxfjaXdsppSlhNNu2xaNLPjPTZ0JILs5c17ANEoE
	 B5t5dhCCjBQkxu9W1oHRGxnU8WBrdsPe+p6u5WzUKmve5apcCkM+FzEr2FzVaN7gXM
	 Q7jmrotmpZBXxspd6qD/a5bJXUPRlrXxllEA1dC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 1260/1276] crypto: ccp - Fix __sev_snp_shutdown_locked
Date: Tue, 21 Jul 2026 17:28:23 +0200
Message-ID: <20260721152514.288201257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit 9af6339a65426b0b4850b07ff3b6959497bfcac5 upstream.

Fix smatch warning:
	drivers/crypto/ccp/sev-dev.c:1755 __sev_snp_shutdown_locked()
	error: uninitialized symbol 'dfflush_error'.

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-crypto/d9c2e79c-e26e-47b7-8243-ff6e7b101ec3@stanley.mountain/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1743,7 +1743,7 @@ static int __sev_snp_shutdown_locked(int
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
 	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
-		int dfflush_error;
+		int dfflush_error = SEV_RET_NO_FW_CALL;
 
 		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &dfflush_error);
 		if (ret) {


