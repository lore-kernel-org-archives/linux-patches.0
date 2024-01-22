Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A6C149010;
	Tue, 23 Jan 2024 00:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969191; cv=none; b=P1hlRtjtMVfzrTGu4m+/uaPUu+qDw+6UQ4sxgWo4jhih45HEuHvAf2S9nOgsuuuKqHEBrkn5t7po2hbwYGuMhGTVUyZYxMyd+NEHJ2WTkxAYmJpSdd3zbbnC+fSmAzde9PXhPNVqlvOFSC0TQSloMAT8FjQ6yKBiuOHWF6QAx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969191; c=relaxed/simple;
	bh=zoRKJm+pnJLD09cTJflloRxuUNOXn7dMlFc0bbNdlLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CppXr+tgnFmYNlvIt9IIzHnh8mVh6Gthn1P2Q+Z2hZIPOdah6dyXJ0IFJVhMgX3mZy1O5t28YYcdcg1QYU1e8JiUPlPb5uLHV9dmbd5weZ4cTVYjpzIjhrT0A8FJki16rG9rQPPjBPtbj7KxfKpPK29PHR51/yO3Rn928vmdbdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYb3QP+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYb3QP+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047A6C433C7;
	Tue, 23 Jan 2024 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969191;
	bh=zoRKJm+pnJLD09cTJflloRxuUNOXn7dMlFc0bbNdlLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYb3QP+CVxnUK8F9KEUEdj1ePZjlkcnXdAkuk/yo5egY/ca+iOXV7P4OgiVRy877l
	 YFpldgATVr/Y8V2ydaAb7bFcsX/ajWhuY7i+GN3I4xc5pF6ve59DFMba9rbEUjb1AD
	 erR37CXFdFtMf+ukIv6Vkon/KEVD7iIb06/9BNNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 088/641] SUNRPC: fix _xprt_switch_find_current_entry logic
Date: Mon, 22 Jan 2024 15:49:52 -0800
Message-ID: <20240122235820.795372822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 98b4e5137504a5bd9346562b1310cdc13486603b ]

Fix the logic for picking current transport entry.

Fixes: 95d0d30c66b8 ("SUNRPC create an iterator to list only OFFLINE xprts")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtmultipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtmultipath.c b/net/sunrpc/xprtmultipath.c
index 701250b305db..74ee2271251e 100644
--- a/net/sunrpc/xprtmultipath.c
+++ b/net/sunrpc/xprtmultipath.c
@@ -284,7 +284,7 @@ struct rpc_xprt *_xprt_switch_find_current_entry(struct list_head *head,
 		if (cur == pos)
 			found = true;
 		if (found && ((find_active && xprt_is_active(pos)) ||
-			      (!find_active && xprt_is_active(pos))))
+			      (!find_active && !xprt_is_active(pos))))
 			return pos;
 	}
 	return NULL;
-- 
2.43.0



