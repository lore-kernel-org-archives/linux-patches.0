Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DB311CAD
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSD2T5To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B73C433C8;
	Mon,  9 Oct 2023 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857249;
	bh=B5W2fhCjlN0Wr3vhK9g1b82Fi9x+Llhuu3Vb5aKTkuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSD2T5Toz5h6k90dc6a7Bu5RwDOYQMZLMnu/DUT/6Y+iaqMjytAjDk5mRglgqBsPt
	 ciVq1zAArzNulv4juLkgpXiRg8ZyUULsC4vgYKcCFLyBVeRn6USJAvtgEXxD7jIub7
	 ZYHc2uytneeiDIUWCDyfiYzyMT2yGCJBhK2SjfuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.5 146/163] RDMA/cma: Initialize ib_sa_multicast structure to 0 when join
Date: Mon,  9 Oct 2023 15:01:50 +0200
Message-ID: <20231009130128.064460754@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

commit e0fe97efdb00f0f32b038a4836406a82886aec9c upstream.

Initialize the structure to 0 so that it's fields won't have random
values. For example fields like rec.traffic_class (as well as
rec.flow_label and rec.sl) is used to generate the user AH through:
  cma_iboe_join_multicast
    cma_make_mc_event
      ib_init_ah_from_mcmember

And a random traffic_class causes a random IP DSCP in RoCEv2.

Fixes: b5de0c60cc30 ("RDMA/cma: Fix use after free race in roce multicast join")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/20230927090511.603595-1-markzhang@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4946,7 +4946,7 @@ static int cma_iboe_join_multicast(struc
 	int err = 0;
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
-	struct ib_sa_multicast ib;
+	struct ib_sa_multicast ib = {};
 	enum ib_gid_type gid_type;
 	bool send_only;
 


