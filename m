Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FF1DF97F;
	Wed, 19 Feb 2025 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955981; cv=none; b=ESNd0XfCzMCGhUGzxV648B/DgZtqJcU8UVznsHgAkuFz4lYpj0zLKTsiXEdbEqqBYvSFnw2weFpMcmyqI/c+RuuThpJe3ePqcJT6jYopZv43rmNOk8bx9POjYFtpVEqfEQKAKm4X04gFn5YoIWLlpGeqXipyet4jbTAolci6UmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955981; c=relaxed/simple;
	bh=QTP0QjzmHCv79IJiQQcdaWWyR62VWVEQqRPazjQNsIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCPUf50DP+ANvOUgIFl2mmfXLL55G2pXN4xFkIc/7L+AJySmM+yqwqLMA4D/z7B75A9E5ttbHUyxHi7M6zeKZJ028YTgGYbFPJXS7baC6qoMr/FP+ZcbN1fTTxdIK1TmbmGjzljhQu8JeluAa+kM4C5PB81/IO7pFiWeDby+lJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScUQi5BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScUQi5BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7F0C4CED1;
	Wed, 19 Feb 2025 09:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955980;
	bh=QTP0QjzmHCv79IJiQQcdaWWyR62VWVEQqRPazjQNsIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScUQi5BNOsjFSK7be6tEbAqXxAm+Dc4ocUiYV1GGPF0ahoIBJPggOUN4+YLRCHzpw
	 x1HNyPSKdmn6CkUx50vTlYeqB+BZgv0193R7Y4fzyDo7dFjf8s/w55+Ajm8RHGSKnU
	 mfUzJVDnswW7QfYBDoOWHwVQECX4lsuKIzTCrfec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/578] pstore/blk: trivial typo fixes
Date: Wed, 19 Feb 2025 09:20:11 +0100
Message-ID: <20250219082653.187152189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@linaro.org>

[ Upstream commit 542243af7182efaeaf6d0f4643f7de437541a9af ]

Fix trivial typos in comments.

Fixes: 2a03ddbde1e1 ("pstore/blk: Move verify_size() macro out of function")
Fixes: 17639f67c1d6 ("pstore/blk: Introduce backend for block devices")
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Link: https://lore.kernel.org/r/20250101111921.850406-1-eugen.hristev@linaro.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/blk.c b/fs/pstore/blk.c
index 4ae0cfcd15f20..c6911c9997628 100644
--- a/fs/pstore/blk.c
+++ b/fs/pstore/blk.c
@@ -89,7 +89,7 @@ static struct pstore_device_info *pstore_device_info;
 		_##name_ = check_size(name, alignsize);		\
 	else							\
 		_##name_ = 0;					\
-	/* Synchronize module parameters with resuls. */	\
+	/* Synchronize module parameters with results. */	\
 	name = _##name_ / 1024;					\
 	dev->zone.name = _##name_;				\
 }
@@ -121,7 +121,7 @@ static int __register_pstore_device(struct pstore_device_info *dev)
 	if (pstore_device_info)
 		return -EBUSY;
 
-	/* zero means not limit on which backends to attempt to store. */
+	/* zero means no limit on which backends attempt to store. */
 	if (!dev->flags)
 		dev->flags = UINT_MAX;
 
-- 
2.39.5



