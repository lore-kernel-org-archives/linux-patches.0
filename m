Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4852745E;
	Fri, 17 Oct 2025 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713747; cv=none; b=nLfzMkedpLMJMx7MbsaZYfj4qrEJhx4O46PoU01u1HhQ5zX1Lh0hDUpRHUq6epQ7tbknAYvs6+am6hjZ0fIitjweyq6EVGzI60zFxKgXtTuce0Ac5XAWAh7zigjzrBy6pfhFc9tVs0EezIsIdsk7JhxyUPhXQRGnaLVTuKLtFIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713747; c=relaxed/simple;
	bh=HAJdn1o/fG4tOwKMgd9BEWGXCIlQjRfy2j32Hm1jopo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ3FHD1L951/44pptexVNjuTVNc3u/2ycZJpIHeerqmrxkfJ/vhyRT2Pq5x3ZucU8YnwCIAuBTJL9qFIeHJwJmu03e6szUlBtQoyX+jqXmgLd8sQZWYsiogbRe+SPGxPTIrZiTxdxoE2Ylv8Tp2eeUK2YTpt7Y2rJzIlC/VUbzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHh8Ubrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHh8Ubrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B16FC4CEE7;
	Fri, 17 Oct 2025 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713747;
	bh=HAJdn1o/fG4tOwKMgd9BEWGXCIlQjRfy2j32Hm1jopo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHh8UbrtbSId8Hw3FvVR1WHRk5PoPlEDXTghNOF0Ry3u4f3HKKYaK1iMNF2exRwAr
	 5hNOunzerOPgocEl/x9Rf3XjVg5TqPO6aT9g/pPODF7+bYqJpdonRMy/woM9QPPscA
	 F8O4Pjrq8EB6H+KsKbA2gcR9sKcLGZWomTiJvY38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 105/201] parisc: Remove spurious if statement from raw_copy_from_user()
Date: Fri, 17 Oct 2025 16:52:46 +0200
Message-ID: <20251017145138.603187291@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: John David Anglin <dave.anglin@bell.net>

commit 16794e524d310780163fdd49d0bf7fac30f8dbc8 upstream.

Accidently introduced in commit 91428ca9320e.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 91428ca9320e ("parisc: Check region is readable by user in raw_copy_from_user()")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/lib/memcpy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -41,7 +41,6 @@ unsigned long raw_copy_from_user(void *d
 	mtsp(get_kernel_space(), SR_TEMP2);
 
 	/* Check region is user accessible */
-	if (start)
 	while (start < end) {
 		if (!prober_user(SR_TEMP1, start)) {
 			newlen = (start - (unsigned long) src);


