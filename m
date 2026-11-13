Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591230;
	b=sNWJk0DTXB7yXWZL54f7+7PsyVWRhADMkOjFOoZFyH0z1cVzzR+kJ751hgd9tDsGV7/9
	 /Ik5MfZLQlZBrrzOfkCiOIt7iN+Dz91oYGjDt1ywROQnPWa/vBvbUdNoJtc/6P/2srE7a
	 59jLQRhy1Dmlt/BqFy+xZVcX/+qZKQw5j4sux/4OT0+GA5ZHx5MuI4dFydRN4lzfoCaC4
	 1XDNzirNPgdEvpW7Yd5wuKMYIJikjHnXbpkTggSsgPwBlDCNQfQlhZsuhAZxXGi4vV9td
	 G0jBsQFneJ7iwuM3lYIUbl/ar5wRXz42mXKvY06uRXCVmfPRwOLZe+Unbv74wASpw0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NajRtyu6PE4l1RSFvNO6QfJXJBjUu1jcE4cOQoSMuG4=;
	b=f9L5OmdEMKo1R8w9Ljb5LzoViMlDtgZgenRmoHMZJh9AOsQG+iRsOtazCGVa3kbBCco6
	 MmQEIJ79x94Wn7fMj3U7Z4L3Swz4aQz5EbD206eJKkcVfHett3NmtkFLNY24YlU3A0JFa
	 esfL8m2hVztJraJYUsv5I44VcONNS1IXyxV4EfEhfTashvkGY1SpcSEHHo9EWo+NUTFfL
	 RPbqP0Ca3LTAva5/ahK4f1QEK2Lq0rwueAoRPdxEixxEIyllfjWD7fDM4xOUMPlVykvOB
	 CaT/DoNFHlxXoVWfhjiKhu9kD1e2VzRERRJNnn02qJQeBYEFJtY7bCnTDsAQkcettgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEDDKa3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBFF60A2603;
	Fri, 13 Nov 2026 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEDDKa3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF341F000C5;
	Fri, 13 Nov 2026 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591230;
	bh=NajRtyu6PE4l1RSFvNO6QfJXJBjUu1jcE4cOQoSMuG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEDDKa3Vq0s+Vclpp4prQTCGp0xVn+WjgKe/2Gb8vI/ml2nrQ8Ya28n9JWD7IROS0
	 K0vm2aCBpfmRy5LN4xbZhmyKiC+W/qAR16IP4GXCMxP2xsxOMyxMtRLOHV1xJUxOPF
	 9UYFmUtqbUfxkR9xyliKhulztPJ2tJrr1sjsd/mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/670] l2tp: only return sessions of the given tunnel in l2tp_session_get()
Date: Fri, 13 Nov 2026 10:48:44 -0500
Message-ID: <20261113153824.010238856@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit a75facf4bb3e866103ddca4f47a6f3ca4b090d8b ]

Commit 5f77c18ea556 ("l2tp: use IDR for all session lookups") made
pppol2tp_connect() and the netlink session commands find sessions with
l2tp_session_get(), passing the socket of the tunnel they name.

L2TPv3 session IDs are unique per network namespace, except that
sessions carried over UDP are only unique per UDP socket, the socket of
their tunnel. However, l2tp_v3_session_get() only checks the socket when
another session has the same session ID. Otherwise it returns the
session, whichever tunnel it belongs to. As of now, a session command
that names the wrong tunnel acts on a session of another tunnel, and a
PPPoL2TP socket for a second L2TPv3 tunnel fails with EEXIST, because it
finds session 0 of the first tunnel.

The issue can be reproduced with:

    ip l2tp add tunnel tunnel_id 3 peer_tunnel_id 3 encap udp \
        local 127.0.0.1 remote 127.0.0.1 udp_sport 5003 udp_dport 6003
    ip l2tp add tunnel tunnel_id 4 peer_tunnel_id 4 encap udp \
        local 127.0.0.1 remote 127.0.0.1 udp_sport 5004 udp_dport 6004
    ip l2tp add session tunnel_id 3 session_id 7 peer_session_id 7
    ip l2tp del session tunnel_id 4 session_id 7
    ip l2tp show session

Before that commit, the delete fails with "No such device", and session
7 of tunnel 3 is still listed. After that commit, the delete succeeds,
and session 7 of tunnel 3 is gone.

This patch will make l2tp_session_get() return NULL when the L2TPv3
session it finds does not belong to the given socket. The receive path
calls l2tp_v3_session_get() directly and is not changed.

Fixes: 5f77c18ea556 ("l2tp: use IDR for all session lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Acked-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20261030032617.4065353-1-hengyul@cs.unc.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7cdfab3a78094..6c83cb02d4345 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -315,10 +315,19 @@ EXPORT_SYMBOL_GPL(l2tp_v2_session_get);
 struct l2tp_session *l2tp_session_get(const struct net *net, struct sock *sk, int pver,
 				      u32 tunnel_id, u32 session_id)
 {
+	struct l2tp_session *session;
+
 	if (pver == L2TP_HDR_VER_2)
 		return l2tp_v2_session_get(net, tunnel_id, session_id);
-	else
-		return l2tp_v3_session_get(net, sk, session_id);
+
+	/* l2tp_v3_session_get() doesn't check sk if the ID hasn't collided */
+	session = l2tp_v3_session_get(net, sk, session_id);
+	if (session && session->tunnel->sock != sk) {
+		l2tp_session_put(session);
+		return NULL;
+	}
+
+	return session;
 }
 EXPORT_SYMBOL_GPL(l2tp_session_get);
 
-- 
2.53.0



