Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E6125DD06;
	Tue, 11 Mar 2025 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706129; cv=none; b=jnA1faxHCe6kLPNWiK/ryDRm0Tn6p0zb4XiuPILqZsSepESRY1v07HPlu7SdOezJchN1j/mmR9nvCQQRRE7pyiqHaerWUl871DhhoKojI5Vqwf563ZjYz1sRysiKK3COipSsaqA6Pna9WBGvd/2ckJYwX5q674KunefAwjeEpZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706129; c=relaxed/simple;
	bh=hNgopTKv8Ic/T9+iHrbit02UT3TqlZsp4/mZ0/Cb4Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPwlZSv0/rSOgWMPhP/X3lTVnPuY3sV0chJuGDIpx9OeL/rUGt8zkIkYezGvl8lTWebFtL83ICWjy75HR/BxRx7F7c1nFYv0AnWhizA8uCh9Iv68uAFgQe7U9ANhL8ee9W0WozBmAPHPXohpx8EFSINaai2spc1ERMF8dFCW7rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu8ArXOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu8ArXOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9621AC4CEE9;
	Tue, 11 Mar 2025 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706129;
	bh=hNgopTKv8Ic/T9+iHrbit02UT3TqlZsp4/mZ0/Cb4Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu8ArXOMmJkZumvQC52DRR/vaEZtoR4ZxHJPxhKcrkmTPxxhFfaqFqhY1CJAVh0eJ
	 UZZWCx94UBTIh9x1NOlTF+Sw1hAvrPrEPbDoyondiHyum4q+jW76RMSYadTujPrXIz
	 2UvcPk0RbROOPEB+K1HpA9tymFSHUSMDuqvfXtHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 253/328] nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
Date: Tue, 11 Mar 2025 16:00:23 +0100
Message-ID: <20250311145724.965956789@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


