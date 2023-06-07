Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8121ACB2
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931C2C433D2;
	Wed,  7 Jun 2023 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170406;
	bh=ZbJ7gCDK7c0EFsBKPIYtuF/eh5x1Ur5KVOkMgzp5ZNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awsgUVPzialZeW+nS64c6vO8dr+U0EkDoeaj5Sqjwr2sXWu14owr9/moQDbOnLAA4
	 /O6vt/eF3Bok+KDCGBN5MoxciFGzMiy9crQwRnphARPDXBMG8OR7QloCZYktDn2TfJ
	 /7uOiZuI7aLLk6c5UhrKwg5SsB5Z7zns1XXxzVd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/225] mptcp: avoid unneeded address copy
Date: Wed,  7 Jun 2023 22:14:08 +0200
Message-ID: <20230607200916.155816230@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2bb9a37f0e194ed95c70603b0efc7898a5a0d9b4 ]

In the syn_recv fallback path, the msk is unused. We can skip
setting the socket address.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7e8b88ec35ee ("mptcp: consolidate passive msk socket initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 67ddbf6f2e4ee..4995a6281ea16 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -759,8 +759,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto dispose_child;
 			}
 
-			if (new_msk)
-				mptcp_copy_inaddrs(new_msk, child);
 			mptcp_subflow_drop_ctx(child);
 			goto out;
 		}
-- 
2.39.2



