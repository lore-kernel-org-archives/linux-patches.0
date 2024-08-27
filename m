Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47B1C0DE7;
	Tue, 27 Aug 2024 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771261; cv=none; b=HVkKi5KDcvUnZu5lZziCpFI20GfGUb9i7/9gusv6dOrpalZ3ckfnV8ycsSwJozJ3eevB91QxU6xBimNwWh1nf9BeZr6JAEdIFW0XAf5llt8smsOggvVaP7MZFiI7OXfuUbHlunyrUsicdjPWfq7pUbmKmvRotihaMrDPNfKn4Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771261; c=relaxed/simple;
	bh=aNarmtjp7R0ZR4w64C4ZKrrtBmRz0K74IccMTIqqzWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO3aeaHkD3HSFTQksiYxMe5L5H8xu5MusZNEMQ5UeUOzofrdDvj5084osAYtvYNwqGPxsDIZYTBBOL/k1whSTycNE6OREUfLU7sBXwz9+zOoZAg5tIXuyog3/NDgboTUQGMDOE83CT57iV/h1XoT8fgIvQuIDhFL7TU7Y6K80rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vLhxPYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vLhxPYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126ADC61046;
	Tue, 27 Aug 2024 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771261;
	bh=aNarmtjp7R0ZR4w64C4ZKrrtBmRz0K74IccMTIqqzWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vLhxPYv4mxFWSrirjAFORBYmUeHwO+y2iILY3+XTS48nu0kjRAZGn4N8kRjBrnfs
	 DYs80cyBnuticyRysrMtY9lm0GjDuRRxIhRnUQ5BZTu0B7nhRkVUgVoM7gIhpPnurU
	 tS1+sxyYajHTBswaRF6jL40EHGFVuMwywipEkUzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 104/273] netfilter: flowtable: initialise extack before use
Date: Tue, 27 Aug 2024 16:37:08 +0200
Message-ID: <20240827143837.367557641@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit e9767137308daf906496613fd879808a07f006a2 ]

Fix missing initialisation of extack in flow offload.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a010b25076ca0..3d46372b538e5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -841,8 +841,8 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 				 struct list_head *block_cb_list)
 {
 	struct flow_cls_offload cls_flow = {};
+	struct netlink_ext_ack extack = {};
 	struct flow_block_cb *block_cb;
-	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 	int err, i = 0;
 
-- 
2.43.0



