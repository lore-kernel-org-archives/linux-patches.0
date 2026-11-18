Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033351;
	b=3tEtYZ15UFor9FsbQ4NoQRujO++5bEShpcAHDnkeX4GvhxEo+SEpZwEB0LTh1whEwX1o
	 59jGmgvOw3qHW6YgHnT4KtLX/7m+4ntk7vgQel+uustv8husF7mAY3DzjtfBRqiYXov1w
	 aA05HGcErLwLycwt2kBQpXYnB4AHOX6dZtaeAjmpVKrvknhAwz6SmYe/mOrOV4J0iTV1a
	 mvpmHm/3a0E09HesWQsJll7NVJn8KnpLhP10xuP8il9DRl+oQNw7bZ/9UimJ5+6014peB
	 m4a1/K7zMwt4YyIbD06rFLvhmDngTpbRV9zmwJf/wx6QaNEiRbfQ4RCDmruq4hDyY5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TewA2nZs7DrhrJ3C7EvfEiMtkckdQKTf63Pqxen8Alw=;
	b=hLBmrdoLaK6iY8aAXGAKgUXl8GYBeSm/SdHr2PCh2jLNZP5lkBoodMHr+gg/jFiEhW67
	 MZ/ZGcjp3xgWOPCGUHfy8PfwdAQooNpjDSL4zacfD4Qo6Vi/FDdO5/QbGR5X6te9yWPWe
	 Bg1YosEiFG4NZqVPxKrXdJhYF+/BbrGJB9SkzEAJ+6CRm+Kk2ywiZbnyf8NBnqPRtT7Ou
	 0gcABE8SDHoXx69KCvvoKG+S0vLBEfwUU1s+WpYkENXA4XLeyjiuxyfPXDL+lV+WEuNl0
	 hXv/heaH8ANSXs9RQg6J2CedYtFeief+4H0uGdFSYqi9kThCvKPJlNo4BLWF05AkFYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7VsoAWb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB7606A31C;
	Wed, 18 Nov 2026 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7VsoAWb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4D81F000C4;
	Wed, 18 Nov 2026 20:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033351;
	bh=TewA2nZs7DrhrJ3C7EvfEiMtkckdQKTf63Pqxen8Alw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7VsoAWbTiG8RIkDVZ6WkLEC/lK54T4zDKKOkpFC2ajhTGM99oDzE/gACFkS+nh81
	 faE/f8k6OlQikvApvB24n9+jeR/dx5iz/Pko2CFisI6FA9e5Vvw1VctumophxQ3vDW
	 7V68mrzZPnrzKIW9jNcuO9W55654MDUy5q6HQDnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1695/1756] apparmor: check connect permission for SCTP
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150117.140018294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 89c79fd241bad..47d772d36627e 100644
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
@@ -1164,6 +1165,18 @@ static int apparmor_socket_connect(struct socket *sock,
 			 aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk));
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
@@ -1492,6 +1505,7 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_getsockopt, apparmor_socket_getsockopt),
 	LSM_HOOK_INIT(socket_setsockopt, apparmor_socket_setsockopt),
 	LSM_HOOK_INIT(socket_shutdown, apparmor_socket_shutdown),
+	LSM_HOOK_INIT(sctp_bind_connect, apparmor_sctp_bind_connect),
 #ifdef CONFIG_NETWORK_SECMARK
 	LSM_HOOK_INIT(socket_sock_rcv_skb, apparmor_socket_sock_rcv_skb),
 #endif
-- 
2.53.0



