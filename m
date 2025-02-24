Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA31824A3;
	Mon, 24 Feb 2025 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409157; cv=none; b=G+b2eGV0eFsXhIclZGXmKwwQd3RxWItQTLP4U2gIGSSz7Md1OMNK3xKPgIFTiTwcwU+M/7ceN8Hbq6xrI1dB27nc5l/rJnxa7tsPkHYPSospc+gERNj9gtN757kEOQKBk5hNwkX+hyMTiJyL4h62eJ67bpGDe8bhr0H1R1ZT6kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409157; c=relaxed/simple;
	bh=84hsMDwris41iqP2ev6j3vj8a4GqyataGvhcwh+PM9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMl740+OZZoQtLF+1cafuQj4QeMS9p2+dlcd1soY6GC1Le7DW7kFHmxyyFioNiTS16HiGsPOUz6oxukun0KHOYg9iiYo1x7ayQdVNJ5zJsWdSbpi2NDTEOgxwBGRKxQ8zfGWQWmFMYhef1i5/2N5Artc+wNTmrdxyd9c6akitEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rc/wWzUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rc/wWzUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ED4C4CED6;
	Mon, 24 Feb 2025 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409157;
	bh=84hsMDwris41iqP2ev6j3vj8a4GqyataGvhcwh+PM9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc/wWzUxeCEXkZH0Avt7EgEVZ5S92k+bdlWahNn82KqDfBiVM2dxctzQeij4Q+64+
	 HpILI7UKAUGzcJ/SK6iaDlYXU7jJlyfCoNn2IDyXsbuOmjtVKn4ouABHNif8oTkunD
	 Q6Q+hpg6ljo0MmF6gF37/YSo3uctwAuX8Pr/jau0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 113/138] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Mon, 24 Feb 2025 15:35:43 +0100
Message-ID: <20250224142608.920141834@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


