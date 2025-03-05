Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6E52512D9;
	Wed,  5 Mar 2025 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197204; cv=none; b=FznxYHEYrIPmkcfT2AaX45zQ1LSS/36SxjgQi0D+ufKzrebtLqXHAeW6ePxXZ2qQuQoquKVtK7kWLZ0god74pK64DncreXp0BPhDybEudcMTo+GFTxh+2SlKUIZZtGz98ufxgKhKM+drocFTG49X892ikmQeQZWoPAZw1aW/3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197204; c=relaxed/simple;
	bh=ekg0bUtxHmeus5ip3i5xr3AcwSq8lx28uIernxmjeT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbH0tVdWv49AEsrhbGVWSRu5Xwy2FYRr0MM2PMzv1MLDFMxXnYs2uQUaJZfhYD6d+7cVNgf94b1E8AfQ0qWIJHWYgWWkfMh275jYvyVDkOiMw3t56mJI+BhE0nwVI5yPmt30URRCPQMXtF2IwBgxu2b6hQI7qkCZqetmj/jEK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an4oolNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an4oolNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDCDC4CED1;
	Wed,  5 Mar 2025 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197203;
	bh=ekg0bUtxHmeus5ip3i5xr3AcwSq8lx28uIernxmjeT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an4oolNF+ZUaUscWPoZfJSiVrgsZlhVm7zuxLolkampI0LsPumshPidTAyXH17lQc
	 X8770IxrO5Z+gBQn86dhPiMT0/iwjZk1SP8HXO+LlX/GJI5v17JfDzZvpiuWt4Ukt0
	 3ct6yjjazF6dz4vc+3vM6fW0lxByxlsj5TQJFqKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 076/176] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Wed,  5 Mar 2025 18:47:25 +0100
Message-ID: <20250305174508.517505899@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


