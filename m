Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015401;
	b=NsrFhdw0eAxdy7y20U/BPyiOEjSjaxJS0u/xmmYeTPYdUrSKPtPr7Z6ct1cVnZTzyFk9
	 NH97AVPX3V1yJgT23Xzenf+/187c0pK5gspOy5StgIy3SWwkE47YY7ERvwH/nIbSp9rk+
	 AhbUckAF2FULN3nXPiySsXQUouKNUO1LVkPwSxOwoNLlgn415RcauhG/Af6xN9Dse2uZY
	 FYj0gWCb71s6QpwgWOI0vdpdjLyiLozGmwekfxG4K2wL+xFgt5wBCC8+PrufXrXWcTRrf
	 uAaCZtp8FYDpOl4howMzRCkvdB8qrktXaUeFWerbBDL4e5OlxZqGIRVxa6vHpgPKcwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEQFFCrz3g+gNWkUW4wX5DhWsTLkxEVknSIis5uAfYg=;
	b=y7sQqVpy1yFxMa+tdppcsU2B3mfK6zVcBrnsmTCTtd8J0tfEz8kd95BbYlsnPg8AqMuT
	 hrNzSPikfNBwRqdTQBoScWSRQQ7IGue8LOvOAS4Q9/NYfnU9qJMnMS480pkFYipQf4TDq
	 BBO5o+Ox82bRW/H4Mdx8R5Esz9QPwbmD74ZL+ovp6fq2Kx7Aq2+fgzljKSBt1izoCKNHo
	 X0eXYKiXPwxHc22PoGBhZUDM1r+ugbUtSqhnYrAvg++rmuZ73DOxwIAQ5aLO/f8I6sB/3
	 3Dax30tG6AZLPkO7GJt9g+BD5CGrtfA7dPfi/qZnOoLtfB6Ak2fkfwW8BIaxPGMJJBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2D9NdHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8343606A320;
	Wed, 18 Nov 2026 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2D9NdHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACB31F000C4;
	Wed, 18 Nov 2026 15:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015400;
	bh=PEQFFCrz3g+gNWkUW4wX5DhWsTLkxEVknSIis5uAfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2D9NdHIET1GrAga3cm4hpYNEtC6dxoVgEHHiOghleSO9sPhNv6OPSUwVmVxwZa0J
	 AuW3elGo2oQY+9+G87dJAtyHZ9xr4UShBGnefQ4fOK43NZgSjU5qU3e2rI2UjpxvCD
	 eBfInuFZ8MtOD5OmVwJz7u/3NKl+Im2OAC82XkTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David CARLIER <devnexen@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0158/2651] fuse: dont fill in.h.pid in case args->nocreds is set
Date: Wed, 18 Nov 2026 15:23:18 +0100
Message-ID: <20261118150253.538329913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 1642e6b6a6ae0dcf61280e1c3110eba62582d4d2 ]

Commit 794e811d1443 ("fuse: split out filesystem part of request sending")
alters the pid sent on force && nocreds requests.

Previously these allocated a zeroed request and skipped fuse_force_creds(),
so they went out with in.h.pid == 0.

In fuse_fill_creds(), args->pid is now set before the nocreds early return,
and fuse_args_to_req() copies it unconditionally - so writeback, release,
and DESTROY requests now report the triggering (often kernel-worker) pid
instead of 0.

Move the nocreds check above setting args->pid.  Also remove the
WARN_ON(!args->nocreds) from the !args->force branch, since it's obviously
not going to be triggered.

Reported-by: David CARLIER <devnexen@gmail.com>
Closes: https://lore.kernel.org/all/CA+XhMqye_NBihcadRTU=w4xAfrdY9rsMB3oHF5+bwHukkjHMoQ@mail.gmail.com/
Fixes: 794e811d1443 ("fuse: split out filesystem part of request sending")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/req.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/req.c b/fs/fuse/req.c
index a01ee743d31e9..51cfd64ea1bad 100644
--- a/fs/fuse/req.c
+++ b/fs/fuse/req.c
@@ -10,12 +10,12 @@ static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct
 	kuid_t fsuid = mapped_fsuid(idmap, fc->user_ns);
 	kgid_t fsgid = mapped_fsgid(idmap, fc->user_ns);
 
+	if (args->nocreds)
+		return 0;
+
 	args->pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 
 	if (args->force) {
-		if (args->nocreds)
-			return 0;
-
 		if (no_idmap) {
 			args->uid = from_kuid_munged(fc->user_ns, current_fsuid());
 			args->gid = from_kgid_munged(fc->user_ns, current_fsgid());
@@ -26,7 +26,6 @@ static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct
 		return 0;
 	}
 
-	WARN_ON(args->nocreds);
 	/*
 	 * Keep the old behavior when idmappings support was not
 	 * declared by a FUSE server.
-- 
2.53.0



