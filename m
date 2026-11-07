Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064809;
	b=mN0+934fb9A5GZSTG0VcCfuYiKPz+i9F5xyF8J7JXf43gep2SF//x4QxJHM7DaLEzj06
	 Vi/cXkj1+Ac8LwkTRNmuUZ3frEzmJSmbSywdXg0gfsXxjk6DZ+Jv90eg71+IIgwlxOTe2
	 Yus0n8dYVSsHlPItmjPzYnWr78DwSmHQC9/+yJnMSQK65LWFzaIkeYhLik6IltpVfmKnp
	 C/+ekFN5B05fE0YYE1AzylJTxUtolZZpQV/N2pEk52pLOztAkfJLmKStNds2eK1aDxMfL
	 PBJ1kQL8irWMLhr9kI0BCfX/mU/YKwDUe7NpXeRkUQAUTGaImYdC5kU9P1ExAji+eDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eIrGxGqIHQSEds8M1LC+IAsktQk0JS2G4brVCwMvXyE=;
	b=cIHzA4FJJjwOfg0VnZkRyITv4N3ZqZPnFGmCOlipGsk4+co9c4k/ido5EU2t5Aa8jaXi
	 J0b/U9/u1oNhhpFVpg+YSKeHesmQn+R3Y04qAy7ixocEc6p+qH12z+BCkeqlKyi9+bLop
	 44DVTMYW43yERAand7Rkz/Qymx6qX5WUdCMMHB9DTDXN3M3Z1KsUsHZbKVOFvOdD3I0Py
	 N3P09XxnuIq2A3Q2StSdE9tLnJy4+di+OJ8X2BPE1H6A+N8Mq7xefkcG3iCVAlvPW0nX5
	 ph6iARKCZIMb6MPMfbcWbroICMUVobYwxMgI5dPJAD1VXUcWX9Xz6T4LrsNOV2sVdBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uoEOakc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF54606C02A;
	Sat,  7 Nov 2026 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uoEOakc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7351F008A6;
	Sat,  7 Nov 2026 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064809;
	bh=eIrGxGqIHQSEds8M1LC+IAsktQk0JS2G4brVCwMvXyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoEOakc/iBeLRBxAePcksXcGKFAZZ0DohizVzCudYf8IQJ3AXVUrpoPJIX8wsxe76
	 bnSyrzn1/zse/5ATWPMSvZignyatsRLIO9OvX9/MXKudC0bJ6FLBqjtAHpmH0Hn084
	 tx90yW1h59YWCsY1QMrefMR6BNdSidXTLFjaMaTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0711/1257] nvmet: require authentication before property set
Date: Sat,  7 Nov 2026 08:50:07 -0500
Message-ID: <20261107134958.892081969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 42d1d18116715..b451029ab8f49 100644
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



