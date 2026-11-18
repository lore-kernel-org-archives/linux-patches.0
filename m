Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022132;
	b=cWBzAEBh0y17iEaZbiKTjPAbQjbfaCcPQdCv4aMWi8/1hRUU24Bxfs3ogTFxrkcSQUpb
	 VCRdTslOUs0C3HfUAs2/H1V5MxyVpboUUDUlC2XrEPpGMKT6I8T4RQeIm3IZ9fCg6Ucsi
	 0l4ZRAmr7B/NkaC12F967v/RffzKk/qaCeEPiuTMyVdxYxsUzDHu4X2Pf12ABcUaEztJa
	 +2ZEG5t2OWD7YowZ7Gldl05mDp3bIYAoJ4CImztmx35DsZqvko0SL4hoRZiG2/qq2pqx5
	 ouLaAGP3KJhPAHEVaIGQCNMqD1SIDtp6mVsWLQIn87LphL7bpUo3sfc9pzKcGbfUJ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DxEjdNmRVwjwKWsIVyLipyCZdEbwcIalgL6NfdWUcu8=;
	b=Nw9PO9pJjPXLuQVulTFGcBBbPILcutYzkjcMTIYMwleG36vtoHwPJc69eDOf3xrAOeID
	 FXQHQZD0V0Kw3f0Z0LtP4+3UrlOCKSTopDVCuSZtAr1aQtLDLo5+QTJv/38nF4gnQbOG3
	 RlRPKefmha+eTSumKu8U20Jc3DPIg4ghD26eSM5zFUNF8l6OHtQUH68PB712rsKt9dOZ/
	 kA0UMSBhnjUY4Uksir39yZSUlN56OhZMXc0wyi9uIuLmMeyEXpMXHttzvTIhiFaDZQuP9
	 Tu22hGeTW/FTAOrpCXMN6A4q6tFqmdIFur9zz7W/GOt9sscTZVJi+liYnrhAYUlv75A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOKsadfs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C55E606A31C;
	Wed, 18 Nov 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOKsadfs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610AC1F000C4;
	Wed, 18 Nov 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022131;
	bh=DxEjdNmRVwjwKWsIVyLipyCZdEbwcIalgL6NfdWUcu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOKsadfs0TNJdATr5jzftXbeyhpOqYqhZPVaRUacO8PFx2MhYAPdj4qWhwREl+EdX
	 h5Q89ClV8kRbaqzcUXg6a9zJ/zaPtbJzkTDHJMGAg+QH+rmf98Hgu888vPmbl3QREG
	 RvEw8Omkq09aTOqEA8gXThc+/Vx6a68KhOCnykH8=
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
Subject: [PATCH 7.3 2536/2651] nvmet: fix NULL dereference of PCI endpoint targets
Date: Wed, 18 Nov 2026 16:02:56 +0100
Message-ID: <20261118150415.886867953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 215315ebe42de..aab65ef2f24bf 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -911,7 +911,8 @@ static inline void nvmet_req_bio_put(struct nvmet_req *req, struct bio *bio)
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



