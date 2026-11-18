Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022300;
	b=VaXMIHMPpoLTbx1bUWk9yhd0XQdQkDLMpqFEoSOfHBVBfS3R07DWXo9w9z6SP71QHwE0
	 JUVIlcT+PIr6foz7C/EOnaMmCxrXtg1A5AWWCxPDaOawKMKG2cLb5m/rGLClHgWj7mcr5
	 ooWqS/0WqTblcLhwKNLD/cEsU6ayhOirY6M2sKIpInH6XIO6dxoi15UpANcH4q5pkaYUN
	 pl8Y+GXr1Zvph2aH6s1/IHxluZFLB2DDxwyqgvTRxKHlo/SUT5zRhqvkp1+nI23QmZ+sG
	 Ke0vhX/3bKluSKBLJoePgXUoZK6vrPgzFxJLp7ZqTpFG5Z/sE/L9myHnp4jC3n/yVmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WxH6uZmYNupq/q4Ck+ejV6J63yAq8yxbTXS1al9UrFc=;
	b=PwzZWV27VYt2PmjghkCI5aXeOptM7CW6ulY6FkztHNvJV/YHXo4TNqoVqIU+b6Z7SBwA
	 MB3OJLwuausQWY4tMp2mDGuM1MtH97UgYaxanNnwkx1978HaUKjbprBPef5zW8Nf5u+1Z
	 c/mt6kYnZJx7AF0HglRuH4+pmEhPlTJFbYaDvgaJ1oNc1A9/OgRvtHeVnQFyduHGtAJHA
	 fkYl1cf04HWF1HDOEArdDbAmO0cn56nxGkYrazICMtwrTPfZJAjEkkxbwe4vOhY/4HWpH
	 tQ7H18mq25K1NG+wl2C8gHJ2sZnSopFgmKPyxRtMszK5SuOAxTE63bJbeaAH3jS3RtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6KF2osZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA0D606A320;
	Wed, 18 Nov 2026 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6KF2osZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C201F000C4;
	Wed, 18 Nov 2026 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022300;
	bh=WxH6uZmYNupq/q4Ck+ejV6J63yAq8yxbTXS1al9UrFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6KF2osZrI3KiYMrK5UI//Imzcr6xDGqBGY8hEQxU5NmG/NHTsDl05CyZOf73xVBu
	 MGPLekPnNmvexLbUzvMhtmUfqXeFL4oMS8gjmyfEJkxtbPIHgZvxANRNzQsPl6zB8V
	 QiVV+l6diWI4RHraFLgWRmRjq/ckGTVvuPtVHN7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2612/2651] apparmor: check connect permission for SCTP
Date: Wed, 18 Nov 2026 16:04:12 +0100
Message-ID: <20261118150418.276124984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d502ad0ac26f5..dba078c73abc6 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -15,6 +15,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/ptrace.h>
+#include <linux/sctp.h>
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <linux/sysfs.h>
@@ -1405,6 +1406,18 @@ static int apparmor_socket_connect(struct socket *sock,
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
@@ -1823,6 +1836,7 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_getsockopt, apparmor_socket_getsockopt),
 	LSM_HOOK_INIT(socket_setsockopt, apparmor_socket_setsockopt),
 	LSM_HOOK_INIT(socket_shutdown, apparmor_socket_shutdown),
+	LSM_HOOK_INIT(sctp_bind_connect, apparmor_sctp_bind_connect),
 #ifdef CONFIG_NETWORK_SECMARK
 	LSM_HOOK_INIT(socket_sock_rcv_skb, apparmor_socket_sock_rcv_skb),
 #endif
-- 
2.53.0



