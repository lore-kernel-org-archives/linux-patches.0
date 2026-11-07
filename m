Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061675;
	b=nkXrkHA1xj6OuO3izCB/iLgmsM7mHyr4YyYHchTis28OiCO7RxrOSaKxJxswlOP/R12c
	 Mk6F18HgoCnAY82GjiGOgN3Kc5BaARAJhtdgKwXps6dH4ftdyPPCVcuUy6uAWmuuGDoDI
	 nkJStfmH7/a4qnxyPP7rgMcpsh1jep2bgM9eBqoxS3vdI9p6eb7AOegU9vQ8CKHFR3EYM
	 fjKBc/nDY5a5fAQa74DM7jceID3Pu9SGevTcpg3n7YPwnKgYykqjHTn6rQsJFKTtiMxrA
	 hNxovlFu2R4LWscwFm2O0FAmHnD207iHBvVDK8cXwC8IEIS5NkYNtnno1wNt5uYHZHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BCWYxfDblHAUAk1+ePmz7xT4zyiMC4Go88A8Zcb/3gc=;
	b=Xp4q6ge/SOJLMjIOFbrwTtDulOu7XFSlqR8uVmWV3i2hqgR2bidxeHv9ZHf08IEJgaFD
	 Phlwtrh9nOhJJLGbRr9CDWkoP+u+eTA+YnxGJMqbZQIcbsKcTdt0FVPmxRGq2Ny7oSoK5
	 YuWsK1HUJ9jV9/5UO1KS3fNHtPhH1WMPQqr35S6bVk4Dbh8dAmlkubl1nIS3xWO3M5ZG9
	 m6vrhDs2jCd+Tuo3Pw8+yF0d+if5WeFYDkyVR6aTUjcjqxPJFs7SPs+bZ7fYpYv9Diwdg
	 IZqQaHraFoGwzmjllJtYG7NL2E8EoP/nxZhASbi9ZOwQ1IuiGhcJeywUJLS3Kx61+Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGawhpFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5AB606A326;
	Sat,  7 Nov 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGawhpFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1504C1F0089F;
	Sat,  7 Nov 2026 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061675;
	bh=BCWYxfDblHAUAk1+ePmz7xT4zyiMC4Go88A8Zcb/3gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGawhpFSXJPf4wWnSYOUpckGJTQRNWrFH7cIOPbiSDghhSm+SXWa1Z7R0kSEKOUmm
	 cRfQeI001+vi/qsPsp/nokEc/80MQDi53PdLFqHgU6a5vWX6soARG+OPZXFP9iloyB
	 FwZ8/bNGcUVh6zBUW/SdAf5bK8VqBy/EKs1A46yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0729/1536] xfs: always zero the whole shortform header when zeroing attr fork
Date: Sat,  7 Nov 2026 08:45:45 -0500
Message-ID: <20261107135017.979279443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 52aa50cea408e27454d206cccecbe4f694a6c1e1 upstream.

LOLLM noticed that xrep_xattr_fork_remove can decide to reset the attr
fork contents to an empty shortform header, but then fails to zero the
padding byte in the header.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -970,7 +970,7 @@ xrep_xattr_fork_remove(
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 		hdr = xfs_idata_realloc(ip, (int)sizeof(*hdr) - ifp->if_bytes,
 				XFS_ATTR_FORK);
-		hdr->count = 0;
+		memset(hdr, 0, sizeof(*hdr));
 		hdr->totsize = cpu_to_be16(sizeof(*hdr));
 		xfs_trans_log_inode(sc->tp, ip,
 				XFS_ILOG_CORE | XFS_ILOG_ADATA);


