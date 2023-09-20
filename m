Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933C18658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC3C433C8;
	Wed, 20 Sep 2023 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210619;
	bh=4khR2NFengDV1O9XAhKt0gTe/1Atd299eLMzrB0JRY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRqNrW8BIGFU4SuFJtEKcBsGtTWD4qMdOhn3cMeZWJ4IPqzXx61qf+JsjF/tCf7dH
	 KuXGG8P1o3/ZZgbm0+zGRoRVO/rBhKHmuBYJ8z2IXFQgIgjM2d+GMqN+FuEX3z9JEd
	 ETe2Xl0yzcwqufwDD+tlsssUP1M/m4RP8joLG6Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakshana Sridhar <rakshanas@chelsio.com>,
	Varun Prakash <varun@chelsio.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 143/211] nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()
Date: Wed, 20 Sep 2023 13:29:47 +0200
Message-ID: <20230920112850.282640475@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 1f0bbf28940cf5edad90ab57b62aa8197bf5e836 ]

iov_len is the valid data length, so pass iov_len instead of sg->length to
bvec_set_page().

Fixes: 5bfaba275ae6 ("nvmet-tcp: don't map pages which can't come from HIGHMEM")
Signed-off-by: Rakshana Sridhar <rakshanas@chelsio.com>
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 868aa4de2e4c4..cd92d7ddf5ed1 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -348,7 +348,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	while (length) {
 		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
 
-		bvec_set_page(iov, sg_page(sg), sg->length,
+		bvec_set_page(iov, sg_page(sg), iov_len,
 				sg->offset + sg_offset);
 
 		length -= iov_len;
-- 
2.40.1



