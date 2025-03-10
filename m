Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC422CBE9;
	Mon, 10 Mar 2025 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630624; cv=none; b=J9UnPeMupkdGz2VVsAOxGTmcqnqsgnwKhXVMWhfQ5BEocQK+XqPfk1hkSNrmRx9/GLPMCOMSNWy6NYIQKCiQvp3lzSYXvIBHvX1vz3VY1M6O0+4/06yNP/DwDAG3GpL7YNCpxdlEX0xQjPSZT+VPIU8aaREmNMoUETEtRJ4zNeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630624; c=relaxed/simple;
	bh=sITLjyL8OBkieu5tnd0jD/Mg2ccZk9ry0xW/INKvxVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gngae+TTiwdIicadwjNf/5DeZ9QMeLgKUk3jX+W1ZCuruJhR6sxmXMbmmSRUej08TTc6eCqesRIi2CdslaIujVArdRdWtHQ+nCQFQko8MYBt2Uh4Q4H0VFm2RxjHXHgegykYFddC9YZFCKIkc3CXXHdA9RTo5oP8La2KoriDemo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqwS8I3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqwS8I3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563F0C4CEE5;
	Mon, 10 Mar 2025 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630623;
	bh=sITLjyL8OBkieu5tnd0jD/Mg2ccZk9ry0xW/INKvxVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqwS8I3CuGCgdMzcPZ9QMrAQ1ip5rKpCLYFW/qr4RHsSFFp5pncTmdmkedNwYRVV/
	 E0/z6bt6ZelR6nC0pwwpTcTzOJNGYl/9GFCe07ja/NpCoMPHwhPZtco/DnUtNXFZvr
	 tIzrqx5wBZBonQBAv8+4fmm+BZYkYW0m9o+XFgWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 478/620] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Mon, 10 Mar 2025 18:05:24 +0100
Message-ID: <20250310170604.443336950@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


