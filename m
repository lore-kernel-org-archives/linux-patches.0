Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018597;
	b=MR3uoZsbVzS1DxUrpFo1kvtnJLwi9nuiHTrqRKVrUgsKY7cGWuIMGhiqUPClpjmSdt4o
	 0W29LHfrNL+FlPPHNyR0Gv/P3MkWVTuNsWnBoH7hB5WUcgpr9GE0zyrzeszALbaNf0yza
	 SJ1EU6XCCEQiS18Jqzu92QnmuOoyqGVRmw4umyvYkq3qjakL/X7U3oMAewkRHbqejKN2E
	 xdrQes5kvCUhTctV5ASgBnu3N4DQp4ytwuzMuO1hAdu9v7eZNeOM5SWmzl/hM/guabrnx
	 D7oveFBUvnkGffCzKt8jxOAjwdLzEdbL1Whj91WXgcWL9aNwlQXPZtNx5Y9+pLipfGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwElLLWrgKTIcc+AwUJyp+ZDV1SsvNpJYquS3ykPDwA=;
	b=5n+6TGFRrkVtNPtuobw45B+x/xCOriE2KhvHEeLh5yMpLUX7AQvbRfI9QPTcFupzFMCb
	 ygJV1fRo1rRzSgDanNCFQyien1V6mpFMRKKBPpUH5NgSHNl+y9/iRpJIOI8CO19oHFetQ
	 jzuUXdsWVYkfJUegRqQVuLVlqihbE4RI9araPVexQrQ+aesyhtkSSplXh4w/Fgyet4+lt
	 6cG0/Waz7BWStxgPtba8y68KPzPbV/2mQ6I22/Slfoahe1b/pxwXuKVtu1H/wgdaL3ZOl
	 rD6X0JFH5Bl+bzhOsepuoKMzSlF/VvdUBtjy2Xg8aiNJHwShdAYThQerVKUhcm7aMbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUaUWyeG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88228606A31C;
	Wed, 18 Nov 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUaUWyeG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA91F1F000C4;
	Wed, 18 Nov 2026 16:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018597;
	bh=AwElLLWrgKTIcc+AwUJyp+ZDV1SsvNpJYquS3ykPDwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUaUWyeGKILPg+vOgwdNhD24BByYLpxeLYM1azcWwMmv0FuYRNS+0rfTWlb+iTg6f
	 TGKU/sdefazELg+I0hYvAZAWWLYmIzAHUb/KQerrEcwg3oaGwseEikJam6ryB7ZXvy
	 +sLBIHBmeEdyPEYBuqnHzHdSokmN0Vs4NqpusJAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1296/2651] svcrdma: Fix svc_rdma_recv_cid_init() kernel-doc
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150334.617277171@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d1caedce2d015573b4c26b127c488059f25aabc4 ]

svc_rdma_recv_cid_init() initializes a Receive Queue completion ID,
but its kernel-doc heading names svc_rdma_send_cid_init(). The latter is
a separate helper immediately below it, so kernel-doc cannot match this
comment to the receive helper.

Fix the copied function name.

Fixes: 28ee0ec8948a ("svcrdma: De-duplicate completion ID initialization helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260909064343.90437-1-kmehltretter@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 76aa5ec4ab402..5ccb13bf906f0 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -142,7 +142,7 @@ enum {
 #define RPCSVC_MAXPAYLOAD_RDMA	RPCSVC_MAXPAYLOAD
 
 /**
- * svc_rdma_send_cid_init - Initialize a Receive Queue completion ID
+ * svc_rdma_recv_cid_init - Initialize a Receive Queue completion ID
  * @rdma: controlling transport
  * @cid: completion ID to initialize
  */
-- 
2.53.0



