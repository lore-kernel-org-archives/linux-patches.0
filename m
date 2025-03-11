Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DD825DCE5;
	Tue, 11 Mar 2025 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706058; cv=none; b=s1lJ4yJLJwk5scWqTq1ldFS02xZVtEq0OIxOcTEkwPBt53tpHZEkf4bRJlDH5etQeLKnUk29hXOMKX7w/IzUg7FlJw7MRlbxobcuD8k0H4GvOdZdKe3wd+DGq5JjnUWE8W0SEUqYu0N+rofUcqFxca78NHoFFmEuNU3GuD9goDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706058; c=relaxed/simple;
	bh=CWl5V36yBhoBu5v98m5SCXH15vOFoHPxhE0tPghfIKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwGkS6M8spayI698r6TBnhUBlRGM3vVyOK504emfDb2NYvsrlOQH+CdA1ZaiB3E7OhFKhGmO12mxPgMSieVIA8Ss68jeA2yo7kCK0IqvZb28M87f/JQUcq7DuhWZ1iKIIE0YrVMLL/Lour6uTgpgL8Y7ihTNsTyFDchTMVpEOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxBVwRrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxBVwRrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5EDC4CEE9;
	Tue, 11 Mar 2025 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706058;
	bh=CWl5V36yBhoBu5v98m5SCXH15vOFoHPxhE0tPghfIKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxBVwRrF86QK7MJ1FL39LgjMrYZW76G5bM60GDc5nNIjz7KQF5GTyxY6q1g1R/Ex+
	 1WKagOJywuedtq3oXpN9CoxGMqlX2FdrU9BV9Su25eMWXpSE/WkXq/bjnxa45SayoJ
	 SbX7WpFXfnE1nvPkJbq9LNEC2cldxllrsaSoieH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei He <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/328] crypto: testmgr - fix wrong key length for pkcs1pad
Date: Tue, 11 Mar 2025 15:59:58 +0100
Message-ID: <20250311145723.971269623@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei He <helei.sig11@bytedance.com>

[ Upstream commit 39ef08517082a424b5b65c3dbaa6c0fa9d3303b9 ]

Fix wrong test data at testmgr.h, it seems to be caused
by ignoring the last '\0' when calling sizeof.

Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index ef7d21f39d4a9..27ce9f94a3246 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -771,7 +771,7 @@ static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
 	"\xd1\x86\x48\x55\xce\x83\xee\x8e\x51\xc7\xde\x32\x12\x47\x7d\x46"
 	"\xb8\x35\xdf\x41\x02\x01\x00\x02\x01\x00\x02\x01\x00\x02\x01\x00"
 	"\x02\x01\x00",
-	.key_len = 804,
+	.key_len = 803,
 	/*
 	 * m is SHA256 hash of following message:
 	 * "\x49\x41\xbe\x0a\x0c\xc9\xf6\x35\x51\xe4\x27\x56\x13\x71\x4b\xd0"
-- 
2.39.5



