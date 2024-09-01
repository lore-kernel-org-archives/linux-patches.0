Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777932C190;
	Sun,  1 Sep 2024 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210209; cv=none; b=tp4PVfvaoDLdr7aiorGPla2u1WEbAAqG7u3TL0an9fhwFmxDOuquJHk2+LMRdlhX7hA/1ThJuxAh6v7OxVwj09qj8N46dmFKQ1/P8+17SO58g9vQnWQvaev3MrqGsk+tccKt0Dbe6QZklh3AZj8MYy41vH3kIXwafJsCwSW3gRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210209; c=relaxed/simple;
	bh=kRZGPo5rblnm46YgncU5y2SewxEF6mne4ePGQHQBJbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6CDcOkue5jod91YA1z5J4UsXsHyWJwl08/ksflRUkU1CbSVSkT5ISKDkVq4XJUWe/VdDDOQIcvp2/mr6O6oNQcxAgoxXj01XNMdmGdY6FQH30wsW/lwtnSnopz/A9T9P+P5R7S2rzy79Xm0SA2x9hsE9vE+qOAVFZF677twGOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYf945eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYf945eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D602AC4CEC3;
	Sun,  1 Sep 2024 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210209;
	bh=kRZGPo5rblnm46YgncU5y2SewxEF6mne4ePGQHQBJbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYf945eu+0XCs13roPCjBBkERwwVFk52vcKdZVzcfxQX9cfZ5U3L/wwX8tFzcL9qw
	 vP8RP21ZACi35/V8akrmT3d8axyy+t/0RTSfaSPFsZI9DfhGnrfXZqzMD0zMCcIVCS
	 1sqplRHbPGoq3my1wai5xhVqwuIcZI2l6X+egQAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 121/215] sunrpc: remove ->pg_stats from svc_program
Date: Sun,  1 Sep 2024 18:17:13 +0200
Message-ID: <20240901160827.929634740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f6ef182f144dcc9a4d942f97b6a8ed969f13c95 ]

Now that this isn't used anywhere, remove it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.15.y ]
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
@@ -409,7 +409,6 @@ struct svc_program {
 	const struct svc_version **pg_vers;	/* version array */
 	char *			pg_name;	/* service name */
 	char *			pg_class;	/* class name: services sharing authentication */
-	struct svc_stat *	pg_stats;	/* rpc statistics */
 	int			(*pg_authenticate)(struct svc_rqst *);
 	__be32			(*pg_init_request)(struct svc_rqst *,
 						   const struct svc_program *,


