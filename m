Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C172C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A572AC4339B;
	Tue,  7 Feb 2023 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774781;
	bh=6FP4Up7o4YKU+iBZLQkTAcD4vL7Bjdx0l4DQ/hJdyD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNx7FKvfl3Kwu1JoB596wVFJ7TaqvMienVPnW5a1sUELMdat/1LzCZ4Ha66PFKtZE
	 zs3twmQpw+G5ZIilONEFWg08HeTlifXYyk6XIUoQCAvQbaUJuyHq20n3ID1cE8Uvhj
	 L97+oScUs6lTQEm7DWlkGtvz0cvSs5zY6F1TXRA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/208] READ is "data destination", not source...
Date: Tue,  7 Feb 2023 13:54:46 +0100
Message-Id: <20230207125635.775525088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 355d2c2798e9dc39f6714fa7ef8902c0d4c5350b ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 8546b8816524..88282b288abd 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -966,7 +966,7 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 	refcount_set(&req->ref, 1);
 	req->mp_policy = clt_path->clt->mp_policy;
 
-	iov_iter_kvec(&iter, READ, vec, 1, usr_len);
+	iov_iter_kvec(&iter, WRITE, vec, 1, usr_len);
 	len = _copy_from_iter(req->iu->buf, usr_len, &iter);
 	WARN_ON(len != usr_len);
 
-- 
2.39.0



