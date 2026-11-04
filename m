Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831680;
	b=tZcnF+pW5L7MDQVUY167xpIGIvkxiawdmXXx8x2mvBmVqMFFxfFZ4J3bUEG2i9+lQt+9
	 kNwbED+Yv8RXgSx0guu78xmU8wFMDycfrPHLT4eur6pQWbHFccsZrjQuLVLcHzE5awaDT
	 x0/oYMmnia3HGGALdnfpM3aRE6Oc8OxTFTKwpkSKYL9EU8WKsYv7mniuqhkbNOgI+NazN
	 oXCAq7fXuzY1O7sv+3pwZyvfhWJKegqU1Ru3kLDJ4JL62laL14h8GqyijwLxLxfLtEnRQ
	 IgOfW+1aGDfGE2RX1YlqyKAxBYTcPr1wgUan829RelPx8zK/fBPiabRyEcCuU52pbkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4lgLzB7ZhEL3Nh0Q0uPW4morR786yOZ0JXHJPhgsFA=;
	b=A4I/8/u9Yk7wLIjbB6se7SuMCLzExj706G3nXa6edSeQ7xUr1YXjfhOq5FAxbuylBFX7
	 L/rpbU5wgfgSYJZLS9U1gc5CbfzHhw9cUFwz38Kkqe8J2n9pfNJf2snfhVCYaJCw/qZuA
	 dQ2z2sHKFCRQhYStHvdjJ81Cf8qQmYFF+rU2a386jsZ1nagXV6GRuXHcChZlzvdlIdm33
	 v0VpcfIV4+V9U/e7ZLARymH1ZC9r53LZIkflUeUGgnZYIH1kXdMjkrObLK1S+6AxCq6d6
	 oVkx3FU85L9hsnudG1hjRLJ6WvuNlGBxZI6C1I1JAlEJKqEF2ZSIjNMtWpUhsVcRoTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYVAiq7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE2606A860;
	Wed,  4 Nov 2026 22:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYVAiq7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6760A1F0093A;
	Wed,  4 Nov 2026 22:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831679;
	bh=E4lgLzB7ZhEL3Nh0Q0uPW4morR786yOZ0JXHJPhgsFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYVAiq7IwFBles66cSa1iFDaBSr/NidkVImw0rVFcLfRE5ND/OofuDQdPzzkga0w5
	 v2Igl+zE3TdIU7eRYiwBpF34QVEnHPuT/bcBw4JK76e+JyJjAV1GDskVCYLupf9GIv
	 H5iq7AwvtbZNj0xlWQXNEcD1tmkdGg9a0x9LgDsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0851/1005] xfs: dont scan across metadata/regular directory trees for dirents
Date: Wed,  4 Nov 2026 16:09:44 -0500
Message-ID: <20261104211107.135599939@linuxfoundation.org>
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

commit 03ce4ca43c00394364493865f417d646e252bac2 upstream.

LOLLM points out that the directory repair code should never scan files
in the regular directory tree when fixing a metadata directory and
vice-versa.  Amend the scan predicate to check this condition.

Cc: stable@vger.kernel.org # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1189,7 +1189,9 @@ xrep_dir_want_scan(
 	struct xrep_dir		*rd,
 	const struct xfs_inode	*ip)
 {
-	return ip != rd->sc->ip && !xrep_is_tempfile(ip);
+	return ip != rd->sc->ip &&
+	       xfs_is_metadir_inode(ip) == xfs_is_metadir_inode(rd->sc->ip) &&
+	       !xrep_is_tempfile(ip);
 }
 
 /*


