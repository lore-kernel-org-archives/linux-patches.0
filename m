Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F068519F49A;
	Thu, 15 Aug 2024 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730843; cv=none; b=cQxvlCEPOR8y3YSOwNBC1a9+8XAUh5ZJNbg0DZetFgu+JtN+oUo/wdMTaVyxPDfJEm5tncVi6Jif6eRP67C+z6SU0cWenWU9jmcpAqIuouwYKEvbFfZpb/sf41uFVSQ+oFOsG+0HvC7+IugZf7ZceCA03dmEx70GCC9dDOaoouY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730843; c=relaxed/simple;
	bh=kHhjm6Btrii3Nto3tPQBqWfPAzu1tSqqkxCQd/Z30Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEfh/2mi+fT4QtF4qig+jdJNXIYRFoGJ5ta38DCu7Ag9+2pQvAK1emEvMRxspcsFrmzmJeBKIcvTtGsfea+h2uKKSiTU99tr+sb4krzvpVQMqifMwJ7+RHSnGKhhrU02f2MNN6fcVQX3WC0C/o/80WQ/iC0gTfbXNxnei38hveQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkfKIlu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkfKIlu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CA9C4AF0C;
	Thu, 15 Aug 2024 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730841;
	bh=kHhjm6Btrii3Nto3tPQBqWfPAzu1tSqqkxCQd/Z30Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkfKIlu6ttdAs+Rdwh1ehWUCK6P5dAN+tqporc/w6lbiTjZiaC7ytxkf7/YLquuIr
	 /Fjfyynmsx7TF7qHwarsHGjFm9inAUd0jY6cKacuo2BBN3ht+abWPBcQIYDXPijMiO
	 ZV595ruGBTM1VO7vUPlGRapQs9SlK/oaNEqutWZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 10/67] sunrpc: remove ->pg_stats from svc_program
Date: Thu, 15 Aug 2024 15:25:24 +0200
Message-ID: <20240815131838.720311001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f6ef182f144dcc9a4d942f97b6a8ed969f13c95 ]

Now that this isn't used anywhere, remove it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
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
@@ -336,7 +336,6 @@ struct svc_program {
 	const struct svc_version **pg_vers;	/* version array */
 	char *			pg_name;	/* service name */
 	char *			pg_class;	/* class name: services sharing authentication */
-	struct svc_stat *	pg_stats;	/* rpc statistics */
 	enum svc_auth_status	(*pg_authenticate)(struct svc_rqst *rqstp);
 	__be32			(*pg_init_request)(struct svc_rqst *,
 						   const struct svc_program *,


