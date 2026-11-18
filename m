Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027700;
	b=waxKXyM8FWV7xL+5vT0wgjRSOSAp2Nfb6SYUFpb24fr795lCtBLUChNmJ18kOkktQkPf
	 K4WBMdlbGEJFDlF6+gh8giqAMRQSSJObH83BxEydZDlRaVsShJjq7lBPQUpx29W8SQzyk
	 7oEmnlXZi/rpLQ8pLHvlp1fXX1zj7pHZC4DWV3CscMvo5yG0tGFrxQTjqGPMeo/gjHE8d
	 ZfgAhPn9qBkMsAqtIhn88QiLFdw5yleQuMSZVk9+fPz/4JeELQjkD698bNcGkfMmHymLD
	 bZjFqjiDhCd18fDtUYt1/IgkdhOylw86k79D6HLVtfg0BiCo9CFjjVCuJCYXCBGVzyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HQBjGTCAZ03fB55oMudRNX7DUyFAzQIkJRjOo04eYlc=;
	b=EVj0PFBGLKgEYlsbI6j2p1FBDf/956SX0z+fHVGQg20eGqK4FKz9xSSycDL5aMmgdpog
	 sfgZZjEga0weFKIXBUQpmylDekhQSJ0RmHitRoOOkDPqlq5kRHOqw6sbW2x4hht6AJzvl
	 ZpVobD1KBzG4wEhhtOxML5I+9d0AcHQIHnScF0AlOuC45YBUoVnP5uZSlt2pAZbqJSTon
	 kyFwuMzpgVRMgbeV+NG9zx3o8kiB5xW9cXLe3xhPN1tKa2n5NgcI2QDmMX2dWTKU3jivO
	 iz27507bCa129hLM12DdSncFI3/puAHlLaWsCyJYy11GupaOAnzxB8Z2s8u/8rKFeOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXqHkKsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01AA60A2611;
	Wed, 18 Nov 2026 18:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXqHkKsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA4B1F000D2;
	Wed, 18 Nov 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027699;
	bh=HQBjGTCAZ03fB55oMudRNX7DUyFAzQIkJRjOo04eYlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXqHkKsQ4Vrx/QqNIq30AXUCgALUJ0XnH9JFzDRkrKqbRonZ/dGCPzZDBYZxOCoxg
	 bus13ZfqI837GplHWoKbNcJgt6e74u68iJYe6DR6ge0KWJ1u7kP4x+tXQ7Js45VA55
	 xwkdBnx+GWexMOmLUKz/W5A4tnBn0TLhIZr+ltVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1883/2151] nvme-fabrics: clear the poll map if no poll queues are mapped
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150230.392869794@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 36ede1aa85d5d74c39ed375a906f6eadb15cee5b ]

blk_mq_alloc_tag_set sets the nr_queues of every map to nr_hw_queues.
When nr_poll_queues is set but no queues are left for polling,
nvmf_map_queues skips the poll map and leaves it this way, with all CPUs
mapped to hctx 0.  The queue then claims poll support, polled I/O ends
up on hctx 0, which isn't a poll queue, and hctx 0 is marked as a poll
hctx, so even the Connect command of the first I/O queue is marked as
polled.

Clear the poll map when no poll queues are mapped, so polled I/O is
rejected with -EOPNOTSUPP.

Fixes: 1a9460cef571 ("nvme-tcp: support simple polling")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 03941bcd2dd97..c9b7356e6f654 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1199,6 +1199,13 @@ void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
 			io_queues[HCTX_TYPE_DEFAULT] +
 			io_queues[HCTX_TYPE_READ];
 		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	} else {
+		/*
+		 * blk_mq_alloc_tag_set sets nr_queues of all maps to
+		 * nr_hw_queues.  Clear the poll map, otherwise the queue claims
+		 * poll support and polled I/O ends up on hctx 0.
+		 */
+		set->map[HCTX_TYPE_POLL].nr_queues = 0;
 	}
 
 	dev_info(ctrl->device,
-- 
2.53.0



