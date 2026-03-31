Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8083F9F5E;
	Tue, 31 Mar 2026 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974475; cv=none; b=V7KH9O01sMvAWx0K7reiAxOR/L+NLw3rpqAVKt5yr22NVOUjB7y+1CIIQDHTuqmRcvfmEZpRyUqPVMeYKZnqh/10hpJoZU9T0iszaSDIER8lRhP68GXQ0i/y0/TQlPcGOdB/QUxtBNGVskgITVZxmJAxz2qVFI+KegJiUwC0vUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974475; c=relaxed/simple;
	bh=2ZvVz2D6kqWDRWJlVu2CuzsVMEfgalrpsK2EOfFVyBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGmR0X6qxKAcZ9yiI49j1FacCB6qurWAI96o3RAKHc2fqASTcm1bqWAVdNe798t9y1Imo/2Tao+b4ACEnDjFGp2miY4CSWJDhxUHlt1WN1kWxjDjJcgP+OvIMYAKmLm4YlGdejBttZH2MAd0bCxf43si0+JO0lGFDBqNcv9ohWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzu6qfKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzu6qfKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57D4C19423;
	Tue, 31 Mar 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974475;
	bh=2ZvVz2D6kqWDRWJlVu2CuzsVMEfgalrpsK2EOfFVyBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzu6qfKygaXJUxJ+jDljPWBrnnfCbX/IxTnw6toXaLfSuFVg1/5opf3TYzfj+rUzA
	 HZavfyELfVW38I6ECQpV1vwGPR43TG5RrCeeDHnzkTa5Lg9SgXRLcGuslr9k3lfTvx
	 ZHcFStlVWiUPtYeeMuYcngogMvdVtbbFFjTn4oSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 099/175] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Tue, 31 Mar 2026 18:21:23 +0200
Message-ID: <20260331161733.416019388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


