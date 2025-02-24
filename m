Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10AA1885B8;
	Mon, 24 Feb 2025 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408156; cv=none; b=vBsCkUZoO7iDgHjaRBxG6LDQGl2hXwAtFsPJwpmd06TvQeNs/5xy+j7XApinn8qMiOTqKaZkaSpp9udJ8kA8M5K+Ws4oTpUGLyxHTJHMKHXaCw/xmt0uqAI3fQ/cn0TbsCKBIvBR8eQsDzreMkYKHsccfPocQe3s23X6InAubR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408156; c=relaxed/simple;
	bh=h7eIi70r1rdaPQ2rn8sxgMU7qz35CWO5C6WSQhR1pEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roatoKmT8j0vzR02VFNY2z54dxT/LDqIp+4B0TCfLEOD5sj5hE2hoK54d62hIUHltMNduQ/cxfQ8F7/lO33jC7526lcuRR6uIP3+aehfndG426WP01z7riAByY6BWWThKbRzoBmlgE1cnsJbFubYa70dwK3k/NbuOUmtjM24iUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJo0dLKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJo0dLKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34435C4CED6;
	Mon, 24 Feb 2025 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408156;
	bh=h7eIi70r1rdaPQ2rn8sxgMU7qz35CWO5C6WSQhR1pEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJo0dLKKdELouflPWvUk8/s29l9G3gsPbhF7qZwvLc1wQj+npQOP22K1Pcc6ryKEd
	 VBto7yyIlKfxIqOz9QZbygxUJ7XOlkxRNjzDzt9tBqGMKY6EGf3VumgkBid2tX9T4N
	 JherlHcaez4sFdQgztTlDxE6bK8jmC380skFXQNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 116/140] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Mon, 24 Feb 2025 15:35:15 +0100
Message-ID: <20250224142607.574279160@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


