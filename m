Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5571B1E9B06;
	Tue, 11 Mar 2025 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707295; cv=none; b=EQVluqpt7L0Ib+vWzoTj1syh2AghZkobGJwQf4RIEQuKKJnbTYKr+yb/KCNLeRVG5J0HiDI1h84+cikUMrWp62exYlSg65F91+m1sXhsnH657aFG3FEbyooC1eiLaVVvepATlpAPD7BkwbH+5YtbCW5vXs1+3Td4+W8oE2n0vlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707295; c=relaxed/simple;
	bh=o5FHVfqmiIAFz8V9DeIJYR2kCj8tPYjoX1Hssfb7TiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=go/9GarcJXn2v2b6aPwJAmfe/MRSrrFjQX2hJGIPpvG3cP75gbh1V59IvPwGPLWkHJSEJbsMOfh9PV36pLuZB/SEqL7E3VGoOcDMXLfOkn702h8RFeol3UHbqy3/UueSXlBhW3X138SA2/PIjOKcDto2GeBZ/E3U/8IoJ0PvQCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0aUdJZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0aUdJZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFFC4CEE9;
	Tue, 11 Mar 2025 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707294;
	bh=o5FHVfqmiIAFz8V9DeIJYR2kCj8tPYjoX1Hssfb7TiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0aUdJZG8r8eLQdQQgXzmCYiBCgNSyj6bB4jtLezXyEW4qzPwDAWDRZhqGAQpQrlO
	 r/u3nrA1CByw2H2b5J7zdkh9uVXM7QOU8Dsd9ovKjXy8vEV2SmEaiurs6Dg9TrhV+m
	 RT5s2/iCovL7N6B2vt8stbAZy9kMLDuvpYxMq92c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei He <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/462] crypto: testmgr - fix wrong key length for pkcs1pad
Date: Tue, 11 Mar 2025 15:59:39 +0100
Message-ID: <20250311145810.727105690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8c83811c0e351..b04e9943c8c7f 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -777,7 +777,7 @@ static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
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



