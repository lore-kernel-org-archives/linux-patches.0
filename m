Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62D419B59C;
	Tue, 16 Jul 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145080; cv=none; b=nE02EXJWUAbYjhcZjDYl430wpHU5UCklhAslmKlr1+o/wfKUfEAGO2+yiXSAjZ5E+VjJyyXjV/pt/6vJLsvVFCrEjzrGJSMAJ+h6ZrVWSmAgJhUNag00GzUJNfsMYL5LCCXA77H3o9RMp/onXVv4LfTCrK2QA/ndXJwnPTdqQ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145080; c=relaxed/simple;
	bh=8eAltQYmoBE0ypS4/w7PxyWcDXhUMKmmpzQKqsmq/k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qupIbt8JFZ91AvSq5geOYFm9aphdrMfO1RCTTq5pXJJiZfV/VP/T0NJi0+eAPOR3V1FD9jii4+aW6eWQlA/eKCI+TDwMQn9fI6SBu46PDCfv37w8hi7iFqhYTYiDPdqnRQKxOl8NnOoLQiOUTnXEgMcvv1HuNiU4iEsg8ae64H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5dMNufq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5dMNufq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4BAC116B1;
	Tue, 16 Jul 2024 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145079;
	bh=8eAltQYmoBE0ypS4/w7PxyWcDXhUMKmmpzQKqsmq/k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5dMNufq7j/UqUVXl/njJAPVte2LYBgLa0tBngfnjU4TcdkevhQiNU8WpNJuwPoWP
	 gUUe1/jRDB4TVMBZQs0FAmaCJm17Ip7q6ragzuOzEZHaTpMobu9Pq2x6wlqlX788IM
	 UZjkCQ4Uia1Q4pGQzAld5J4PMN5xxzLH61/W4BX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 061/143] octeontx2-af: fix a issue with cpt_lf_alloc mailbox
Date: Tue, 16 Jul 2024 17:30:57 +0200
Message-ID: <20240716152758.326037790@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 845fe19139ab5a1ee303a3bee327e3191c3938af ]

This patch fixes CPT_LF_ALLOC mailbox error due to
incompatible mailbox message format. Specifically, it
corrects the `blkaddr` field type from `int` to `u8`.

Fixes: de2854c87c64 ("octeontx2-af: Mailbox changes for 98xx CPT block")
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index eb2a20b5a0d0c..f92dfc65a0ffc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1746,7 +1746,7 @@ struct cpt_lf_alloc_req_msg {
 	u16 nix_pf_func;
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
-	int blkaddr;
+	u8 blkaddr;
 	u8 ctx_ilen_valid : 1;
 	u8 ctx_ilen : 7;
 };
-- 
2.43.0



