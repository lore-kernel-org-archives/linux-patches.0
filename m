Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D5D280CFB;
	Mon, 13 Apr 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098107; cv=none; b=cI0CBuzydJVK8Fenyhdjy8knphnTB1ow5ySSscyWvuPDcHd0cto08v/YTLHaThLj7Uyu7nAlkDklgvDE+Al2f320raDub3PoCL/VV71VzWPN2okNgipr+d0nybdwpIsQRde8y0As3Nem0SMwRTdRsrYJaq22KEoK2QGBdJgyX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098107; c=relaxed/simple;
	bh=Mlp+yksPZwCu+/zSPOrwAQRQ5A+SiteFyPEz5Z1uocc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D38g4gCTn8nimz40f5OjM+uGcAMN8ywDqfveOobGwoi8DxPvbnKgeEAUDb+ymS1wzbqNBv00oGrcRsM97t4c+wj4qULLic8iuGMmX4BtlS4VASEAxFwT2rWq+1EIEf2l8+lpZAIS14fUR5IxVJCooGlh3IvsaRatbNgEqINLeVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meURoTgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meURoTgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB51C2BCAF;
	Mon, 13 Apr 2026 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098107;
	bh=Mlp+yksPZwCu+/zSPOrwAQRQ5A+SiteFyPEz5Z1uocc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meURoTgwg9F3eOSsdVGCz5QYWiNK6KuQuWvHVXkvt+NDJ4SN5QQ6K/s8Z5/UOEJwh
	 3kJyO5o5mFDnedSChW+5KH7XI7q4gTqWrNfFVFeRwGj0RiKZC+fuGDYJ7ajoMP3NTO
	 6uUKp2SijmUqrfjL4PMALxYRQ3EoNFUwe2U+I7H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 369/570] s390/barrier: Make array_index_mask_nospec() __always_inline
Date: Mon, 13 Apr 2026 17:58:20 +0200
Message-ID: <20260413155844.302129505@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,8 +56,8 @@ do {									\
  * @size: number of elements in array
  */
 #define array_index_mask_nospec array_index_mask_nospec
-static inline unsigned long array_index_mask_nospec(unsigned long index,
-						    unsigned long size)
+static __always_inline unsigned long array_index_mask_nospec(unsigned long index,
+							     unsigned long size)
 {
 	unsigned long mask;
 


