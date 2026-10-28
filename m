Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212345;
	b=cWEJxNe4Ynu2IkgfjPUDq8ND4Oe2dsP1cHhGDe0OEzljHDDFnqOlQyuQJsRii0xv6irA
	 NSVPemZDsNv8hsHs1FygxaPbrLOgzzYe2zlaghG8Bdcd0NyKWRccn/yvyfZfrXv9KJzZh
	 gqPVL+lb+bzI3ayvq+cSOYPMmsmI8mI9supR7qbit0QCNwyXmIFOHP5tacGBGv8HR2/Zf
	 5skm+pFt3ADdNd/3idV8Kf1JQ0oagjHFFii17ce4LDM38RQ8o+qLDtv6zRWqnSJVujq0t
	 Jybs7dah4WJW4fh8sOfDQhlpW3IpUf4p/YWZoIo1oCy5uETL8z5j1aonm0Danb7NkMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qd9rzhzkR8dqIor4LeKJEw8E/BFOTyQkO27J52rw3Iw=;
	b=pi6tK8axwTM3Tx5nA1azdBHE51GxA8nlzN6RaO8m3PphDX+YcREWV4GqleBk2e/H7oUU
	 0RKQoYMoSGS9qvXdpNwuT7YKTNLwk6Y9sCjVrshYszOlh7D+5QYaqbI1zpbwi3rt/rZxa
	 mpyGtBdPsFi9XH9jKo8FuJZbZXz+174vOKhsJAGzp+vtgT2Ij2AECWzNx9JVPsRYrelY/
	 pDunEoJ52PJSEYZxfnqVN3EGmpd25Lo7/HYngcI2X/Fl73JNLPcHOzP5vV8aV/NeqW5T6
	 SaYqhe8reRPB2motu4p8+2+ps4ZucLlYE2HdFWiHn89FZeE07AzWkCDGxzAWtQytQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNDaG8T6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2C606A31A;
	Wed, 28 Oct 2026 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNDaG8T6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573651F01825;
	Wed, 28 Oct 2026 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212344;
	bh=Qd9rzhzkR8dqIor4LeKJEw8E/BFOTyQkO27J52rw3Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNDaG8T6QTnkCGINgJG4POL481nMzDPD8Etg5BxbRs/DS//ZstnkfP1Boi0U+PCUx
	 4WT2gAtkfCPgH+2UgcoYy0BIL2B/MzsxkJnLqW6nzm+YN38OysZLPT4gq4mMhE+mDX
	 uOxRLGU4axewC6s/1rt7Jld0ipqB3awcy9rUPOTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0122/1887] mptcp: userspace pm: use a single point of exit
Date: Wed, 28 Oct 2026 17:36:58 +0100
Message-ID: <20261028170502.014134117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 40c71f763f87b68fe43199c1702220c91afed288 ]

Like in all other functions in this file, a single point of exit is used
when extra operations are needed: unlock, decrement refcount, etc.

There is no functional change for the moment but it is better to do the
same here to make sure all cleanups are done in case of intermediate
errors.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 52ab9a3f070a8..129ae1fef054e 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -77,8 +77,8 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		 */
 		e = sock_kmalloc(sk, sizeof(*e), GFP_ATOMIC);
 		if (!e) {
-			spin_unlock_bh(&msk->pm.lock);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto append_err;
 		}
 
 		*e = *entry;
@@ -93,6 +93,7 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		ret = entry->addr.id;
 	}
 
+append_err:
 	spin_unlock_bh(&msk->pm.lock);
 	return ret;
 }
-- 
2.53.0



