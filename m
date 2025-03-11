Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A6D255E37;
	Tue, 11 Mar 2025 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707427; cv=none; b=DrxjLnOilstxM5e1eFy2pmOLU7iipzuumQSvNBpxZWtD6RkC5WnI4gs8yikVXmzArbrS5/tKSmqiV+xJL2JLTEuesATV6TY6tSZ4C9t/yl85k2v+8N+RP819hJA/88zwIA0XDEDkGVolw3iXsDI1uIrd8nZLgMGlnlNefgMnugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707427; c=relaxed/simple;
	bh=q2aMG1BIkL6+3PzzkGWsqL8JMnFGE7jN8UhYFSwrINM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz1eLaig1/n3AThexduzC9czgkHsTpHbcn9at1n+b46VHP+s+RWMC9F2GYlkqXB39dDNwsz8NeAfZXmee2hrSyU83ED+Ly9+dSVD9zX5cqf1gDe5I8YiWyeQ55+87icNNmHyopoqWzeYVIorxCMfkQRHdLHK0Vm0nhLJV1NzJ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REb1BDMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REb1BDMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD580C4CEEA;
	Tue, 11 Mar 2025 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707427;
	bh=q2aMG1BIkL6+3PzzkGWsqL8JMnFGE7jN8UhYFSwrINM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REb1BDMMsRZBZiMuib7MVWU3Q/4Nw7Y+OgsxPpuWaYlvilfmStX9/0Xj3U5ysSPGe
	 sRuXfTECQJzkRwLL7DzxNJ6XLKJGP50SaiTYeIy8jWm2I8SOtTa0EdB5jpJOXfpOt3
	 c29u9deFnva6TM0Z3/0LZvREvX1WEUwwDmirdQCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 344/462] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Tue, 11 Mar 2025 16:00:10 +0100
Message-ID: <20250311145811.953351304@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 878e7b11736e062514e58f3b445ff343e6705537 upstream.

Add check for the return value of nfp_app_ctrl_msg_alloc() in
nfp_bpf_cmsg_alloc() to prevent null pointer dereference.

Fixes: ff3d43f7568c ("nfp: bpf: implement helpers for FW map ops")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250218030409.2425798-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
@@ -20,6 +20,8 @@ nfp_bpf_cmsg_alloc(struct nfp_app_bpf *b
 	struct sk_buff *skb;
 
 	skb = nfp_app_ctrl_msg_alloc(bpf->app, size, GFP_KERNEL);
+	if (!skb)
+		return NULL;
 	skb_put(skb, size);
 
 	return skb;


