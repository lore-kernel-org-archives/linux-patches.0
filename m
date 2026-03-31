Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADAD4035AB;
	Tue, 31 Mar 2026 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975919; cv=none; b=qlwEaR9aNVw6LetestO1Rd3XLbpz+M4Ka8gm8SDrbmudY3v0CQuANRo+FC4gYRLbKy7JcHECdPzIUowemTmPZWmAy7AgEsncLg8GbB0e//RrTXi85s0BtgsxbW8gSsrUSlDgqqMGQIp9bf/0FuXHZ3dKrPfpdnJWWYcH10eDenE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975919; c=relaxed/simple;
	bh=weeiqqYx6VjhLQkHhiHL8jNeI/7WHmluWC8RWQBST2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuPWcdpuw5ganfi6J7FEtpiuDj2XcI4BCZRnBOM9mByDBlF9Yuv3KhiXFrDUWU70Zy7qIEOCCXkMiCUsBAiCi/CRn3HeWZkBX5XeZ2cGyg1509Qtbnp26uPB7k5lMz8jByjJSS8NaPpvJ9n7GUcsgnZfc+DJS+ea/e0I5qNq3dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNmyhAwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNmyhAwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C60C19423;
	Tue, 31 Mar 2026 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975919;
	bh=weeiqqYx6VjhLQkHhiHL8jNeI/7WHmluWC8RWQBST2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNmyhAwyd1uDgj7i3Ka49mjSipkMP8ae182W8ER4bN/KvgzJTr4KLq8JdGktz6Dho
	 Wfvd3AtU2lRyMussPBrTQ1xeC7WM37iSxwLj1lR3adDtYz86CGq4SqobjWiQp/mzDh
	 fwFsXa4GMSFB2qhB43QwuH8xHCEviFQy9+A99gwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 136/244] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Tue, 31 Mar 2026 18:21:26 +0200
Message-ID: <20260331161746.675119290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
 


