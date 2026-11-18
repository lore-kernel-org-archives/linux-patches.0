Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050632;
	b=yoM8XPP3baBTMHHTCwRTcnuvtdky8+mFzGXUHbhPFLAw/QwhnEDwVCpxwCHEDFNaVwvY
	 5m5bqh+FdCcrbYuvrahjqGLbIuypCTf63hseROmSmDILf6aD2Pt18t3aDWMnUe2BibNmp
	 jhEgpHg+fOFhQFBaFtueR0HJrIMrjzLn8h9HFm+XyGdjvy+DpV9vMRO+jbPr2OQc5Zh6j
	 RLEQv3rsyLk2aX1RgiONQOj+AAF9M9SP0lgTzRKZMw+qIZVhoYzEAV9bkmBxlxc74eWMX
	 rBAqBNWdwcrXKthuukON5wQzQk40yBCrG/phCS637HTLvGkw91pSbKt9HcFPFRI2Onw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ndWp2BkHDj6YNSoIuG8w60nakHRQriSa2gYO/HQSlIE=;
	b=wY1gRqYu7uPuXkem1Gd2Yu37ezlXlU92u1UaGfxEPsDsyWkfWztjmayd1oJkz+7zlMIM
	 aMxdjuBMZX9kmSvDpk0SJVMCpIbNjdNaZIoQgIb26hZ/d1L8M+GleQ9mH2zr1LRiA5Bh6
	 3z3QDBLDl6vUYHyPOAheUrgtPVq+ze91wSRd1kNqbEOUsD5VGjMLAj+KqeeS+R23/hZ+0
	 jDfg/5auO9HbeMh9a0r7Qt7P/FS8W1StJ/9QnKO48pk3we0mSN0r47NQpfkrWQKyiNs0Y
	 UGKj87acldbeAoRKNVxvTcb+Qlg1UhMDNlJukkEH7Q2f6sIN7aozBS8srWprA4X0kww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezK23J7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D71606A320;
	Thu, 19 Nov 2026 01:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezK23J7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077191F000C4;
	Thu, 19 Nov 2026 01:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050632;
	bh=ndWp2BkHDj6YNSoIuG8w60nakHRQriSa2gYO/HQSlIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezK23J7NivdkLUA7ARXQ0wujDqBiQV01u8/3luDJbyAPbUHBQqFRL/6h1ZIcoGMTD
	 Fl5YLd+FOeNe4+RZEIKGZA2mpmJk7MEjQOiee9flO5x7ebw7wquljksw6ooPRwzWIU
	 T04WpLuL2vfFZoc5/eOVAaTVd08eNLJXrotDEfeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2777/2857] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:03:31 +0100
Message-ID: <20261118150341.589081453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 2b646788ee24d895b8862514e12a95ce5d72d6cc ]

nvmet_rdma_exit() relies on ib_unregister_client() to flush nvmet-wq
through nvmet_rdma_remove_one(), but since commit a3dd7d0022c3 that
returns at once for a device no longer on device_list. The release work
of the last queue takes the device off the list in nvmet_rdma_free_dev()
and still has to drop the mutex, free the struct and return through
nvmet_rdma_release_queue_work(), so an rmmod in that window frees the
module code it's running.

Flush nvmet-wq after ib_unregister_client(). No release work can be
queued after that point.

Fixes: a3dd7d0022c3 ("nvmet-rdma: Don't flush system_wq by default during remove_one")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 629081e4c37c7..ab74f9d800e03 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2130,6 +2130,12 @@ static void __exit nvmet_rdma_exit(void)
 {
 	nvmet_unregister_transport(&nvmet_rdma_ops);
 	ib_unregister_client(&nvmet_rdma_ib_client);
+	/*
+	 * nvmet_rdma_remove_one() does not flush for a device that has left
+	 * device_list, and the release work that took it off still has to
+	 * return from nvmet_rdma_free_dev().
+	 */
+	flush_workqueue(nvmet_wq);
 	WARN_ON_ONCE(!list_empty(&nvmet_rdma_queue_list));
 	ida_destroy(&nvmet_rdma_queue_ida);
 }
-- 
2.53.0



