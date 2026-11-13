Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586001;
	b=hbmTioTFqNAs+crkWJYbOyxZdz2BcP986zw4lnI1Cl8dhAfQOqLoqDAS0qFCPoyiRaYy
	 mNYm3RCxFoXdQMAV4SqfSHlCvOCTt17+RP6z8gUNUFhvcR121GT1LFEfapzarhMFtUfHm
	 uPYf1Db88sf3sbfVMZV4CPO8gbystPfVygAwWPyGQj4e2z+fzUdh+qK8V/sJuRIbMnoB6
	 EPL3rPW/ucq48qfrzqwybmAXbdGFYVlc94j020Yz7f+j3fEFUJthTWzqJT/kTEd73Q913
	 h/peNCikEetPnPS6jMhOv5cCtCDfwfEA5DRGtqKlDOPBotHXpPf9sSzjoP97X03Hj7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t223tkpVMuoMgVSIi0H+aO0VHnQbHI01UNXCiyQ9dA8=;
	b=uL19WYE52LkcMn+0kgWgBzGAFqXHBfj4bAU32/FkpSD11xKO2O9otunYizH3agNPmevw
	 KtB4xP65aolW4N3MtG2Y5m3XAHFSG6RDcFIz7Ml1+cb6mmPUzw9Me0RntAKqjie/Id/fo
	 mpOP9wRUd2/n8RxHsA6f6r5qr+PPFx09ctYX/s8Y1YeE7XvwKERpBDZqB4ewa8m4/OHaY
	 sUXJf/10v1jsdlt1QSX1NSI1jkI21xz4qP2Gzl4Fy2y/aEtjt3wzxknwwNwjIJ3Dy7oqY
	 IfFjqzPYBotcX60nqCYR60hP5YWfQW8Unv4TZ7xm+v7WAaTeLU06cDilVlpIhZOIrvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ooQe8/7M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02FD606B2CA;
	Fri, 13 Nov 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooQe8/7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4E91F000C4;
	Fri, 13 Nov 2026 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586000;
	bh=t223tkpVMuoMgVSIi0H+aO0VHnQbHI01UNXCiyQ9dA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooQe8/7MzXYJ0Be8MVeQtxsHQRrWWkBSIu2Oskx8PH4c+RelPSHVojnOc3mNSihtu
	 lY59PG4/KKw2bR3QhaHSLxCMpwZOA6xqx9r2Q0F06Vp2IYmnRMV+313CiwQEk3f9pb
	 Hp/S9Ke5AX8fsPk2jgsquUjxhwfLQsXOKg/BMSzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/686] NFSD: report listener creation failures through extack
Date: Fri, 13 Nov 2026 10:42:54 -0500
Message-ID: <20261113153822.361837952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 967c5bf30d051..49cd0588deb39 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2026,7 +2026,9 @@ static int nfsd_nl_validate_listeners(struct genl_info *info)
 int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
+	const struct nlattr *bad_attr = NULL;
 	struct svc_xprt *xprt, *tmp;
+	const char *bad_xprt = NULL;
 	const struct nlattr *attr;
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
@@ -2145,8 +2147,22 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
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



