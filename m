Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFCD60B86;
	Tue, 23 Jan 2024 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970691; cv=none; b=JT2n+boM7UG6vRtR0qU4H83OkXy28a4pGnfm40jajDwp11W5iYAmKUggS3vf+TFoNtlB+C0vBwDSyBr99O5chrFitGZ5aAW5WKVoYBgjx7uimvbauZSGb6+ir/E/ClphCTBwGMzQ+LT6e0PWIEADbS7wttrQTsooXOITTeNt3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970691; c=relaxed/simple;
	bh=zmFFmBvsL6V+28c0tIqgk5bPnypi4oZHiFEznWqkNYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTAaL5UDMzqAMV5cXjggyFthgKjGdtTOBhwtX9TPFHdA6ZH7wB1iBrF0o0ziBlhD9YddVzFRMBDk2V+V5LO88jZQMs74bXc62YkhrC5iCf9o4BAx+aP+g1jm/GISwOlmHVtGbYFY+lw26bEpXNcmmBgh2vIfTLoVzgg4Fla3XLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DngHCphA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DngHCphA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6156EC433F1;
	Tue, 23 Jan 2024 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970691;
	bh=zmFFmBvsL6V+28c0tIqgk5bPnypi4oZHiFEznWqkNYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DngHCphA1GMMZ+rMAVwdpv/QYoBtwyftPUYTxFoMCgeiq0BmyrKHs0MzEO02nw5aj
	 MaTwaG27SmH4uO5BOjqqjjN37aEafn72qfRinkytSkEchICOAJRqKxuMM1rPDhcQep
	 DfOOFUNbKaAH0TBGOqvp0hBFL6M7jz8A8Y7waQzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/417] SUNRPC: fix _xprt_switch_find_current_entry logic
Date: Mon, 22 Jan 2024 15:53:54 -0800
Message-ID: <20240122235753.987910581@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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



