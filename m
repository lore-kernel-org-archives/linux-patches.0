Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8EF1C7B9D;
	Tue, 27 Aug 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772187; cv=none; b=uP3Z324/d6lLeYAGQ/vBmCrG8mE5fc2S/j0ZZbLsX2DyLXC20jpxtKof8c8oitH06YZupTOCVUdyoUHuI33ccDwV3gjbZymt2stAM2LZXFSvpLncD6TLMu1TV7c1gESDx6X5s0W6C4cReLvYBwRDQl+Te1xOhki6CcSXaKzCOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772187; c=relaxed/simple;
	bh=+/rrNBS0NHkMj03tE/jKv52n/P4jitiNCihy7nNeggk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chH3gSCm1NRosXMtx4pDUaNQdnAH3RhfOxHCIXrAlfc29490nCR0j3ruOWZlhjK8ZEdMHQXIeDO1JoWQD/yh56pGAMQdaJxohOR3rEIxkgvGNuYjZGJTKl1jukZ/gql3av4dOIGnZqEZSpKTI6pGhmb3NjHpANY91f5s20q1blc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHpNk6/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHpNk6/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62CC6104C;
	Tue, 27 Aug 2024 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772186;
	bh=+/rrNBS0NHkMj03tE/jKv52n/P4jitiNCihy7nNeggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHpNk6/aTmAfRjfd0A4FvQDG6GOL7YHqT+h5uPXq5PWGaY8t6L5hnSOUFZQLGknNh
	 AP3ygOPp205yC05bfvYIE+9KW6rMEUxpXXnfTO4feJhl1MOUFFMVNcl5/DwlZPWDp0
	 HF5Ocr9a8BTo9jw13qu4OvBIwKjq6MukvHkhbj/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/321] netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj
Date: Tue, 27 Aug 2024 16:36:47 +0200
Message-ID: <20240827143842.017049606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit ff16111cc10c82ee065ffbd9fa8d6210394ff8c6 ]

The code does not make use of cb->args fields past the first one, no
need to zero them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 747033129c0fe..ddf84f226822b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7452,9 +7452,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
 			if (filter && filter->table &&
 			    strcmp(filter->table, table->name))
 				goto cont;
-- 
2.43.0



