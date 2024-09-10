Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0270819005D;
	Tue, 10 Sep 2024 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964984; cv=none; b=hRAT31Qp7UztUCaEH8cmqJhnJUG+wCtxibKdo1M9HigDi3bsJ021gCNt9yurCIc0rnQpI/6HI+RYGP1BJAQB70WmMT+JC/LU5L3EtIwJQ+kL5b2fedhsOiI5Um0LKtys61CyemLWt2koO9W6gAvZf0/kESrJ/a4Idfn5Som0pn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964984; c=relaxed/simple;
	bh=BrZ7peaJmggHbeFVM22cvuM4SETB+dwu9/PGTBp5yF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg0dCrpRWSHnL3ygOudxNy/95ixfGZIT7XF0a3gdDt+T4QRewDcTz4zBSoyRIu7glSVHa/EmwWM9PyQl2QXxLmOHP8cyKK9GwcjTkJRWcq6oTdFCp6rFZfJuYJPTal4yCmTyoxOzmmsB5w+ZCWXRTJz4kar5vZK0Ax9yTXUMDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVXiCjdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVXiCjdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759BCC4CEC3;
	Tue, 10 Sep 2024 10:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964983;
	bh=BrZ7peaJmggHbeFVM22cvuM4SETB+dwu9/PGTBp5yF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVXiCjdX+Mbhjsk8pOJzpExxD5xcaCUyrvqI3AceQ8heeJQxsZX6pd584EyA9aw5R
	 0+yAkUk9cMQmjl1XyUD60c+WyFd7m3Ej+tZBJV6j2YR2gDSMCGKIeqXPbUWcyroWvi
	 USg7PFvG4qmRGc0UQMTps1UAc7zqXuNTk+BbcYgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 090/186] sunrpc: remove ->pg_stats from svc_program
Date: Tue, 10 Sep 2024 11:33:05 +0200
Message-ID: <20240910092558.210357992@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f6ef182f144dcc9a4d942f97b6a8ed969f13c95 ]

Now that this isn't used anywhere, remove it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c           |    1 -
 include/linux/sunrpc/svc.h |    1 -
 2 files changed, 2 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -136,7 +136,6 @@ struct svc_program		nfsd_program = {
 	.pg_vers		= nfsd_version,		/* version table */
 	.pg_name		= "nfsd",		/* program name */
 	.pg_class		= "nfsd",		/* authentication class */
-	.pg_stats		= &nfsd_svcstats,	/* version table */
 	.pg_authenticate	= &svc_set_client,	/* export authentication */
 	.pg_init_request	= nfsd_init_request,
 	.pg_rpcbind_set		= nfsd_rpcbind_set,
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -410,7 +410,6 @@ struct svc_program {
 	const struct svc_version **pg_vers;	/* version array */
 	char *			pg_name;	/* service name */
 	char *			pg_class;	/* class name: services sharing authentication */
-	struct svc_stat *	pg_stats;	/* rpc statistics */
 	int			(*pg_authenticate)(struct svc_rqst *);
 	__be32			(*pg_init_request)(struct svc_rqst *,
 						   const struct svc_program *,


