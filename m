Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828954;
	b=kIZlGacYxhlmR34EarIeYSfK9Xxy4ZNHZ/nBGGlilXvz7Xnc6Vu3xIgv0ZbuqSEFt5WS
	 CGl0WMd2eQMAXfoPFWzvmFQG+ukiDTBbn+Btp+cXZsT3ySnWyM6nWcppLokY6rPl+Iuee
	 hwJvLlMkwiHgUdxq3cr6gBnk0L8wHosf5x9hu0k/OS+OR/wdHY0MTtqYSWYXsyOxePy6r
	 DNVQGEGab9M13xEsKLnW49PzI6ykADccxUPAcSnNM70negcjaJBGfw243XPQDx1gO0hmG
	 zORQTxt2bnjKobkQpyuI/BEo2IRfIAyoe2qpcW7sqWUm10OWLfCjVfBMx0IXxzwQYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7i/sJDrh47vbOA4yayNuyS6MhkTUREGvIWCVNlZVMs=;
	b=ournTrH3NuoQtYXdFAvr3cbea4jevQC19OPCU8sVd8i8sW5DP45EMaTmW8HivVJRXXd0
	 +aYjl0Y7VwN1mcpKeiMR6MWFMqcRCfsYhUvbnpajdaO8QankZ1f0P0U6lAsXfH72o/qEB
	 gnUDLgWpqP+Eqf7239YruIP2tnWEsrmkzA10WsnHdUAtYSPE+A+C8zaUCNKw6v2TV8z5o
	 e/sCu1wT0Q1W5KxDllfol6HQfq/5AhTWym4CPYfGZzBunJdmiwRnLFHAhDlO+xXoAM4vF
	 f9+5xjEV/+lzT+5iY+Oh9A7v/eV5c3EBwHsWlyVZFF43nPQTmYj2UpF6CtYjGzTVvvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qZP/3Cgc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1497C607E4AE;
	Wed,  4 Nov 2026 21:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZP/3Cgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A94C1F00919;
	Wed,  4 Nov 2026 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828953;
	bh=Z7i/sJDrh47vbOA4yayNuyS6MhkTUREGvIWCVNlZVMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZP/3Cgcf9lqamJ60CvY83PYgG5ri5ztl8r3M+/lYpH1jNCDyJ/qUFzYlTkd21WLa
	 XeAuqkikSicAL3GjrYqw5LamhVsaslkCj6NxibfUbJbwKGz8yrIq8SNwgkTOLxP9Yd
	 4uf5ijJTunl3fRcWnYR+c2VCR4JF4twrQSrCt7v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 310/547] xfs: actually report corrupt xattrs as XFAIL during cross-referencing
Date: Wed,  4 Nov 2026 16:08:14 -0500
Message-ID: <20261104211047.021426521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit b339cc253019518c61b8b150fb7ea727fdae59f4 upstream.

Some LLM reports that xchk_dir_parent_pointer really ought to report
xattr corruption errors as XFAIL (cross-referencing failed) when a
directory scrub tries to find the parent pointer for a dirent name.
Let's do that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 61b3f0df5c2358 ("xfs: check dirents have parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -155,6 +155,8 @@ xchk_dir_parent_pointer(
 			&sd->pptr_args);
 	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+	else
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error);
 
 	return 0;
 }


