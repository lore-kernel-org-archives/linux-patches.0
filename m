Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028306;
	b=jDerQG2UphOBba974Yr67W+6oiJYpJ3pnPjWyVocMrOtk80N4d7+cMIUyE30taIbsxvu
	 tMhuIZwZfFvFUdw1fdZxko1M75Pj77YrUodaEk/sMLkkufR5as+cUBdxzpMjvfG4zsCyn
	 EBppuhYPcFZgUi0NneTzvSilSe9Yuq0oKaPT4UPuNqI4ZI/NvCdYPzm9laJSu3yufiEsq
	 Gj/brLfAz/vn+HUV3dOopu/lKrkfioMSUYNA9aQtdn1PtigSHnWcUTHEtQIf4k7ol4fCi
	 QorYlVZyQxQOqwF3w8ajau6XCwK/ygWaHpn0drH+axEC0hOEe4OeLj3tI2w3GQddl7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xvNl7gt0oaCpzch5yNUZ2k44GuHR02P6SYgk3yhy6ZA=;
	b=Y/NeX3WC1uYRONKW3dPeyyBF0gFnB7k/CrvZ+x9xMG5dumvHQHPKBtkduvWgpzbEgf9c
	 N+u5NkYbjJF5dOIYikuvcUCKBhFOhPHXW1SNhSQBHA38yUUjx340znmac8U90VY8g16+/
	 OyqeZYr73tEe0z9J33Sw0CzWki/O3CaLxZ/hZBEYQ2c4rFoq99LYazdM6uefPT/1umq/d
	 28FtRVLSfzgVbThpAN5BYXlNlbMo0MFN4ZfTXDhUVcc+Mx2Qm4BMdmpi2UiXuZvGt8pd6
	 HCk1jZrkNo8eQ9czW/m8JwzjT3cJQ7Gd3ouEu0u+2iyRJrjfMizmOM5nVP4huLGdomg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaOS8U1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056E7606A33D;
	Wed, 18 Nov 2026 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaOS8U1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566431F000C4;
	Wed, 18 Nov 2026 18:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028305;
	bh=xvNl7gt0oaCpzch5yNUZ2k44GuHR02P6SYgk3yhy6ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaOS8U1bHZDISaR80RGM3GpsKvFe7yqVZN+dKAub9EgwMmEiSTuUJhugi70VPYsqv
	 BVDNi/LBJib9XngZmvrfSH6PGFHhYDVOw81Tv09DDRAag4ntW+/mmkx2XksxzekEnv
	 hTjNaYMIXTUMqg2TCmo06rWu3n/LqhHBQANWYHD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2099/2151] apparmor: check connect permission for SCTP
Date: Wed, 18 Nov 2026 16:03:54 +0100
Message-ID: <20261118150238.159418619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 2f764c08bb191a8c8f4051926dba0d25d195f39b ]

SCTP can start an association through sendmsg() or CONNECTX. These paths
call the SCTP-specific sctp_bind_connect hook instead of the normal socket
connect hook, but AppArmor does not register it. As a result, a profile can
deny connect and allow send or setopt, yet a task can still create an SCTP
association.

Register the SCTP hook. Ask for connect permission when SENDMSG_CONNECT
or CONNECTX creates an association.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index dca21162a2140..9b9be6849411d 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -15,6 +15,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/ptrace.h>
+#include <linux/sctp.h>
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <linux/audit.h>
@@ -1387,6 +1388,18 @@ static int apparmor_socket_connect(struct socket *sock,
 	return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk);
 }
 
+static int apparmor_sctp_bind_connect(struct sock *sk, int optname,
+				      struct sockaddr *address, int addrlen)
+{
+	switch (optname) {
+	case SCTP_SOCKOPT_CONNECTX:
+	case SCTP_SENDMSG_CONNECT:
+		return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sk);
+	}
+
+	return 0;
+}
+
 static int apparmor_socket_listen(struct socket *sock, int backlog)
 {
 	AA_BUG(!sock);
@@ -1740,6 +1753,7 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_getsockopt, apparmor_socket_getsockopt),
 	LSM_HOOK_INIT(socket_setsockopt, apparmor_socket_setsockopt),
 	LSM_HOOK_INIT(socket_shutdown, apparmor_socket_shutdown),
+	LSM_HOOK_INIT(sctp_bind_connect, apparmor_sctp_bind_connect),
 #ifdef CONFIG_NETWORK_SECMARK
 	LSM_HOOK_INIT(socket_sock_rcv_skb, apparmor_socket_sock_rcv_skb),
 #endif
-- 
2.53.0



