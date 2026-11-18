Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050621;
	b=2StRaIZBMIMQ79voIU8dddxzW08toMI9KGA9i8qWb7aLws5LZKUo9VnyK+vehhLSltgE
	 6n+OAOMp9VIQZANWO+GdoCA/panHsw9RbGWZluSYtBnXeKBqasg5St0jbMuAZGCiK8xJE
	 F6Sg88Er4sx7b5f8JK4+SuOfbuB42dQK5S1uEdZOL2XLi85LPBokWIHv/xue4RrgvbdMO
	 zVC27rqWx1bsgLDp+hvD1dzNcAdXAWZSClU608/Wg4fQml4pTLBnCYHZmZU0lAKylHtD1
	 yOCy1H3XeX/Kou1qTp/2i9jEe4zYuGIUNEJZpfkSnHsVTaWHYm5yfqquLNqXAl1cPQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vdXJBYYz74kb+gXOsw0Wm7IyPCaJkEHSBUJH4nCBQoQ=;
	b=TYzQCVk4J1ZAZpbP+L5XMuRwvIgIqzCP8Gffa8vDTnPEbwlfrqvULqxrh0lEEtRWc/jz
	 kkXRwYJW69qa6ImXZRYzVfTKB9wrreaDTNx6noRkP3q0SQMEnFzB9+Jk1tHRE5TP0IgY0
	 SutU49+PbmTsWMwhQ91ZKTmggn8IghMsrwjAi+vdQysvCMrP4oI7QDAa4arOoc2+VNra8
	 cNap5mTLZjZJpZlS1us/QVFWx4e1XqJ90ZrUZ1QSn7iOMp2ickypH2rl+l9dISk793XhL
	 DlhSQCV4PAPIaRuNxORxPswYtq0B/iNj2rr2lrHDHsEmz5Zi1C/J1lmzShWEgO67wfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2K6NHCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FBA606A325;
	Thu, 19 Nov 2026 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2K6NHCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2291F000C4;
	Thu, 19 Nov 2026 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050621;
	bh=vdXJBYYz74kb+gXOsw0Wm7IyPCaJkEHSBUJH4nCBQoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2K6NHCDrsIU3Pyfyf0iBkBETITUZPDzrcOzTkWxTKAaFItsZKvscrkSel4XKnKUh
	 1IBR+VDpsMZR+ZvyAc8094/tuZ729agH+3/6pW/TFkA+kwGwKnnfXg3EJd8+x1rczL
	 BXinN5mbWz9fJpXjzhrVzc4DTaTQkuPF7n/uTKvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2773/2857] nvmet-auth: take only AUTH_Negotiate for a negotiation
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150341.444255112@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7dd1d31e2e3124f331056d68af9a48c501b37e02 ]

nvmet_execute_auth_send() hands a common-type message to
nvmet_auth_negotiate() if its ID is AUTH_Negotiate or matches the step
the queue is in. The second case is wrong: the only other common-type
message a host sends is AUTH_Failure2, and no queue waits in that step.
A host can name the step on purpose though, and its message is then
treated as a new AUTH_Negotiate without the work that goes with a new
transaction, like reloading the keys on the admin queue.

Fail every other common-type message, as AUTH_Failure2 already is.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 6628be8cd32b4..1ea97581f4e93 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -290,8 +290,9 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			}
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
-		} else if (data->auth_id != req->sq->dhchap_step)
+		} else {
 			goto done_failure1;
+		}
 		/* Validate negotiation parameters */
 		dhchap_status = nvmet_auth_negotiate(req, d);
 		if (dhchap_status == 0)
-- 
2.53.0



