Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96314288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDtPRRnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F3DC433C9;
	Mon, 16 Oct 2023 08:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445800;
	bh=vZH1mSBO/jKdSsopvDVjbgMR1QWjfidDel2+WWAxP2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDtPRRnw/U5qNH9vcEKIZYIHRdx+4vH4lguR7Si8chNVZ1gISfXE9dE+/vgW68nc0
	 sBV1CiQGY+DzMmj1Cbdc8VjE+6o3TDPV4cKohswHxt+kHXUMvr3IDDbknSIk7mm2cm
	 U035DvJL6nzcXR/TFrbezU+l0aMc0nkgKgyArPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Xiaoke Wang <xkernel.wang@foxmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 011/102] lib/test_meminit: fix off-by-one error in test_pages()
Date: Mon, 16 Oct 2023 10:40:10 +0200
Message-ID: <20231016083953.990262737@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit efb78fa86e95 ("lib/test_meminit: allocate pages up to order
MAX_ORDER") works great in kernels 6.4 and newer thanks to commit
23baf831a32c ("mm, treewide: redefine MAX_ORDER sanely"), but for older
kernels, the loop is off by one, which causes crashes when the test
runs.

Fix this up by changing "<= MAX_ORDER" "< MAX_ORDER" to allow the test
to work properly for older kernel branches.

Fixes: 7ad44409cd3b ("lib/test_meminit: allocate pages up to order MAX_ORDER")
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_meminit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -86,7 +86,7 @@ static int __init test_pages(int *total_
 	int failures = 0, num_tests = 0;
 	int i;
 
-	for (i = 0; i <= MAX_ORDER; i++)
+	for (i = 0; i < MAX_ORDER; i++)
 		num_tests += do_alloc_pages_order(i, &failures);
 
 	REPORT_FAILURES_IN_FN();


