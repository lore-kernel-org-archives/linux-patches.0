Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024912;
	b=Q+0xWMmtOnSYDmEUl9T9DjIU1YAYThy7wburF+FkzK/p+/7+SBs415P3atcu7AKEePUs
	 Jgs+2JjWK6nJGhs7fLkmyM5+zDEztkv5RCGPdJDSSXaL3QSrvMHvii0yDh7v+MbMzfxB/
	 WRTnOiePDyNMxDoojO68vyOuFbzMfeNm9970QmRfGMYxmUpy2jS9Lt8qOLD0Xbaz4UIP5
	 H3f92fLQNn9BznQrlDLYSr66EIlKyR9dJLVk7z4vcw6LXQk2gf7UdGSY0CSOdTPLjgvun
	 4gMFyodiBvCV0xuAPVR1sxV7rnJhUu50cKiG3aYMF6Tsr/SWKDiSbvwzNK/r9qxXE1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=diV2nI1Eej4iP3d0hOS8soxw/TqXxUBykJ9N6tpQkXk=;
	b=1oxzLdC2+c0ACBQ3SY+jrrk6sPJ+qd5h/0bnZlcIPStzjzPHDKXQkAxuixcZZV1Q29w9
	 hGnRbgC4CsTY3+uJzXptM+qjEEDchbNCama+EriGJoS2t+AiVkH9AMLsM9MSb0S9fBxqu
	 ntjp307NpmIvC6/cghJssZU0jW/88BUNwgHOJrvYGA6/iwCz9+K4Iz8xtV5pCA6WqfWnG
	 rnm2VUMt5Fz1BWblKxaE6ZWmBMxleP7pF71ypV+ixCQ3pcH2Lh/Vy/SEXMm0OetkIsMHE
	 fwXKj0+nPFVj5PNTj+RGI+yZeFKhKEa3oMkFxSHYQRlFRx/sWlemtLtGqMsZvFyUqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xkPfw6Dl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92168606A31C;
	Wed, 18 Nov 2026 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xkPfw6Dl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1891F000C4;
	Wed, 18 Nov 2026 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024912;
	bh=diV2nI1Eej4iP3d0hOS8soxw/TqXxUBykJ9N6tpQkXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkPfw6DlCaBvIdS48llce2YWZplyuKr+e54HtvNilEPkBljvQRT8V5I4DZt3D9xIQ
	 gnZko+c+v2qZRuVFp0JzQ0btbx9zE3PMgck9BGRNaGdtpliRn2sHY3mAGEsnmHW3j6
	 MkrF72rSsN+dkIsnWKOFjwPQpWlMOKRNNiBgu5PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0893/2151] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:43:48 +0100
Message-ID: <20261118150154.829752016@linuxfoundation.org>
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
index f7dd32c6e5ba4..54c9d97015e8f 100644
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



