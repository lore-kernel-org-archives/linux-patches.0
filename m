Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831757;
	b=xj0togI2F51HGZQ3kYeL3pGfk4QJcS1sAcuK0zGeOpvBkFkAsF4YMsrNWXm1JiViPy0w
	 5v+Xwnoi28HxWZoE7+TW+1SxN2ACvAfbhR4zBNSwnQxnv4UX9NpdsFKS8zdUuZxTLwBk6
	 C009INEvpPQ34ZScLIjcZAWxqskv2vcdtEeR636tqL7Uj9LVICCKOZ9hnTXN3vWwrXidB
	 +DhEZKRUiJgWR8l8jOMc2sP8KADiggXh2oXNX98NoXwabSYVvcykEvtph6NZ1yh6pkXwj
	 vD4rsfG7fC0SUR850XjFXYSokxjS/zA/sBjr2zjbYdsKAFfnkrzJMGSYGCv1XODZQiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAO0FewQa2jb0WAmiqbij5RbI92XsAyuiJJT7zOVMio=;
	b=jFFiF1Ag8FCYk2NFGmKmk4tNucy3GWvuAImYEl6O5LQ2/lEmHnLsrSQF3zlGFmuTw4pd
	 etu6PmYpHB9ZNln6cHS7AfK47gtL0xqf663QyKb48Xq07czXAMbr1SyThOfrX3kzfpaAh
	 GFhkOebvPxCViQU3Lsw+0+mKWSLx3ejyd6dGejojnzIYzn15Hw04awwKMKdtZhBxqWOzF
	 ReTYEQUJ6jx3s11yc0G/Vad8NmMfV0IpYSfDWOvZTT2tTFwPwudfHNmqLRVXdEx3Rx944
	 b22bmPA7oWJ3vZiAR086x4+63iSJpT0/SdHxeHOABfrZxOpvJqmiu4F59YKBRxz3BQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLeUMwyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FFD606A31B;
	Wed,  4 Nov 2026 22:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLeUMwyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565E31F0093A;
	Wed,  4 Nov 2026 22:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831756;
	bh=AAO0FewQa2jb0WAmiqbij5RbI92XsAyuiJJT7zOVMio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLeUMwyUYQKUeQZMNYLJEV3+SqMMx8jhJw3F0Dx5m01rfLHv2yI0VfTykIiR6GOae
	 Jrw8ZMW5Hzc8fWK28EMnaZQYU5aF2PQJ80paShqbMF9JC853THWdHaON6VEOfO7huM
	 BUsHKAZILbwi8Ouhz99KPnvBAKCVX1Y0mxRIWBjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0885/1005] NFSD: cap the number of listeners accepted in listener_set
Date: Wed,  4 Nov 2026 16:10:18 -0500
Message-ID: <20261104211108.020988373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1913,21 +1913,22 @@ err_free_msg:
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
@@ -1936,6 +1937,11 @@ static int nfsd_nl_validate_listeners(st
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


