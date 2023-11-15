Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6072043AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQ74j3Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4A7C433AD;
	Wed, 15 Nov 2023 20:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081243;
	bh=0QrraTHOAxWohOxVGpLrfdG8zENZSGYHeVYAMm7fIho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQ74j3JphXmPt38/LbSMcNoP9QqUukJcdzHOpPrXo4Wx9tbt6WdKVA/QTOwcfDJwn
	 xcKso3OmOn6QzrTadtCe9FKsgsnYj0kllngdVgiFj5a087OBTGiQPhGlTdgxguWPTD
	 9rN6MGYO+k/vg3ATfTD92G9XzfSfQMHs9W88vJKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/244] netfilter: nf_tables: Drop pointless memset when dumping rules
Date: Wed, 15 Nov 2023 15:33:49 -0500
Message-ID: <20231115203550.592878853@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 30fa41a0f6df4c85790cc6499ddc4a926a113bfa ]

None of the dump callbacks uses netlink_callback::args beyond the first
element, no need to zero the data.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8a4cd1c16e0e4..8f12e83280cbd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3184,10 +3184,6 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 			goto cont_skip;
 		if (*idx < s_idx)
 			goto cont;
-		if (*idx > s_idx) {
-			memset(&cb->args[1], 0,
-					sizeof(cb->args) - sizeof(cb->args[0]));
-		}
 		if (prule)
 			handle = prule->handle;
 		else
-- 
2.42.0



