Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046805;
	b=SSSsdaBzOD0lqB2LR6kL1s/+xgmYBHTQPMF5sf3SJB5DsOcYHCTyKNJQejpxRkYDkj3b
	 w5VweTt9tzQGlhfwC+2Ha9YctPntkJEY+CfimXmjlvqX6dxqcl30Hi3sF6qR/t1CXCpzV
	 U3k3bnEJUbWJv4eONIT8tyMJkH2db/SO0S9WUzebItAodAgXvaKHr2kTdeA6rYv2EMgep
	 N8gZ7dCieTn6zMudM0YEN6G6mO3iUwAhv75yiP7peP1lOM4/0hbUwFdc5rcicrGJlrCo6
	 IZhtfGVQBemXezn4i5ct3A69yTLTHxzWI8Cu3GpggakSIXCY7N/TNqr7VWK1wpR4nGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OixcR8WH7RcEuTJcwYfxtsk0R50wdzhjDZiZeE/pmm4=;
	b=d4jeOBwvQeNMmJSjb5MndFD4uBU4dgvhWLiDKtHbCE7hKP5YRKvwjgl0S5U9Ycfx+gLv
	 eCGKYCEmYU5Bp1Js48dLokIGF3P65Db7T2bgK0TRTCk+3SHP1hLDNfWedQG/O+0kBMPXT
	 A2d+8tS1M3sNPCKgEK/94ya4SbYZB2u7ibvmTFoEj9/Qh/0ZNjNztZi5c16eh3w9ivH4C
	 LlbukkPIRDlTvMkAAVhZZXJnRxC0U+GUX7VfpotCR8iQHN72s7JhOoy6OfjBM2OuGKofM
	 PLag1GKE/rzWgYQAfyODp9tkuwNz5htJuk8is3DzqweYbNcBONDG6ifbjWGzuVTlzwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xk2HdmRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC58606A325;
	Thu, 19 Nov 2026 00:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xk2HdmRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C607F1F000C4;
	Thu, 19 Nov 2026 00:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046805;
	bh=OixcR8WH7RcEuTJcwYfxtsk0R50wdzhjDZiZeE/pmm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xk2HdmRrHTU2zBFiSsPu2ocxkTolocBHTe3W80jm5kvcOlL9V0i8glDCjDU1XO3lG
	 cTPwD5C1qhrU/aKZxrLbxV2114S4j2IudDKMqjChPPdK5TCGHhy5s3n3KdRJoMzaHL
	 unmtoJzJ5rrZN3JrE8U//0oob0kooUYIVxi6r17Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Daniel Wagner <dwagner@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1411/2857] nvme-auth: use chap->s2 to indicate bidirectional authentication
Date: Wed, 18 Nov 2026 15:40:45 +0100
Message-ID: <20261118150252.140993116@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 4ae55a7dce04989f289d5c5c8c8e5c37adc36c71 ]

Commit 546dea18c999 ("nvme-auth: check chap ctrl_key once constructed")
replaced the condition "if (ctrl->ctrl_key)" (indicating bidirectional
auth) by "if (chap->ctrl_key)", because ctrl->ctrl_key is a resource shared
with sysfs. But chap->ctrl_key is set in
nvme_auth_process_dhchap_challenge() depending on the DHVLEN in the
DH-HMAC-CHAP Challenge message received from the controller, and will thus
be non-NULL for every DH-HMAC-CHAP exchange, even if unidirectional auth
was requested. This will lead to a protocol violation by sending a Success2
message in the unidirectional case (per NVMe base spec 2.0, the
authentication transaction ends after the Success1 message for
unidirectional auth). Use chap->s2 instead, which is non-zero if and only
if the host requested bi-directional authentication from the controller.

Fixes: 546dea18c999 ("nvme-auth: check chap ctrl_key once constructed")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: f9e43d924bc7 ("nvme-auth: fail when the controller does not authenticate itself")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index c741539afa55c..1679663bf8f01 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -344,7 +344,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 	struct nvmf_auth_dhchap_success1_data *data = chap->buf;
 	size_t size = sizeof(*data);
 
-	if (chap->ctrl_key)
+	if (chap->s2)
 		size += chap->hash_len;
 
 	if (chap->buf_size < size) {
@@ -819,7 +819,7 @@ static void nvme_queue_auth_work(struct work_struct *work)
 		goto fail2;
 	}
 
-	if (chap->ctrl_key) {
+	if (chap->s2) {
 		/* DH-HMAC-CHAP Step 5: send success2 */
 		dev_dbg(ctrl->device, "%s: qid %d send success2\n",
 			__func__, chap->qid);
-- 
2.53.0



