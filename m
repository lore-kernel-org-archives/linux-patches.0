Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDB61D54A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976C3C433C7;
	Wed,  4 Oct 2023 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443096;
	bh=LKl49VhOqgPTB3ZMIgOeAacNjreAQ5mJtB8XrtKwau0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkflDFVDw0U7X7DzyWL9tnX26rb8cm/U9x5tSaBhRVSy77QUlV2O1KyCQgpRQaudY
	 9Ct3gXlj0+U6giEkGGNRVoTlMJUi+/ghjpS203BpvXb+Hmu5ewZ1vX8lOWwE0visB+
	 IlGX1vMXs25JlRwdqQYddZAXXxGET9nci7uqQcnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/259] SUNRPC: Mark the cred for revalidation if the server rejects it
Date: Wed,  4 Oct 2023 19:53:00 +0200
Message-ID: <20231004175217.773863912@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 611fa42dfa9d2f3918ac5f4dd5705dfad81b323d ]

If the server rejects the credential as being stale, or bad, then we
should mark it for revalidation before retransmitting.

Fixes: 7f5667a5f8c4 ("SUNRPC: Clean up rpc_verify_header()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index b0258507b236c..ff6728e41e044 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2736,6 +2736,7 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 	case rpc_autherr_rejectedverf:
 	case rpcsec_gsserr_credproblem:
 	case rpcsec_gsserr_ctxproblem:
+		rpcauth_invalcred(task);
 		if (!task->tk_cred_retry)
 			break;
 		task->tk_cred_retry--;
-- 
2.40.1



