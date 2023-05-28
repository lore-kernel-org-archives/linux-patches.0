Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4649611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75302C433EF;
	Sun, 28 May 2023 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302984;
	bh=nY7qWhuPn/wJBSA+NmdGwi4msTQ78MFC8bW3Fz95PuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaQxjyNYGk12HFjtxRM56kEaVUa1BhL+JjJCdD2d/3tMp46XC65SJgVTEiXnAEVXo
	 SeQwYJB5OHom+VdiX3KehOgeDL0dby14+yHw3hUrSQklnfJX0qKfWuwZqkiAmwCkQx
	 feVu7nAWXPqUVok4mXxscwn9eCEulbkMN7l7rT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/211] SUNRPC: Fix trace_svc_register() call site
Date: Sun, 28 May 2023 20:10:27 +0100
Message-Id: <20230528190846.214578159@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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
index af657a482ad2d..495ebe7fad6dd 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -995,7 +995,7 @@ static int __svc_register(struct net *net, const char *progname,
 #endif
 	}
 
-	trace_svc_register(progname, version, protocol, port, family, error);
+	trace_svc_register(progname, version, family, protocol, port, error);
 	return error;
 }
 
-- 
2.39.2



