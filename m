Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D4179C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C239C433EF;
	Thu, 12 Jan 2023 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533368;
	bh=sko+ZIXtF1FcmTe3bkUA1MmWUbBjB3/cTakJ+rZMrmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USDKyBsf5wajRRkQOwvMgIkYAkslLbYHOi7gZvRGdkGSsckLawQl8c+Q3EbWu4NXG
	 UhwKIHoKaSOIQ3ijUmvJ0rteGTkAqcbngKRDrJtzi4/vlC1KflOMX7dV7pL0XuHQXn
	 Bd3GCFaT0gevifarAXiQOjEIikWHrRFY5RbjdOtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/783] NFSD: Remove spurious cb_setup_err tracepoint
Date: Thu, 12 Jan 2023 14:52:52 +0100
Message-Id: <20230112135545.389597030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 9f57c6062bf3ce2c6ab9ba60040b34e8134ef259 ]

This path is not really an error path, so the tracepoint I added
there is just noise.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Stable-dep-of: 3bc8edc98bd4 ("nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7325592b456e..4eceff561e5a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -915,10 +915,8 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		args.authflavor = clp->cl_cred.cr_flavor;
 		clp->cl_cb_ident = conn->cb_ident;
 	} else {
-		if (!conn->cb_xprt) {
-			trace_nfsd_cb_setup_err(clp, -EINVAL);
+		if (!conn->cb_xprt)
 			return -EINVAL;
-		}
 		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
-- 
2.35.1



