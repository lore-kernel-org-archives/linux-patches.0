Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA07233724;
	Mon, 10 Mar 2025 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630485; cv=none; b=qSF7S3J/8Gw34eHwjd3/mkijwq9zTnbpYQ8/uXDUoTFGQMgQYR+EHnYMAkvKJLqv+IK3yWdBLrCWEwKGMbnhYgzy/3SAE3U4YxLZ7FSoD5lgdiZf30fIbtp/HWZY8KB0HHfD+m8lppSJ9vNJzwMDbX96sYmOeKkcjCvyQmNn744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630485; c=relaxed/simple;
	bh=fqjoWfhi7L0dAtFiGz8u2g0IYrDdxigF9TNID90A76w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qapC/2zOqK7TWO72DU6tmer3ORxddGMJsGBDJXierZZ1y4i62FP1xqHFqpb36BJqmAZP7YeFTgKfBJ+/tN98OpbhGPDt93IFxXkgljMQO5TSMIbeJWOssLXz3FqghD3iB/dPxViwU+BmimrxxU2d86vxa67laBoIl4GCh58sP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpKjEEF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpKjEEF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676CDC4CEED;
	Mon, 10 Mar 2025 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630484;
	bh=fqjoWfhi7L0dAtFiGz8u2g0IYrDdxigF9TNID90A76w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpKjEEF4/TvII3536NtjB63+4QQssnjH0gkApnht316C4WUXR0NE/7RmEpzdGH8kD
	 L5oAus6IqoYopbAs9ERxKzEJpY8q7YtDZA55I443yv3prp4aK1vsftgfoAUXNowPRX
	 NCmCvQnFsAFKuvRWxnhAksGLBz4CalHEG/55ohlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei He <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/620] crypto: testmgr - fix wrong key length for pkcs1pad
Date: Mon, 10 Mar 2025 18:04:37 +0100
Message-ID: <20250310170602.611185706@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2be20a590a606..d94d02cb30d4e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1201,7 +1201,7 @@ static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
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



