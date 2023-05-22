Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3AC171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28970C433EF;
	Mon, 22 May 2023 19:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784929;
	bh=Rp00WZRLthrDhTokXIjRkJfBI8sDfNumUDvBbjd9LXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNHaIIrF5cakAfFbA0Z+3THaVRhRxyAe7DC2kI18Y74Ko/I/+/agoT0fxHJWnrlKL
	 jvEPY8wcmZVkHlHoFp+bbuZBqriSLwHMDpbIz+VgFQPhaf9NsU9VtAMWTQoeUnBGo9
	 I2nOn+QgX1jpUWEK0AJ6ih8+Lfz6UmEBk90bh/AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 248/364] SUNRPC: Fix trace_svc_register() call site
Date: Mon, 22 May 2023 20:09:13 +0100
Message-Id: <20230522190418.896154636@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 07a27305938559fb35f7a46fb90a5e37728bdee6 ]

The trace event recorded incorrect values for the registered family,
protocol, and port because the arguments are in the wrong order.

Fixes: b4af59328c25 ("SUNRPC: Trace server-side rpcbind registration events")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 9874a6de1de3c..84d0b8798dfcc 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1018,7 +1018,7 @@ static int __svc_register(struct net *net, const char *progname,
 #endif
 	}
 
-	trace_svc_register(progname, version, protocol, port, family, error);
+	trace_svc_register(progname, version, family, protocol, port, error);
 	return error;
 }
 
-- 
2.39.2



