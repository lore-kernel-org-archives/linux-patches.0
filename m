Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590818;
	b=kuyHAtOeDTPWadbrRQRZ6s+C9+fLKIktsGEPVe0jHXnc4gGsdkxJwHu3QO3iC4yi+Nbn
	 PuxWDxvu0daEvi9FT1eCw8gTOKMOlqSCU8K140SuRQ5p5xh5mZu5pmZbhqe3B+K0DVJeX
	 eR4RTdpDD8IvebYAUOSIKZlqbQOmTnT8y6N78PTFLhbDEmX92C7d0J0xiuj1406INrzR8
	 /Si7xEuDSzroCUZxLH8I9r5dAfmHyGW029v9epbVmTN9VHFy9did679TyjhkSanDS8BsL
	 o6D8RPg7KS2N7vhv9GZN6DFSmtlSJe2wNjVOPPP7fxlq018YwvqwBTd58/Mu8Y8g4ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbcwvjjJixt79BVnlrRNpZI/4wv7kR4sHXqnsiI5BuU=;
	b=VfRD2AVzC5uVvXAdbsbxXANW8iDjw7D9UX6Heu5iXB7Cytxf3756L5MeNXbFImTS1HSd
	 mRJHs0lQ3+8FlOXZ4xyKKmHXOpzgfGDnJ5oTdlHjPQvZk33P6aXoyiQK5HEENKhMj8aEG
	 YU9BXBwr74XTlFL1yEH0HtfTwheuWa9EjZklfBCttIxxTf5165fLiN9EXpCpfSuaE8rQO
	 X1cceQ52LeeTRZdVVZeY2lofpX9bc9iGMPX82EgJZOiqGaC2KuiGprlSHHwjyaNKeq+IP
	 sCxWjnOjgPUDl4gTnqLlSrGQ3VQ/SPY0WOfxYGabcI5eB+Bl74q1ZrDShdygkwY0XAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvKMHg0u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C1606D485;
	Fri, 13 Nov 2026 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvKMHg0u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331531F000C4;
	Fri, 13 Nov 2026 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590818;
	bh=RbcwvjjJixt79BVnlrRNpZI/4wv7kR4sHXqnsiI5BuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvKMHg0uWBSxPd8QcXNQRYbKPUoJNqlRI6JfBb21oC5Rf6djwmT4jtx09uNWz5BeN
	 9gbjbJYMr5NQTbXDwvm0uQtrw+9C0pwK2kyBTMNV/pRxOgKqWlACSSNhW5/lKzsjgE
	 fYNMJTiAxwLkr2geTtykqjRuSlK7xCfVgC/xVdaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/670] NFSD: report listener creation failures through extack
Date: Fri, 13 Nov 2026 10:43:10 -0500
Message-ID: <20261113153812.070308559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a225756ef0d8..ecfdd8e5fd3d3 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2107,7 +2107,9 @@ static int nfsd_nl_validate_listeners(struct genl_info *info)
 int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
+	const struct nlattr *bad_attr = NULL;
 	struct svc_xprt *xprt, *tmp;
+	const char *bad_xprt = NULL;
 	const struct nlattr *attr;
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
@@ -2226,8 +2228,22 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
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



