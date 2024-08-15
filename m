Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26601AD3E2;
	Thu, 15 Aug 2024 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730751; cv=none; b=YzWVmYbdldWjZ41C9q55imRXqYu1JKEut8srRon5EWS95d5oxBS4hD0LhHFzwaUOvD4F8RTPCYXAky+LaRdK0RefLRorp6sAwpdihV/xLOfvc30TA3fWcZ4ppxE0fK+IlWZSQjAAvuMVOezYqxbF+XT1a7FVgeqnA/OfzzLgBxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730751; c=relaxed/simple;
	bh=YV8gII9gmbdFEZWAnPkBOtsqqilX0da6MHcoDP/2560=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDsyg6WDGcPxmrqNSE9A8/WWyfbmrkA5atqmPUi7nJl1dZPuaAle34AHHU+hzoynpla9V7f2BYRDe/Z/DZ48+7zWP/fk+s93V5D0rfb6StEd2koiTb8g367QRRgf3qcEncgzucRBSmHQlSn9pDqKSgqBMMwzhfQZuki1DO4kIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iURgHP52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iURgHP52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC0C32786;
	Thu, 15 Aug 2024 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730751;
	bh=YV8gII9gmbdFEZWAnPkBOtsqqilX0da6MHcoDP/2560=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iURgHP52fERIe4DNwdo53B8/3WBbaqBFCjTVj6KKL6vT7CI4ZunnBguEsmcOiwewo
	 rWwLS4BH8ahe8nFdXPVbDCQenkHHBnbcMUS302BaKhIqMX6ddl1NVS2+WJfWsNEVVk
	 hiHXJ+3cwRWNZKUL2zogWLDdcrl+IXHzY0eFzMqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 21/38] sunrpc: remove ->pg_stats from svc_program
Date: Thu, 15 Aug 2024 15:25:55 +0200
Message-ID: <20240815131833.767908746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f6ef182f144dcc9a4d942f97b6a8ed969f13c95 ]

Now that this isn't used anywhere, remove it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v6.1.y ]
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
@@ -422,7 +422,6 @@ struct svc_program {
 	const struct svc_version **pg_vers;	/* version array */
 	char *			pg_name;	/* service name */
 	char *			pg_class;	/* class name: services sharing authentication */
-	struct svc_stat *	pg_stats;	/* rpc statistics */
 	int			(*pg_authenticate)(struct svc_rqst *);
 	__be32			(*pg_init_request)(struct svc_rqst *,
 						   const struct svc_program *,


