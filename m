Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063382;
	b=1t9C35c0bpq3kIy7hGzGFtwfQycLPCWWGK9qJauNznsp/Pxgn54Ka8ekhJzpCylgfC4G
	 dJVUdY52uGOaf5C9zQ44lHWCfmm9C0gVFTaaihlS42anji1wWU80D38R+Zx4Y1a3pEOVv
	 7x+COCrAq+5SHXSsi119Gf1zdyYQ60NCA8BU7GTrnT93dpn0by5lbyTLIBSsHf/vYQEPS
	 63E1TQV/i07taRYWNsRcjbazfW4hwhcSpdDmxCy/FNIijRxrm6LGkCBaFXNr6sIwoHa1n
	 x4zvlBX65IWnvnwFUHMrGwiehQ6gO0yqGIRrKSkKnkM80gEX/5SS23VpzpaDiz4WcZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z11U8F7m4jv4/3Sl1t6vaGIcyJfMk8/8Iy9JiT6z3uc=;
	b=esE43fdnX3vaXp0itSU5zG13+M58fLNEab9KuHoh+r+vd4lIhvuYYiuBkbke+2lmBqpo
	 JBC/7PBltfeIDYXvR187Na7gloYiDDgru5gaCqJ4YI0Gc2pF4B4sEKUH95QZqsnR+903j
	 PAt3/Wmr0TuvYz/pwivF8JSP5/o7G1OCrRZa/u8ZfD2ybgwK2/uC2nSdf8XuZ6/rzSJ/g
	 12rtdJaSOZPeNSG+0tBY5/UYPqLyIsy1YnYfXLIQrYmEzLnatJp/OsJYxH/prx6ATpiZT
	 UjRRfSO9+W6BCw2TjlIYTDZsEt4Z3TB69zRtnovx+WvziCLwMK/FzfLX5SarVu6gOkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7rIXda0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D1A606D810;
	Sat,  7 Nov 2026 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7rIXda0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA1C1F0089F;
	Sat,  7 Nov 2026 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063381;
	bh=Z11U8F7m4jv4/3Sl1t6vaGIcyJfMk8/8Iy9JiT6z3uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7rIXda0iihaHGgxH3++YRW3tS1VxWao1fKRoz7+CZMFV3D68+lLByy37Bxw8TU8e
	 4gTXgg4tPhxOXkgsCkmmVXg9njg4l2A9nDLhIN/AbjxW5/lPKP/Os7AP9qY7VMd0dN
	 aOp2izX3XOIyxV+SpWLQsVW/o3dTvKLFHBMqyhYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/869] nvmet: require authentication before property set
Date: Sat,  7 Nov 2026 08:53:21 -0500
Message-ID: <20261107134911.125025295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Sung Byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 44512543ff0413031516a02cde67323a55e0f769 ]

I/O queues do not perform independent DH-HMAC-CHAP authentication.  They
instead rely on authentication of the controller's admin queue.  Fabrics
property commands, however, are dispatched before the general admin command
authentication check.

An unauthenticated peer can consequently set CC.EN, connect an I/O queue,
and access a namespace after admin CONNECT reported that authentication was
required.  Reject PROPERTY_SET until the admin queue has authenticated.
Targets without a configured authentication key are unchanged.

This was found by source review with AI assistance.  A localhost NVMe/TCP
wire reproducer retrieved a known 4 KiB namespace block in two independent
boots without completing AUTH_SEND or AUTH_RECEIVE.  With this change,
PROPERTY_SET returned NVME_SC_AUTH_REQUIRED and the namespace data was not
returned; the no-authentication control continued to work.

Fixes: c91a20129185 ("nvmet-auth: authenticate on admin queue only")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index bc837fbfada15..9aedab2603bdd 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -14,6 +14,10 @@ static void nvmet_execute_prop_set(struct nvmet_req *req)
 
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
+	if (!nvmet_check_auth_status(req)) {
+		status = NVME_SC_AUTH_REQUIRED | NVME_STATUS_DNR;
+		goto out;
+	}
 
 	if (req->cmd->prop_set.attrib & 1) {
 		req->error_loc =
-- 
2.53.0



