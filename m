Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828970;
	b=nhXOoLKWE8Icgbwpo4nEbsWM4miytnzzJSBd/LjcbHA5mbYP1LA8jioELsDaJg8shhw8
	 tAovEXby1MmCKlolmvXq7pSAb3kmODdm5MjnEbLgh4L3kA9hAqnAT5Q312LsB+3d/MZ3P
	 FHhm2JG2IXhG/MwKBS0sK9z+s8XmZyAGNjSdQmMDhqcg596buwl8BiKjfi586mWUL0lVs
	 Md6f63O0OB+i3a7RyX3X0rpVIi0wCrfVXJjaGGFzH/SIwO/6ETdPDQX1Y6UlJn11SOMTW
	 hJlSJR9lcEV3LJqOUDQdFkjxf0CA/lszjxkUtvllHNcx7/g+K8elUCuPrELuuMbdVeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+pH96F7RjU+w9Zs4lgKuwaiXJRqpWvKINl3M7QklEvk=;
	b=3JDAHH6hG9fI+CasS9zNWxr9Y4YcNZ2+9MPj+AKGKS90BQVz/f1ZbnxnA22HxCfdXmjI
	 2RfQimboywUnFdeb/Q5gOeAEl4mnGpb0Zv1/Iajpq2qDe1ALGecwT3/jEgP6cxoW0Q1RG
	 CFOR5bHURvdbiauRWBXYcliNwGaJt+vdNRu43sbxiD22hbkOjQ9I6S8UfmfIszu9SnwOn
	 JPWJRku1mjj1KMHDXd18PxkBGfKj/hoktB98nM1Ajh3hcZmBA7rHHaTBOZ85AkUgenHs6
	 wU4xvSu/AAQzuG2TwX43fO4AEqMYBUs4YNcFHi0cwpCSPuBPhrYSg0q1MWP+HsO7RyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWJaae5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5767D607E926;
	Wed,  4 Nov 2026 21:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWJaae5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EB91F00A02;
	Wed,  4 Nov 2026 21:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828970;
	bh=+pH96F7RjU+w9Zs4lgKuwaiXJRqpWvKINl3M7QklEvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWJaae5FGpgweT4cKFVV3OgDRvESb+pn91vHm+XJo6ZMQ8XQUPH8Ooka13hGxTWGk
	 YrIviSzsWcnn1vIfDPWQ5jjkZpUC5JFcVikyZUGRGQgqvKW77eqgYTirxlU72p3PUr
	 tiNkf1eNG7IuW1fgLH0vJ7GTdBV4IPpGKpXczpGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 361/547] xfs: dont set a metadata directorys parent to sb_rootino
Date: Wed,  4 Nov 2026 16:09:05 -0500
Message-ID: <20261104211048.547306772@linuxfoundation.org>
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

commit c9f98b0f4f70c8cfd617dc2886bf2fc0a36ab9da upstream.

LOLLM complains that it's weird to set a metadata directory's parent
inumber to the regular directory tree root.  Fix this even if nobody's
ever going to notice this because metadata path lookups don't access
dotdot.

Cc: stable@vger.kernel.org # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1674,7 +1674,10 @@ xrep_dir_swap(
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
 	if (rd->pscan.parent_ino == NULLFSINO) {
 		rd->needs_adoption = true;
-		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+		if (xfs_is_metadir_inode(rd->sc->ip))
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_metadirino;
+		else
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
 	}
 
 	/*


