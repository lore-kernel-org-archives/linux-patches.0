Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83527701;
	Mon, 24 Feb 2025 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408775; cv=none; b=h54uwZTo86mRNzhJwmpB6tJ0AlbkqaI09cEWoaVxIqkXe1OgF1JZF5vRZDX3ly0OmCWJW9qiQJgpfAfbowI1vyyvIvI6RoYla1Z5OTC/070v9uz8Ce6KVT4cozj97Gq7HzHRA8pliE92XTA9y0uGGA7FOzsN4XKAiSxZA8Pxdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408775; c=relaxed/simple;
	bh=Uo345U/DipkTKjRYOsILOVxM6E8GB+vc+TPdIkySsyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcywshnT+0A+Y+a3DQTOoCt8hElW/8HSo5qVhlAYAoSQCcNvymYo2i/CCU+zeobe3MjMscQ90je4d2euAPT7eEdqvewhMe/MD22yAtF6soZY3SoesFT7E4VD/6M0+UxJu+bxn7U7opySIav/9IlAaxOiAOf7exQGqHjKEhHBBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeObLByi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeObLByi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B787C4CED6;
	Mon, 24 Feb 2025 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408775;
	bh=Uo345U/DipkTKjRYOsILOVxM6E8GB+vc+TPdIkySsyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeObLByit7xyzOfL1nYugpMkFSsUT1GXG71X9tGMVDSJMle8duK196kYmiU3/pEmD
	 0AuvNONsUt6xKDIbaJcADEFdRA3IFSV/q0MjxFS2y/GBKXiDP4msp/EuDYU7Bm9y2c
	 YfzFyatKtlKnJFUPdIIjkvHmUph6vwyvzPBixx38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 127/154] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Mon, 24 Feb 2025 15:35:26 +0100
Message-ID: <20250224142612.023971514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


