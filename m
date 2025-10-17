Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E15332903;
	Fri, 17 Oct 2025 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715510; cv=none; b=qKhLtzhPIoFg2ppPMo5jbet1U2Xl9BUFjYHPfoAsV3BVz3FDECmteD6aES/iW/N9phbR7HwQoCSdxzJcjwSl2R0LlHw/r+Ksdg8EWmyaFmCTUQ3h/Hj4SLg10LwZcyUiKr5xu6P5msj/7YrvDpvzc/DLOjs+kZfd4rdczrXJG6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715510; c=relaxed/simple;
	bh=Rx58Q4Bzprceacy6NkF2dZ9eM+lHff+vYo6f+Mh3TJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzAd29zsu/CHUwKW/BXNz8kJt6hzmz4eAWqMhSef7aUd5XxNo5BtbQaOzm0FdnccdEopx0KJCTS/c90Wp9+rkJPe1gWDZyyj8vbshAyt5oDCx+wbK2Uw95A1Hfok+6GLgRkTK32/Xj0pBRchmV0WgNc5VsIGtP6XgWzTHtAERPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/7Fc5p6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/7Fc5p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EDFC4CEE7;
	Fri, 17 Oct 2025 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715510;
	bh=Rx58Q4Bzprceacy6NkF2dZ9eM+lHff+vYo6f+Mh3TJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/7Fc5p6DpWGiXncSmBOR3zH/2UdhtRobfyB2BAfIBRCt8b9/XwZ2mBDKFQw0WrCW
	 2WXAFO9BO9GFATtuNxJXbGFwhxK7mr5w9m6sO9YbXiDLhp1/fniV22K3YICqPoqGqR
	 FQ5jO2hr/SciMdTwevVqSLOWkyoaOot7mruKpOsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 242/371] parisc: Remove spurious if statement from raw_copy_from_user()
Date: Fri, 17 Oct 2025 16:53:37 +0200
Message-ID: <20251017145210.833546625@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


