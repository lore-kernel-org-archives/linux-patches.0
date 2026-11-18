Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030442;
	b=DfySxDBN26ePiEUpJeQ3F/wdG6ZbhA+xKGCrf6kbPNbBslIx4DEou4WEV/m7HcX9wnNq
	 8ULikBWZlmJdNc5PrstiJ6l2TCBV4WWqlMOBOXeleauENk3cDFzQFqOMfHqJkD+PYF6Ou
	 WhnOj+yjLsNN4CoirkQyAw+HmyJGzfCIC8NXArhoPbFUZlaUBqDnjmS+fSGKBmMDg6hf2
	 5ZLBH7fTlyR1xNP3+Qx6wn34K3a5u9OsKZ1Nkyyest5VAr3CpeawtP3QzdEUegXGsn/MA
	 0OsuB8Rg6nVu6x+ddJl5vdX+P2t9W5KjhK8K3k9lqNt7n6HZlu+PD19VEY0F15FiIiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQjhUVtGtF7vtGSVWA6oSHA9ILJTgipHqneN0YXCmn0=;
	b=QdCuhS9/DJ2SU3XxOvrPzhfHYq/t96KgWi3V6SMuYISMelYhvKkfZS0aJkXOBUdLaxH0
	 eBn/eXodJOGvD3dPRkLdpwgZ32EoXwdpkcZtiSffeDSi3vW1efE0jKcr5Oe0evlpfYhEp
	 jTXqlfLz7kZW93SmVBIMhqNBifStxz/OfhSPU5noLz1Ytoz85QWQSOAp8CuwXsPojx38c
	 cF2+AfCGCU1tD+dsxDFJaoydd3t4QjuqdsSvjK5xDRTKcS5ozopzO4Qczgb4iluDA1CTG
	 kKQDYZJVyuXFfZGHU5+0g+NAePh0/2tFTEVxCmtYJrcpgoSQkQoAYXLyrH8F9PrxgPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYbf6yKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ECB606B10B;
	Wed, 18 Nov 2026 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYbf6yKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2171F000C5;
	Wed, 18 Nov 2026 19:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030442;
	bh=tQjhUVtGtF7vtGSVWA6oSHA9ILJTgipHqneN0YXCmn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYbf6yKDO0uLuNj+xncB2YtU2h6YV7ulkfPDh2C9oAmwHbhwe1eG9CRdq8ssi1/0P
	 j4yRiaD6enR28erdUEuxGj3Rt2EUbMLcoq3DI8niMq4Fd++NdzyvWs7CsSQmfl25rc
	 1KSX7XlK+4gjvBJPLCXfKrkeqYJ+5zWpCR/ef/rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0707/1756] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118150037.415714535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit aac27aa8c5cfe3c3c6029b9c0f1113e0a53329de ]

When a short-single SGE payload crosses a page boundary, siw_try_1seg()
computes the length of the first chunk as the amount that spills into
the second page instead of the amount left in the first page

	part = bytes - (PAGE_SIZE - off);

Use the remaining length of the first page as the first chunk.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Link: https://patch.msgid.link/r/20260927115351.12245-1-serhatkumral1@gmail.com
Assisted-by: LLM
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 43ff1afd3d018..4abea56ac45d6 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -85,7 +85,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
 			if (likely(PAGE_SIZE - off >= bytes)) {
 				memcpy(paddr, buffer + off, bytes);
 			} else {
-				unsigned long part = bytes - (PAGE_SIZE - off);
+				unsigned long part = PAGE_SIZE - off;
 
 				memcpy(paddr, buffer + off, part);
 				kunmap_local(buffer);
-- 
2.53.0



