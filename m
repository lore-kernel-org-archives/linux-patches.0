Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816B7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC0C433EF;
	Tue, 10 Jan 2023 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375746;
	bh=NO5k0c5KZ88CxndTd0TEBkca8IlYz0s7pBQVwqf1iIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHeLnm5f3eW9au0xLdeTYqSkHV3RDCwcCds+m4t2gr6tWzr3p6xe99IIoDX+4HS9q
	 musYvvyHFl7G6cHg3Ccvz/rCYArEQRh8FcHCwKoslRAOAo1371G13TjzOiOTPs4yha
	 +NAJnark/3NO6fZKrOib2QRScTQGVouAU4DPGe+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 289/290] io_uring: Fix unsigned res comparison with zero in io_fixup_rw_res()
Date: Tue, 10 Jan 2023 19:06:21 +0100
Message-Id: <20230110180041.877930250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Smatch warning: io_fixup_rw_res() warn:
	unsigned 'res' is never less than zero.

Change type of 'res' from unsigned to long.

Fixes: d6b7efc722a2 ("io_uring/rw: fix error'ed retry return values")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(stru
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 


