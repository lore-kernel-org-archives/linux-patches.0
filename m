Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019942;
	b=TrNQBH7a/6b94NIrw1AzEX/G+0afFWvTH1PYCPn371DmVjsrUTiHXfotZHf6rjJDHbbu
	 MPJYoCjCnhS2DE5NGpMGEkXQrLlEB4zZ7lgm5ZAzn6LsaymT4kvM0dFlDcUhEaBFrLOWw
	 3ocSG2a2DPahZrvG56UjPrODWZc79sMq10wjkYhAZmpONWb6b/dA4O7/KCQhllOgVDMrT
	 KHCp5YmD4Hvc9ykAZKrEcDW33Jr6vqJj/v3cv60qYX77mveTou4NhhV6Zb/h60dNXy/dP
	 OnNBuKzFr5ZKsQuvwcAxwD3jTl+iqAUVRqT3hClBXRZgQo6FXitLbe5DyXWkA5NRjRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AD9OA4umql66zT35V75joXc1CCEeIRprjq4PIb6YbAM=;
	b=yQwko5jeaJSJo2skH2WL+Wvv7k5aQVr7okHgJKcNk6+Opilxl78cHd3EKY1wcQuU4MiK
	 DerlOuMrBVeGsX+jIrymVePqIGfZlmecmBSKddqdY0Nkgvas8zRB7yotdMXDm554P+KqC
	 W4yjOqZrXURsps/w9rNHN1VpuZCuVfnZv30dfZ9P7YPjLrYdTxKsVDpVoIjFVd7UmdRhi
	 kzgnZkQ7NiQ0Ju2/dONV01Ka6cLMuMYk8tH78rHfwawGwZYK0u8ZoiWrnERHe6uziQ32W
	 6FQfvuylQWC+kqVKZQbfN/kd+i+wq2fHVzD6+sVglXInYpqjOVxWobt7HvfyKqhbvlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTlahqtq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A17606A335;
	Wed, 18 Nov 2026 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTlahqtq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227141F000C8;
	Wed, 18 Nov 2026 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019942;
	bh=AD9OA4umql66zT35V75joXc1CCEeIRprjq4PIb6YbAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTlahqtqn6S2+/aj76ideiyNYYJm4HfJH9nA/Lv/dwL0qFt2z0qp8itKTC0nAwSR+
	 CYJA0vC+xMZO//SOjviVBRQBs/+SLG8de1zuD0aoCBm0XSnQNMwKtIqFABLPnhEvZ1
	 S7Cc4hYtWRBhk5iaJIOkbY6ZfGuDe/ZXMZeMySC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1774/2651] nvmet-auth: reject undersized AUTH_SEND payloads
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150351.258281527@linuxfoundation.org>
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

From: Sung Byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit c9359401036e8294c007a10e8c8d8da7030fcc76 ]

nvmet_execute_auth_send() allocates and copies the initiator-supplied
transfer length, then reads auth_type and auth_id through a common DHCHAP
message pointer.  The existing zero and transfer-length checks do not
ensure that both common-header bytes are present.

An unauthenticated NVMe/TCP initiator can complete ICReq and admin CONNECT,
then send AUTH_SEND with tl equal to one.  KASAN reports a one-byte slab
out-of-bounds read when auth_id is loaded.

Reject payloads that do not cover the common auth_type/auth_id header
before allocating or parsing them.  The one-byte trigger and
header-minus-one boundary were cleanly rejected in three fixed fresh-boot
runs.  Exact-header, valid DHCHAP, wrong-type, mismatch, and zero-length
controls remained clean, and a following valid AUTH_SEND on the same
connection received a response.  The touched source is unchanged at
0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch applies and
builds cleanly.

The demonstrated impact is unauthenticated pre-authentication target-kernel
denial of service.  No disclosure, controlled write, RCE, or LPE was
demonstrated.  The source reproducer and complete logs are available on
request and are not included in this public report.

OpenAI Codex assisted source inspection, test design, patch drafting, and
evidence organization.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index d9dab0cda3b06..edff0eed18884 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -301,6 +301,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
+	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
+		req->error_loc =
+			offsetof(struct nvmf_auth_send_command, tl);
+		goto done;
+	}
 
 	d = kmalloc(tl, GFP_KERNEL);
 	if (!d) {
-- 
2.53.0



