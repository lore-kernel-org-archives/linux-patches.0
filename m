Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030861;
	b=0bDhy2RDfr70VhqjbMvZU4A0ScJw+Ci5l07lNoi2kWv8DObnnbfYq3X0abb2MOLzEf6i
	 uiJ++idIWOLb82n5Mca2LhO8NlbB9qKVNc+nkvMhdg5FW/Ukr0ia7jRJ5xQLWT2WEfDp5
	 3ynfsYMFBn+2ou7kMf0o3UI7PpmhqX6ZHKleYxxlUDxrKoc9WUVHgqihVU72gMS1tlU7m
	 oCFCKyxj/s9Gcukn76VlIPIK7KxtojvhkIsHm0VIi+3fyHFdaBakE0m+5Q+NFIM1Miv00
	 7e1AwjCbkV0KRV0UqFDi9wkoILTshrVYyeDeWmtptLMTUZu06gqxJzNaktxMUz2jZ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBhSMTviFMj4CVdKllsQ3hgbVXxznDdp7X5EzmPGFqc=;
	b=txYSMUJVGmkMoCUpBM8f4QnGMOyLfJ6dO13sZpQMmpw4LZeSEnTU8tuOoa71WFSHqJ1M
	 mGdXf/wpCXVl9GstzfSdpxvG/jMSaojlbCvtiegIby8pObl488rd9v9bWZQQSyIYHD3Sn
	 hQBALnEHqO2w4899lLtBdg2AiVbuIolqcyFVTtr46fhH+A1hfDwrI2YAcJlLw5KpDiCZo
	 GGTA5wBw37pa5jvxY4/G0q1MRQsC+gCbzfmEzZvSDJhnOUesOp8gZ7NSvBtjCDk7AqIga
	 GsDImxqlkNo+UvA9u3LBL53LgFPsc4+0p2eCvvKeC8ivlWk5LEDbg73ewZnzR79WGKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9SK41Ur;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4377B606D356;
	Wed, 18 Nov 2026 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9SK41Ur
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF101F000C4;
	Wed, 18 Nov 2026 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030861;
	bh=sBhSMTviFMj4CVdKllsQ3hgbVXxznDdp7X5EzmPGFqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9SK41Ur2a/CvYbZ1qEraw9ubu2GJhyu5fe1W3Hr0JTJ6mITd2oLWU7PGp8u8Ym/t
	 cfikO/8VuXZDe3D+q+Gjh5NfvLYGkLoaJJpxT8qUCfm9uKOq/gT/eOxcz1j6JEUmgy
	 VmSpUOztyZbeyC72LLTBwrJw33CxL88cJyU27+bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0854/1756] svcrdma: Fix svc_rdma_recv_cid_init() kernel-doc
Date: Wed, 18 Nov 2026 15:49:41 +0100
Message-ID: <20261118150043.367075247@linuxfoundation.org>
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
index 65ce45d95f1c2..c7bd7ba2fd83a 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -138,7 +138,7 @@ enum {
 #define RPCSVC_MAXPAYLOAD_RDMA	RPCSVC_MAXPAYLOAD
 
 /**
- * svc_rdma_send_cid_init - Initialize a Receive Queue completion ID
+ * svc_rdma_recv_cid_init - Initialize a Receive Queue completion ID
  * @rdma: controlling transport
  * @cid: completion ID to initialize
  */
-- 
2.53.0



