Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488291EF38E;
	Tue, 30 Sep 2025 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244045; cv=none; b=KFsYH8OjvpsavALjAWcKJds5otdMmH3LaWV5zpQj1kFpFUBft56ezEhUMyM0V0b2FbRxv2Q9kBYCc605CHnSUoldX+PyABBkwor0qpD8rIbdVpsS6yrdWJB3mnEkQeXEc2sS6Q3APhctNFDOdLbx3gQyzt92BpzHomcipHilvig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244045; c=relaxed/simple;
	bh=ruFsigLX9ueZmM68zd5TGJVnpCNFzMoep46gCcEERuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7ZQICuQ9tJQFOGXtN3FySAKdIMbJVNXmSkX9gzLRJ1Fz/TNSWYqCBntT99hLo8iIMPZdnj8YS5MpQziRW29asCK83D/dDIcHst2jMT39KZ5zuiqfeyEjrs+IbZNA3R257oU0AErudvb29u8mM1KcqgqKoiWm5ljNPUUu0ZwinM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDR0cfRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDR0cfRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA675C4CEF0;
	Tue, 30 Sep 2025 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244045;
	bh=ruFsigLX9ueZmM68zd5TGJVnpCNFzMoep46gCcEERuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDR0cfRKSGp+azYBujA7nv58/MEVF9Gbpg7ar7FpuFVwqFFh1jLz8qepg8/0KWW1t
	 2mGaxbnrnVDyLdQMY6UxX0v1/sXS59IG8v6vwlMxalLE4GGqNmVcJl3CKzj+GBD+LB
	 himI1bG4JstkRYRmPYMHxB35HRPr8hEEMdYac2WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Keith Busch <kbusch@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 012/122] overflow: Correct check_shl_overflow() comment
Date: Tue, 30 Sep 2025 16:45:43 +0200
Message-ID: <20250930143823.488484793@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4578be130a6470d85ff05b13b75a00e6224eeeeb ]

A 'false' return means the value was safely set, so the comment should
say 'true' for when it is not considered safe.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Fixes: 0c66847793d1 ("overflow.h: Add arithmetic shift helper")
Link: https://lore.kernel.org/r/20210401160629.1941787-1-kbusch@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/overflow.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -235,7 +235,7 @@ static inline bool __must_check __must_c
  * - 'a << s' sets the sign bit, if any, in '*d'.
  *
  * '*d' will hold the results of the attempted shift, but is not
- * considered "safe for use" if false is returned.
+ * considered "safe for use" if true is returned.
  */
 #define check_shl_overflow(a, s, d) __must_check_overflow(({		\
 	typeof(a) _a = a;						\


