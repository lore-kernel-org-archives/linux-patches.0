Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8072FB632;
	Tue, 31 Mar 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976652; cv=none; b=KJ6VtXzaBFrMYLc7pfOaMrGT8wQ3FdLk005iO3YCA/HJZPxlh8f+1Atz3x7IWxf/4T06BEm4QskS2KqCIJfDw+PJrtnpAdviirlhdJ/RV69/4QzQ+lsyowl8NVGZeHZn6qa4LiovJoQxWue7PyJt7FdTE7/2dBalrjgUqtNVUlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976652; c=relaxed/simple;
	bh=H7ExqBNfDd8AzEiCXT5xia2CrUQ6T87dfp8hK0kRjv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpb30CAJjlhjYpRBXsfmys2OPfXbGvXSdPbYN9Vg03yyC2HvKEOvmI5xSVbdt2RAlRODxL3qZbYdKHkwJ9aNfjcdw7SR2SsvYqlyzH+sKIv0JovYQFh6FFctAn0AAgEg8qa0XhtNwFR0icOamAADXtRmtyaXtrjk7+cK+d0+oao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLdQHcCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLdQHcCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EA2C19423;
	Tue, 31 Mar 2026 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976651;
	bh=H7ExqBNfDd8AzEiCXT5xia2CrUQ6T87dfp8hK0kRjv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLdQHcCuvTbsqQR9KytDTxvSKTD0KtTqIBAtcdCf/AdcZKaUrnDaJwU4es3+RrEGV
	 lGrX6PSwAEghu25zgDMKog/9BVwyWv4BzGxh2uSuq95Onhj4ZsOmlFzBUJQai1X5Hz
	 j/2yQ4AiuVxP+SJvyileWRNivGs0znrS/5Olw/4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 176/309] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Tue, 31 Mar 2026 18:21:19 +0200
Message-ID: <20260331161759.944138982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
@@ -62,8 +62,8 @@ do {									\
  * @size: number of elements in array
  */
 #define array_index_mask_nospec array_index_mask_nospec
-static inline unsigned long array_index_mask_nospec(unsigned long index,
-						    unsigned long size)
+static __always_inline unsigned long array_index_mask_nospec(unsigned long index,
+							     unsigned long size)
 {
 	unsigned long mask;
 


