Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028115;
	b=pG/2DfR+OhFD7uoFR4oF2TrNCh3GzoW+KYwiy5lIt+1oinM2s0u1nMyBoqH+WXcuqsoD
	 +Xl0Vlq3ZUmlS/oieOeJSDr7f7F3KPw287WdtezxypFElT7iN4qoooGMeWyr9lDL8NJAM
	 J4op/nsvuS1cMbPSC64aP4W6EgLEdHw7+5CEuafy0uzL30uJpSiPoKRUlm5/3ka9i6eA7
	 vd6xVAHNRXTGz5Kw2iRdv/5M9er4UguiN73Jlarv4mE6gRzyrKjnFhpjYlgPzGkOJSznI
	 2P1fKlv7o8ugEhHbBiOdUeVDpyAbFlTUe7cko6XAMYw8WUM0/YB6DfY7cMbKZNMuDJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwygOyvukvD31U6+W2yQ6BKXy1RYZ4ZoSMu33dUMlk4=;
	b=I5LeQ2FpFK12IlKLdsRnDtih2gF3bLnKcjV4mNC7pT7Dkmu00IRqhQD24fcwiUp6mYC7
	 QphOSh2eQ8mIi5x3dsT+vkDMl+8Bq+upXQnICMBVxtzoxmYvWWL5pr97ZPJEDf13d01uO
	 EPTxyVoKoqLS07U77PacRUDUbTZnpSWvxE/LLxk9P8uMe30UAiy9h3TqDQvYKRwERw0s4
	 9G1XgTpMSNtBvY2bsOxK6GfVLjZmfWJFYX7XKK9W/RAKB+dRbdeNX/u4wFYsU4TYQvANZ
	 RNzMmx2k5x4UEyv7K9G7SpsvN9LF+UbiedEg8D3OZSZuf+2MMLG5KG/muWguf5+1n0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exY8FHmA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A160606A335;
	Wed, 18 Nov 2026 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exY8FHmA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671AD1F000C4;
	Wed, 18 Nov 2026 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028114;
	bh=MwygOyvukvD31U6+W2yQ6BKXy1RYZ4ZoSMu33dUMlk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exY8FHmAlFTM0weNPqiuvHCApCsCD3Kp1lZu/Lp9bio+X4KCTs8GElUvjmPQ9Km//
	 Z2gWYhM1rgpnoa8WT3OH517AyTB26RyjDoeIKEg24hvvyM1r4nYQs22Tih3pJqgTBv
	 H54sbteIuddMJToUpfmOKVzX/qmZb4wNMlXm0SBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2029/2151] nvmet: fix NULL dereference of PCI endpoint targets
Date: Wed, 18 Nov 2026 16:02:44 +0100
Message-ID: <20261118150235.649839638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4a5ace11b5a367270bc86097d31c35cb61890a95 ]

nvmet_pci_epf_create_ctrl() calls nvmet_alloc_ctrl() without a queue,
the admin queue comes later from the host. nvmet_alloc_ctrl() passes
args->sq to nvmet_queue_tls_keyid(), which with
CONFIG_NVME_TARGET_TCP_TLS dereferences it, so every PCI endpoint
controller creation crashes on such a kernel. The debugfs tls_key file
passes ctrl->sqs[0] to the same function, which is NULL until the admin
queue exists and again once a fabrics host has closed it while keeping
an I/O queue.

A queue that isn't there has no TLS key.

Fixes: fa2e0f8bbc68 ("nvmet-tcp: support secure channel concatenation")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/nvmet.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 6a0d9b37443e8..9abf67fae1882 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -892,7 +892,8 @@ static inline void nvmet_req_bio_put(struct nvmet_req *req, struct bio *bio)
 #ifdef CONFIG_NVME_TARGET_TCP_TLS
 static inline key_serial_t nvmet_queue_tls_keyid(struct nvmet_sq *sq)
 {
-	return sq->tls_key ? key_serial(sq->tls_key) : 0;
+	/* A PCI endpoint controller is created without a queue */
+	return sq && sq->tls_key ? key_serial(sq->tls_key) : 0;
 }
 static inline void nvmet_sq_put_tls_key(struct nvmet_sq *sq)
 {
-- 
2.53.0



