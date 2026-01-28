Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E73542EA;
	Wed, 28 Jan 2026 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614113; cv=none; b=R3uCTWxStCb7Yi+nFU7frJcqm4aHII1+338yoFEa1kHTxkVjOWUwJo+XaYM8VnE1gUUgNVFzqEp6ueBZdYy/kA4x71FMal4I4WacoaKK399k+0h24SWQUETxGF+64htzmVPD3sRtEs6hF108piWNsFsILROe7jgf0mAUHk5hve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614113; c=relaxed/simple;
	bh=T42rHDjysSOcneuJ9Z+wrEaM1ws0x+wDSyDXsyYv7OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxg6RiuxGrlzGkvdNB0yups055TgZY1sWInvx3H/btlYl9EmAGi70lzC4z9bT7VXmfmPChoaH4U1VcGBOW+aqvZ1BioGOPfXaJjRK4g5nBVuqh1rmmAZjqNDOz1iToXVRRFLW/K7jQr1D6FJoKKQI/0Mfg/0J467K1HyiHF+rac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IguMwy7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IguMwy7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24616C4CEF7;
	Wed, 28 Jan 2026 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614112;
	bh=T42rHDjysSOcneuJ9Z+wrEaM1ws0x+wDSyDXsyYv7OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IguMwy7OGmCUBl2SoczpDZ/RF0XyyRW11b2wLCkuvRaPtL2EitUJQdlu6frdzBFYc
	 ZQRGhaMNBSOJZWTEl5N8E10CkZAjMRJTaVZ12000C2XvMsvNjwvKfDELoHZUwhZvak
	 ZImAPu5myScuBNBtRr9C93pLx73JXTfVvbte9WDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/254] nvmet-tcp: remove boilerplate code
Date: Wed, 28 Jan 2026 16:19:44 +0100
Message-ID: <20260128145345.006051762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 75011bd0f9c55db523242f9f9a0b0b826165f14b ]

Simplify the nvmet_tcp_handle_h2c_data_pdu() function by removing
boilerplate code.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 32b63acd78f5 ("nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 6a539c3b8b530..6975b2a054e0d 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -969,8 +969,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
 			pr_err("queue %d: received out of bound ttag %u, nr_cmds %u\n",
 				queue->idx, data->ttag, queue->nr_cmds);
-			nvmet_tcp_fatal_error(queue);
-			return -EPROTO;
+			goto err_proto;
 		}
 		cmd = &queue->cmds[data->ttag];
 	} else {
@@ -981,9 +980,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
-		/* FIXME: use path and transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 
 	exp_data_len = le32_to_cpu(data->hdr.plen) -
@@ -996,9 +993,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		     cmd->pdu_len == 0 ||
 		     cmd->pdu_len > NVMET_TCP_MAXH2CDATA)) {
 		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
-		/* FIXME: use proper transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 	cmd->pdu_recv = 0;
 	nvmet_tcp_build_pdu_iovec(cmd);
@@ -1006,6 +1001,11 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
 
 	return 0;
+
+err_proto:
+	/* FIXME: use proper transport errors */
+	nvmet_tcp_fatal_error(queue);
+	return -EPROTO;
 }
 
 static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
-- 
2.51.0



