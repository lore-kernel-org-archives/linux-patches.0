Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623991;
	b=EVKS81WREfej3SaiHByFdsKrlLWRUZ1YQheDPuOSv38MkAKPQfp7GuCMai5lggHcWiW2
	 kTye+NccgT2HxdX+qb6C3L+HR9WdLsXg1ZYYzNOgRl9jw5oWVPj9Mnfi6KLjS9SsM/+Kl
	 R8y/VDs2sOiFguFqsdh4tR0nywg9WOmZf8qPpolOQ1VSXBld1663CWyHrQAlbpcxNEqti
	 nSO71rmSLd0uCX9aYWHO5McfC1etMh7qSTi6qPsW+zwiz6g8RjVIgELLbvTMYI5E30Irg
	 cLIETMRhoEadAJ8E661TRIwfeNiGp24gqhihx1G+upUbH+0oI3KfAgmIqv8QcylpAcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ctDGepxS1OmdEx/30I1lW8Z2mAdJrkGf3g3gchr45SU=;
	b=1HLWZvVdq1scc3FpcVJhGyvvyatv/mXe4fJRsjgJJbRMmMu/7EnM0YJD/9yC9OQaEJ/Z
	 9dUY3Wfqf5jfisJBtUcIpa2VLBF5ENh+uD3YGHNl5KZCGiJddKuBBm673cQkD5eZr7dE9
	 Vh1WzlHQZ+7zE1ZPGZhA//S84cRoWjAQnWTJqI3Xc4im9LPVHJprUtTAdXBTTlYJlWsFb
	 kUB9wN1zBns+NfNdiMTo39T2wrxRCLvQFotM1KiQCz633uEpQloEks8RCbf/FGGiYUF26
	 lKzw1bqgCVIVV1ksL18jTpyaVqetDQlhxIJAUkuPEU4nCN6NYnJ4uB+w4YLj2q/3SRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCa4J62G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3341B606A31E;
	Wed, 25 Nov 2026 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCa4J62G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A39A1F000C4;
	Wed, 25 Nov 2026 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623991;
	bh=ctDGepxS1OmdEx/30I1lW8Z2mAdJrkGf3g3gchr45SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCa4J62GGiqzfdPEG8ECotPbqpPs4iEM1s1icve//fZJf5+lYMQwIeKceUoRRrcDu
	 4AWZ0FTPbZXSg8o0U55yEt0yrPxSco43VNLrxLOAKgOFB7S++ouaCeZEtgvxVziH9w
	 TPxXAUbAccPJVKwy0O1RtCNvNRptcnk6qAJc/PWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/816] net/9p: Replace strlen() strcpy() pair with strscpy()
Date: Wed, 25 Nov 2026 15:26:39 +0100
Message-ID: <20261125143850.401799695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit cc8b15a2c435bd1caf19741ba85286846a115764 ]

Use the result of strscpy() for the overflow check.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Message-ID: <20260606202744.5113-3-david.laight.linux@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8a03e62992508..f31b2a81ef8bd 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -941,14 +941,12 @@ p9_fd_create_unix(struct p9_client *client, struct fs_context *fc)
 	if (!addr || !strlen(addr))
 		return -EINVAL;
 
-	if (strlen(addr) >= UNIX_PATH_MAX) {
+	sun_server.sun_family = PF_UNIX;
+	if (strscpy(sun_server.sun_path, addr) < 0) {
 		pr_err("%s (%d): address too long: %s\n",
 		       __func__, task_pid_nr(current), addr);
 		return -ENAMETOOLONG;
 	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
 	err = __sock_create(current->nsproxy->net_ns, PF_UNIX,
 			    SOCK_STREAM, 0, &csocket, 1);
 	if (err < 0) {
-- 
2.53.0



