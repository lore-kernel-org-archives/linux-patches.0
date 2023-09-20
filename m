Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0628E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B223C433C9;
	Wed, 20 Sep 2023 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211068;
	bh=U139mmxbUb7599rNLDhtspgdH7dh7BnWFb6FFFA61SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm8s6YUXlHyjDmzmFI4ZGvPZKIuqvmLWqMYNpiDTdc+Iv+/aXh/sMOv01PjpLBqf0
	 ERNFRz5co90IPh6irKGckxW1F1F3o7LMmrDDDjhEz1OCJnCI3TCRd0L2Tuqeszy5nM
	 rydohfCLmwHRRnCG0woOar2+rYtZKhaurNC7g4V8=
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
Subject: [PATCH 6.1 096/139] nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()
Date: Wed, 20 Sep 2023 13:30:30 +0200
Message-ID: <20230920112839.174791103@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5759eb503d00..5e29da94f72d6 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -321,7 +321,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	while (length) {
 		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
 
-		bvec_set_page(iov, sg_page(sg), sg->length,
+		bvec_set_page(iov, sg_page(sg), iov_len,
 				sg->offset + sg_offset);
 
 		length -= iov_len;
-- 
2.40.1



