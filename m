Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061737;
	b=h2G8JsDQEaZXy3XevATPRjpxkM+3uG0G+zYbpyUWcilrtKpahwCIdmNwD/7h1EUgHb9w
	 s79JwrHNCTOQorKsy2IBWzTFmqx24FsgML3rroawLUlPM3P3sRQ90ZEx8fZ2ZX8hXDKfC
	 YFrbcx356XIC13FDvtLqddNi4pEfvbGtbLQMmW4ENtzsqYesd7kEVLNBcv2BezAPd4n1w
	 D8IRHGvdYzC7izpfPDXAKCZHleI8+FcXDiqa3BJthvuoZ3HwNjBU6A+1dJdUacnHRkfRi
	 3tHMER82w320dHIOdkYaNVMjsJJcKLsOnllcNEOjBTrtiZK5cdFz6ezMqQuoCmbqAhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMegGk3thqkwLUxcYDvpbNTO6vOPGrsv5C4Cv/Lc1bo=;
	b=GcKiMhkRf/bxRntMxfOxLA2Ygl+vqZYm/BPLyCbobWZtlMNYcDgPXDgkWhXsPtY9Aeq/
	 U6nWNoA+tl7Ip7+mZo9uwvX8hpy7+C0msuhaf5Wush9p3a2MoHpjP0JEBlkwOEIxtgCoe
	 fwL4cAzCc4sayNS7+LU4RhwFs95+FHmEkY4fSeg+zM/4q4+CCIeaHqiAbO2IBvJ/3L3sK
	 RlZv5oFn6H/GapLJKTS07HbVYIztVyqAcRSikjLD+LFlg93s1hZaNwMZsvR6mxCYklKkJ
	 HEEvyPMUQte9NslcqYbsVO513pjxg+hGObL7+1ox/mtfapHJnm7ri+/nYlVDENkIodw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cARS2WxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E01606A326;
	Sat,  7 Nov 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cARS2WxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500D01F0089F;
	Sat,  7 Nov 2026 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061736;
	bh=aMegGk3thqkwLUxcYDvpbNTO6vOPGrsv5C4Cv/Lc1bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cARS2WxBO/ca2FwF1HAKv4CRQqOnIYFSAXDzAkO8kOeGP8YePSgm5DlFZYWVcrYLm
	 QTA0HZp3agfRBAVYWaP+xX6viFVCCgU4mRbhsZEKfmF+MHrlxDIV/QKiExFPM9oqL/
	 wQTTXpugey7+SwTBuOQcJiBdBElhChL/2qPivNCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0777/1536] NFSD: validate transport name in listener_set before serv creation
Date: Sat,  7 Nov 2026 08:46:33 -0500
Message-ID: <20261107135019.356366874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

commit 421becdc5cf4d7d2fbda393e78ca76d25d277c0f upstream.

nfsd_nl_listener_set_doit() holds nfsd_mutex for the whole listener
teardown and rebuild. The code checks NFSD_A_SOCK_TRANSPORT_NAME for
presence only, and not for content. An arbitrary name therefore reaches
svc_xprt_create_from_sa(). There, a name that matches no registered class
calls request_module("svc%s", name). That call is a TASK_KILLABLE usermode
helper upcall, and it runs under nfsd_mutex.

Check the name against the classes that NFSD can create: tcp, udp and
rdma. The check goes in nfsd_nl_validate_listeners(), which runs before
the code takes nfsd_mutex. The rejection names the offending attribute
through extack, since -EPROTONOSUPPORT on its own does not say which
entry carried the bad name.

This narrows the upcall. It does not remove it. NFSD accepts "rdma"
without a condition, so on a kernel that does not build svcrdma the name
still reaches request_module("svcrdma") under nfsd_mutex. That is
necessary for the modular case, where the autoload is legitimate.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Link: https://syzkaller.appspot.com/bug?extid=c7eae0eb80858a2dba0f
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-2-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2013,6 +2013,23 @@ err_free_msg:
 	return err;
 }
 
+/*
+ * Transport classes NFSD knows how to instantiate. Vetting the name here
+ * keeps a bogus string from reaching svc_xprt_create_from_sa(), where an
+ * unknown name triggers a request_module("svc%s", name) upcall under
+ * nfsd_mutex.
+ */
+static bool nfsd_nl_transport_supported(const char *name)
+{
+	static const char * const supported[] = { "tcp", "udp", "rdma" };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(supported); i++)
+		if (!strcmp(name, supported[i]))
+			return true;
+	return false;
+}
+
 /* Upper bound on the number of listeners a single request may carry. */
 #define NFSD_NL_LISTENER_MAX	1024
 
@@ -2050,6 +2067,13 @@ static int nfsd_nl_validate_listeners(st
 		if (!tb[NFSD_A_SOCK_ADDR] || !tb[NFSD_A_SOCK_TRANSPORT_NAME])
 			return -EINVAL;
 
+		if (!nfsd_nl_transport_supported(nla_data(tb[NFSD_A_SOCK_TRANSPORT_NAME]))) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NFSD_A_SOCK_TRANSPORT_NAME],
+					    "unsupported transport name");
+			return -EPROTONOSUPPORT;
+		}
+
 		sa = nla_data(tb[NFSD_A_SOCK_ADDR]);
 		if (nla_len(tb[NFSD_A_SOCK_ADDR]) < sizeof(sa->sa_family))
 			return -EINVAL;


