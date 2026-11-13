Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585374;
	b=YXoP/p6mpgwRhHTJJG5XR2/HOgB6Ri29FqPUCpbXA3jp8rxnrjzyClRPeRygf4dF0qyN
	 RwGW/8snJvRWSiylvAgUzz8Jhb5kwP8W6rctWuEJzcDkau/WUkGxbiEMsBf+1upBRR5L7
	 waQLrO4t7mRIA1wT8QkL7ZWAweuxf3fJ87wZjckk5562qY3xOROPWrAvhDUTYSWqwKi52
	 yCkyZ+kKkXUo80CxkIb0O/vljfdoNv2hQ9pS5ALpXL9xSEyUSnh8KONWO4vEDyWk0Qoum
	 fCYUGTD6aQwTkB33oozoVRqv+0YC9Jb/l7Fk90aUwx5hZcTSrXqp1R+ZPB426KjnzJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kw0urNROBJflTXfLihC32oE4wucN9yb5E9C99pv1zME=;
	b=jEmkmwO8JsO0I6FQsSsY9ECMmp3BYOcbNjeAxoxJC5vpfbgJk5iVN5TyJ6xIOiebLAUv
	 bhfqvo8TA1hReI//ZiMRGfJgSo+jPsP23md2YxH+weyFkQXnyFJ1hgLA+lw/koicJTf/E
	 SWAHdn3jNG9TTvT6MoD+dF5QkRbQ0K2RLuZnLypH5iMPgvgISJ7wt0GHOc4WeGAWION5R
	 fu7A9LCX/sdubZpOfYa9IxyiFSWlSBQXSbMg1SCqpONqxvOM3EKv56LihfHQA5IEK0NDW
	 Ic2783v0lDvjQGl6NwOh8amen2MN2oEiooWjZtV4LmhhyFWM0krKQT2gdwOyVkifadw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbPHmSz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA74606AE37;
	Fri, 13 Nov 2026 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbPHmSz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0221F00929;
	Fri, 13 Nov 2026 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585374;
	bh=kw0urNROBJflTXfLihC32oE4wucN9yb5E9C99pv1zME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbPHmSz6OCHDVAONx6C3pfq5wWtYMjweDwR2DHHbtjdELBr2MLX8xT6VzsonH7VrV
	 uQDWz/y/ZxS16d1ntS1F7ILoIqogOrRoS44kROO4bKTtZAays97JSDfdSW6tvI5Y7U
	 rMd/Z+ysQWoyWdTeCE0+3JNZPmLyEeKz/Sca41x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 013/507] NFSD: report listener creation failures through extack
Date: Fri, 13 Nov 2026 10:45:17 -0500
Message-ID: <20261113153753.835313521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8e590a16853fedd2697a3b0c32b3cbf1a444f7b2 ]

nfsd_nl_listener_set_doit() returns the raw errno from
svc_xprt_create_from_sa() and sets no extack. A failed LISTENER_SET
therefore tells userland only "Address already in use", or whatever else
the transport returned. It never tells userland which entry failed.

Record the attribute and the transport name of the entry whose errno the
call returns, and report both after the loop. NL_SET_BAD_ATTR() names the
entry, which the message alone cannot do: a request can carry several
entries with the same transport name.

The rejections in nfsd_nl_validate_listeners() other than -E2BIG and the
unsupported transport name still carry no extack. This patch does not
change them.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-5-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: bf0f3a37e6cc ("NFSD: stop registering with rpcbind after a failure in listener_set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 86aa8d202b4b1..714c73ddd9dc1 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2086,7 +2086,9 @@ static int nfsd_nl_validate_listeners(struct genl_info *info)
 int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
+	const struct nlattr *bad_attr = NULL;
 	struct svc_xprt *xprt, *tmp;
+	const char *bad_xprt = NULL;
 	const struct nlattr *attr;
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
@@ -2205,8 +2207,22 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
 					      current_cred());
 		/* always save the latest error */
-		if (ret < 0)
+		if (ret < 0) {
+			bad_attr = attr;
+			bad_xprt = xcl_name;
 			err = ret;
+		}
+	}
+
+	/*
+	 * The ack carries the errno of the last entry that failed. Point at
+	 * that entry as well, since several entries can share a transport
+	 * name and the errno alone cannot tell them apart.
+	 */
+	if (err) {
+		NL_SET_BAD_ATTR(info->extack, bad_attr);
+		NL_SET_ERR_MSG_FMT(info->extack, "cannot create %s listener",
+				   bad_xprt);
 	}
 
 	if (!serv->sv_nrthreads && list_empty(&nn->nfsd_serv->sv_permsocks))
-- 
2.53.0



