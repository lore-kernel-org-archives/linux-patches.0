Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060964;
	b=lR8ngQabYCJzY2nCKaJce7UmMA8rVzmHNC89bm56Oct1wF/tudvMwot2xdw+RfTtDV3y
	 eRt1GpwVYNK45dJH9fMQtF/iymkBr6+w8CSye3xmyY4s9YIv9mgJC1nVnaq51pCbf4adq
	 kUoovv9aOACOh9dWiuvzGKdYlsj7tZAm4zGmOPH6/w7qeGOCK1SAqXwp9Uf3AOiPo/t5P
	 gMk+Kc68zrG9HhE3GgoESh5JGNhpE2+BuRQ3S22Uh3LWipN9fJ8E72uU0BUqVxkEbV6Ac
	 LAKtJI1zhAGE+zTGwVg/hFQZTwrVyTv9P2RAJNf9FHi7Po6j4ATjiUMPQtjW1L7wGew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqrH97gGB93F2U2qWtn3orqJXRg36w0qTRnGzMsr0y8=;
	b=tu9G3VrVi8b6hei/ia/Gw6KNzqrfCUFLSjBPLCF46qODNsWAR1ujG13TQVQbHC24BoGQ
	 IDWTBV4ukoyYnOdWqEg0z+9agcLJLKfs+MGsRNiz9RXW6L4uWEb15s0ghEdj+yr3Ns7TZ
	 Und7HIC/FaO9EznkxHQVj08I5A0sAqqMPLMZT1cbbrmJ73dZaNEmBD36wfx0yXxEJOZTi
	 PStwKIl7iQ5BzWSuxFXfDsZ27g7TBaW52FNE5+RpDsX0IFFEVjXUIk8XoEsmiMzvyn7bY
	 TRMyL0lxzLTCORA5v2nVDlRpCSZoafpSprBp9iCCtVEgIoOeoz4X4Y92Yp0DzpPPzfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5++39An;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2E606A330;
	Sat,  7 Nov 2026 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5++39An
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1151F008A2;
	Sat,  7 Nov 2026 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060964;
	bh=kqrH97gGB93F2U2qWtn3orqJXRg36w0qTRnGzMsr0y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5++39AnlgcDx1LNUFcMRGYn8nfrCvEnPJMZorKkH1I0uzuzTaV10sAjYrICf0HrX
	 9p+exNXoVZLkDutxUES0341G8C3DKwGx+krMSH1tqflnisJ3XZahVGhGSyRFbQhHz+
	 r7K3xAE/7sC/ezINiRYfNgaIaBHtGNZCP8yU7RUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0319/1536] nvme: ratelimit the completion-path messages driven by device data
Date: Sat,  7 Nov 2026 08:38:55 -0500
Message-ID: <20261107135006.680313574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit c05c86681170e381e24498257db3a879deb1ae89 ]

nvme_find_rq() and nvme_handle_cqe() print an unratelimited message for
every completion queue entry whose command id does not resolve to an
in-flight request.  Both are reached from the completion interrupt path
(nvme_irq() -> nvme_poll_cq() -> nvme_handle_cqe()) and the decision to
print is made entirely from device-supplied data, so a controller that
posts a stream of bogus command ids drives unbounded printk from hard
interrupt context.

This is not hypothetical.  A single boot under an emulated controller
that posts invalid completions produced 846 "could not locate request
for tag 0x0", 846 "invalid id 0 completed on queue 2" and 123 "genctr
mismatch" lines.  Once the tag set has been torn down every subsequent
completion resolves to nothing, so the print rate is bounded only by how
fast the device can post entries.

Ratelimit the three messages.  The information they carry is diagnostic
and repeats, so the suppression count printed by the ratelimit helpers
is enough to tell that the condition persists.  This matches how the
other device-driven error prints in the driver are already handled, for
example the status messages in nvme_log_error() and
nvme_log_err_passthru().

nvme_find_rq() lives in nvme.h and is shared by pci, tcp, rdma, apple and
target-loop, so all transports are covered.

Found by FuzzNvme.

Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 6 +++---
 drivers/nvme/host/pci.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 5985cdd4c02d6..70cd76e32226d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -596,12 +596,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
 	rq = blk_mq_tag_to_rq(tags, tag);
 	if (unlikely(!rq)) {
-		pr_err("could not locate request for tag %#x\n",
-			tag);
+		pr_err_ratelimited("could not locate request for tag %#x\n",
+				   tag);
 		return NULL;
 	}
 	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
-		dev_err(nvme_req(rq)->ctrl->device,
+		dev_err_ratelimited(nvme_req(rq)->ctrl->device,
 			"request %#x genctr mismatch (got %#x expected %#x)\n",
 			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
 		return NULL;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index dfcc22e1d32bd..df08ebe13ea03 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1125,9 +1125,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
 	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
-		dev_warn(nvmeq->dev->ctrl.device,
-			"invalid id %d completed on queue %d\n",
-			command_id, le16_to_cpu(cqe->sq_id));
+		dev_warn_ratelimited(nvmeq->dev->ctrl.device,
+				     "invalid id %d completed on queue %d\n",
+				     command_id, le16_to_cpu(cqe->sq_id));
 		return;
 	}
 
-- 
2.53.0



