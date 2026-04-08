Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61759347503;
	Wed,  8 Apr 2026 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671928; cv=none; b=FJlLCHZUqv8bWKjV6A90/EuhxQbUdSqFsV+RR04vsClfMME/BiPWmT2P9lHYGh9OpY/VVCTQ6qRkqCoRGLNFnk7d6qunJuho6eoa1T6i7cuCTGVpm0rkk5ApvREpaGawl1bqpLbcf1saz/BN/M+EqN1rnp88idL/0zS5sq7JtF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671928; c=relaxed/simple;
	bh=nLAIZngw9W+M5Yrp8BFwLlPQSdH5BDFVUx1b6D3wGP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mllyfLxtNuupqFdYp+BSZqGcbl8mtCapelB5Jv//Og70O/+xwvZs9NStDN5m7OZ1sRd5c4czft8Gg9+ZkTInG3rG+w3SwLfiGc4rGpPahIvcop3J/9CdG1JG03GELItJ7mZzRQm0hPKmjVhnuy0afey0I22gbJEhFCRpzRvd6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeOCLtAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeOCLtAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC398C19421;
	Wed,  8 Apr 2026 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671928;
	bh=nLAIZngw9W+M5Yrp8BFwLlPQSdH5BDFVUx1b6D3wGP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeOCLtAZ4CnKRCbgpP3z+J8u0Rvxda+znMjYeYt/ZLRus2zG0D6guPYibIhPRt/H8
	 M9Qh6u0rjBGkOwG39i6GaGWXd8ZTqwIER1gch2ADXvWzNyc+NsdZO9MedYay6Dw4kY
	 rk77FucSSxrh71BeCp+EXcDLzPsYARGOu+KM+D88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 090/312] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Wed,  8 Apr 2026 20:00:07 +0200
Message-ID: <20260408175937.107673134@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit c5c0a268b38adffbb2e70e6957017537ff54c157 upstream.

Mark array_index_mask_nospec() as __always_inline to guarantee the
mitigation is emitted inline regardless of compiler inlining decisions.

Fixes: e2dd833389cc ("s390: add optimized array_index_mask_nospec")
Cc: stable@kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/barrier.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -60,8 +60,8 @@ do {									\
  * @size: number of elements in array
  */
 #define array_index_mask_nospec array_index_mask_nospec
-static inline unsigned long array_index_mask_nospec(unsigned long index,
-						    unsigned long size)
+static __always_inline unsigned long array_index_mask_nospec(unsigned long index,
+							     unsigned long size)
 {
 	unsigned long mask;
 


