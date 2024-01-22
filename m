Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D954BAA4;
	Tue, 23 Jan 2024 00:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970710; cv=none; b=GSatZhqCVxb1m7rPU75Wf00Q3czb8NihjpCQNLxVH8NJaEl1VSTexsUIedQo+wiVKr2VvsBC1Dp4TnbHP0fumLmyhb/UuligY8au3uwTmIfkhqWGKe/lQFfeWNZ6lha8XRwYFVH2yZ7riN5rxahnz3gQexELMilizj62nwe7BGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970710; c=relaxed/simple;
	bh=6OyHwIxTOmDHBYxOdbafKVxcI/DNFNw22/D+6Tp778g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJBS6nYY82pLFq5NkSfZOl8ROLpth9ajDHgsgc8r80fVdoEDZO6tQwDOCsv/YIt/hefC/Gx0U+Kq4/Vne3EAwIpge2GD8vemjy4W9ZUKYLD97NE0VItVUEP94php27VkFAgWC/qGz6SRV7rnYXUE3GuWOQnrkloxXT9F3P0kteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+H0ZWTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+H0ZWTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5A0C433F1;
	Tue, 23 Jan 2024 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970710;
	bh=6OyHwIxTOmDHBYxOdbafKVxcI/DNFNw22/D+6Tp778g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+H0ZWTaJlikqImHSrZPvExz0wz4EJpEPz7FZUH1MJa1OZJtRUq8QdL26/C9mD/jB
	 yV0xivJvkQIrHTYw3MnipkP7fTfeJXkzL9IUUiv6aDbqD15n64Jn2+ZAcnxWp2tEog
	 47LiHFNNOpwPsKR5yDl5d8m7D6lDaN5rdAP4GcjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/286] mptcp: fix uninit-value in mptcp_incoming_options
Date: Mon, 22 Jan 2024 15:55:10 -0800
Message-ID: <20240122235732.174294954@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 237ff253f2d4f6307b7b20434d7cbcc67693298b ]

Added initialization use_ack to mptcp_parse_option().

Reported-by: syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 64afe71e2129..c389d7e47135 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -92,6 +92,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->dss = 1;
 			mp_opt->use_map = 1;
 			mp_opt->mpc_map = 1;
+			mp_opt->use_ack = 0;
 			mp_opt->data_len = get_unaligned_be16(ptr);
 			ptr += 2;
 		}
-- 
2.43.0



