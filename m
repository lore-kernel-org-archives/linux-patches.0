Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831579;
	b=RnjJYPXCEL5nLWo1z480quhcZOLS1EASebeT5quas61w6pmnA518eWUVDFHTAWqgzixm
	 o5lfhiXWCJQabn4Y4nOi2E+ijtTzJ6iiHJjvkYXTCPOu5d5pPplETQN5amtnk9g17eZnq
	 h639Ovwp7IfXd5CIMdsJ7LxiNHeu2sXrjsytpnKcYl3ghp6E+1hin53L19f5MtELLhNLF
	 AA3+KFjyYSWMQE5vsabQhsy1iX1hvOaPrKRClgB1o/s8QXvdSxiCblxpEoriJvDfwB8lj
	 bV9MJvPXvnluL5jcSziCFCpR7GS5uo/kjPsq+W5F0C/z/2E+lZChOpAKm8IfNhtRUrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEpe3qPRiI/xOd0KCCE89fCaL5+db3B/hIolvKGSEQ0=;
	b=S3G7jAY13PJj6BBHA+eFnhjyGlHnG1bB2EkCgj9Ww9yhYSfutodCBxzDs1arbuZO3mvY
	 CSK/rImvaurNPrAB4aGGIrkAWVqs91a2jTgGvKJ7w3tBGhGRTBUScaSExjuCru7NFWYDm
	 Fx2Z04jO7UAKXCtQitdGIYFhQp6+mI8yj2hnm2lduHTwRSfDOAz0luW3BHCy2w/jfYJvj
	 PnnIiimQMzMYqYIFnCPQWUPpqpipgdbtuu8GP7WDQLZMzvvwU3xrrDUtq/jh9BzXKjjn0
	 QfOJFqYjUWjRfBMYK19tcOxqosEBhtROlB8xDMlU1li/RntLC/Ps+gvoiL1WMFmIclg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YafJNib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171CD606A855;
	Wed,  4 Nov 2026 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YafJNib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27841F000C1;
	Wed,  4 Nov 2026 22:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831578;
	bh=qEpe3qPRiI/xOd0KCCE89fCaL5+db3B/hIolvKGSEQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YafJNibL3ghnYO6rZUaMqod+8kcsoWcoAxhFH06748zuhltOOBmHpaiWbTHwTi9t
	 L5UcVj9eVgT0g0Qxt9E8Qmgv1jCXESqCxe1IYMMUzyKO3r59b4M6zZPS++hrY7Kl8+
	 OUkQtflWtnoFiWDfPkSunYEruTqLcv+12aw3uVmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0787/1005] xfs: always reset incore attr fork buffer when resetting fork
Date: Wed,  4 Nov 2026 16:08:40 -0500
Message-ID: <20261104211105.389357751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 71cb13685e72a3c5d118732559c727a0c9090b7f upstream.

LOLLM noticed that the local format attr fork verifier depends on
if_bytes being set correctly.  However, the fork reset function doesn't
reset that correctly, which can cause post-repair verifier failures.
Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -840,11 +840,11 @@ xrep_xattr_full_reset(
 
 		ASSERT(ifp->if_bytes == 0);
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-		xfs_idata_realloc(sc->tempip, sizeof(*hdr), XFS_ATTR_FORK);
 	}
 
 	/* Reinitialize the attr fork to an empty shortform structure. */
-	hdr = ifp->if_data;
+	hdr = xfs_idata_realloc(sc->tempip,
+			(int64_t)sizeof(*hdr) - ifp->if_bytes, XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE | XFS_ILOG_ADATA);


