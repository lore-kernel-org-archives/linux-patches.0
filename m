Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061712;
	b=GZgDxw0rN+p9qKU6ttv18ojQA1KjHqvqKW19/0yYteyR9l2Lt5WX2M6BrUp7HriMnT4n
	 9tyYXlIZyEvPz6d0ox+NEubQtQ15rGT7n1mldo6qFgNm8QFkJbhnLQTbZenxTRxihr4ap
	 msWZrb3H68h5Gx+mqdvTGxovKr/eOkD72lbqfMorxqpOKVpdPA7UoNkPHtcz+N5BUjreT
	 kS+MwN0GI3eu/M5DLyfuTow7rOJCwqUyqyT7V8OycwGkkc1pp3UQ5W5qLUxY1tvld+S+k
	 IQ2I9k0cs71yqd12H8vC6kxjl5LxwrWjNHFIe9M6trEph8VXQd5R6IVr+riz8LD18nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g07LWWIn5kDOiUz+wKL1xUw/DZneuF4vz2iUPuRgJXs=;
	b=vL8N1s0ipawzRJQb2/OJWA8EIEuTTwrHwKXjK9n3CK6+mgC28Gir/aG0zfD6LDbFu4MB
	 ZKlmKU/pjfutjcUdlHpOJCxeg4XimqsqMM9X8SnggFG7txMUEejHJVg24F1rP5ZkoARDb
	 Pc4J1mvVCnAOtdkvxET+DQor+r8Twfwujy7RlpHTUgCvr0WhC7vBAMyze0HsOQ2Zq2YWu
	 AU+6qM03poO6Ybt34u+nKiR4pDxhy9TlTAdJtHX1ASPvVVCitOb0ecEeabvXzxqKZQMHF
	 onBDgSW214nN86n7pEwPJhLb50QdHFufsbeaMaoD1zuklObgvPYHdiVMTh1vlsZFVqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o28uTCGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F61606A326;
	Sat,  7 Nov 2026 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o28uTCGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9381F0089F;
	Sat,  7 Nov 2026 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061711;
	bh=g07LWWIn5kDOiUz+wKL1xUw/DZneuF4vz2iUPuRgJXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o28uTCGYkdzTviuTF9Ei9D8BmYl1g/Bz824PxwUNxVuQT2nQSw2MUR5YI4lqpfzGz
	 4PgpcaoKDI3hlmZnWZsGx8xW3hmgbzcujmUPHQ+5hP7SiFzV9jPWz0xF7B5AMyXAIG
	 AL4vK6yI7xbV7ZBGO/hC9A5mH6bcOhOhba+01KK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0759/1536] NFSD: cap the number of listeners accepted in listener_set
Date: Sat,  7 Nov 2026 08:46:15 -0500
Message-ID: <20261107135018.850843487@linuxfoundation.org>
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

commit 9a05e5ee0a98b9550521df86936b5f825bc07ec2 upstream.

nfsd_nl_listener_set_doit() matches each requested listener against the
existing set. The nested loop that does this is O(N * M), where N is the
requested count and M is the existing count. The loop runs under sv_lock
with bottom halves disabled. A userland request with a very large listener
list can therefore spin in atomic context for a long time.

Reject a request that carries more than NFSD_NL_LISTENER_MAX (1024)
entries. The check goes in nfsd_nl_validate_listeners(), before the code
takes any lock. The limit is far above any realistic configuration.

This patch does not cap M. Only the message size bounded N; real sockets
bound M. A listener_set result set is the requested set, so that path also
holds M at the cap, but __write_ports_addxprt() adds two listeners per call
and removes none, so repeated calls can push M past it. The worst case
under sv_lock is therefore 1024 * M, plus 1024 nla_parse_nested() calls.
Both interfaces require CAP_NET_ADMIN.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-1-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1994,21 +1994,22 @@ err_free_msg:
 	return err;
 }
 
+/* Upper bound on the number of listeners a single request may carry. */
+#define NFSD_NL_LISTENER_MAX	1024
+
 /**
  * nfsd_nl_validate_listeners - sanity-check the listener list from userland
  * @info: netlink metadata and command arguments
  *
- * Walk every NFSD_A_SERVER_SOCK_ADDR attribute and confirm that each entry
- * is well-formed: it parses against the policy, carries both an address and
- * a transport name, and the address is long enough for its family. Doing
- * this up front lets the callers below assume every entry is valid and
- * guarantees we make no changes when the request is malformed.
+ * Walk every NFSD_A_SERVER_SOCK_ADDR attribute and confirm that the list is
+ * not oversized and that each entry is well-formed.
  *
  * Return: 0 if every entry is valid, or a negative errno otherwise.
  */
 static int nfsd_nl_validate_listeners(struct genl_info *info)
 {
 	const struct nlattr *attr;
+	unsigned int count = 0;
 	int rem;
 
 	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
@@ -2017,6 +2018,11 @@ static int nfsd_nl_validate_listeners(st
 		struct sockaddr *sa;
 		int err;
 
+		if (++count > NFSD_NL_LISTENER_MAX) {
+			NL_SET_ERR_MSG(info->extack, "too many listeners");
+			return -E2BIG;
+		}
+
 		err = nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
 				       nfsd_sock_nl_policy, info->extack);
 		if (err < 0)


