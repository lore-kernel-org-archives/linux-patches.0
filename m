Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4374D423E85;
	Tue, 21 Jul 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661342; cv=none; b=TwvgoMLNEA1CreBJ/Byl/6EsDcF7Jk+aWszZPzFop3FfYnM0BLXBdQTeZr3xPRzzX0WgftTp60lwonBJTy0OBRk+I8E/3kVfTFoK2HdhLYemD6AYTw6W3lUCyszwHbEnRDM03PPa6DSTcm5v0nEHfov43+Sfag90o6b4C5gpyow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661342; c=relaxed/simple;
	bh=7zLAgS/C8b+i611s1iDky3HLgchS3qapJAY2vpjYe3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYLY2jMvUHdLh9nQP3n3hz94GD7PnfvvjB2qhD/LUQLl6EcH2QiMURFzoOCYB/zqu59FPd0dnq1gz35NHsjbpSDM1XByihm5/DTuPSvcmHKEOQicauw/Nbad8ivfyjNznT9tQiBYGG0/AlnKysWey2EaPS8cMzDT5tAf0u4sUn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5KSrf9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5KSrf9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D0E1F00A3A;
	Tue, 21 Jul 2026 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661340;
	bh=EtB4sfNJ6riGcbh3hREqut5yF9XXPXWKI/bqUbrQXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5KSrf9A5OW8au/xw4CpEjQj46HL4IL0SbTFsSik+fIipnAD0IGjccaNS1LuJiXgV
	 fsnWrSn0fWpyjNcJ3ucbjAqO1k6lxyOeBvI7bOi+kUZkowARrhdOLDvVxH4SyO8BmS
	 8Oa7kd9zxwOoL8LklcanYRmknyrlDC1aLex0pV+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>,
	David Rheinsberg <david@readahead.eu>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0030/1276] af_unix/scm: fix whitespace errors
Date: Tue, 21 Jul 2026 17:07:53 +0200
Message-ID: <20260721152446.756731745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

[ Upstream commit 2b9996417e4ec231c91818f9ea8107ae62ef75ad ]

Fix whitespace/formatting errors.

Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Luca Boccassi <bluca@debian.org>
Cc: David Rheinsberg <david@readahead.eu>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Link: https://lore.kernel.org/20250703222314.309967-5-aleksandr.mikhalitsyn@canonical.com
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/scm.h  | 4 ++--
 net/unix/af_unix.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 0d35c7c77a74c3..ea85f7427a1930 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -69,7 +69,7 @@ static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_co
 static __inline__ void scm_set_cred(struct scm_cookie *scm,
 				    struct pid *pid, kuid_t uid, kgid_t gid)
 {
-	scm->pid  = get_pid(pid);
+	scm->pid = get_pid(pid);
 	scm->creds.pid = pid_vnr(pid);
 	scm->creds.uid = uid;
 	scm->creds.gid = gid;
@@ -78,7 +78,7 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
 {
 	put_pid(scm->pid);
-	scm->pid  = NULL;
+	scm->pid = NULL;
 }
 
 static __inline__ void scm_destroy(struct scm_cookie *scm)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1d426f5b2580d5..c64d8ee0ede435 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1887,7 +1887,7 @@ static void unix_destruct_scm(struct sk_buff *skb)
 	struct scm_cookie scm;
 
 	memset(&scm, 0, sizeof(scm));
-	scm.pid  = UNIXCB(skb).pid;
+	scm.pid = UNIXCB(skb).pid;
 	if (UNIXCB(skb).fp)
 		unix_detach_fds(&scm, skb);
 
-- 
2.53.0



