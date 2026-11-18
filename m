Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053018;
	b=eWnx6W+si3htm4IZEeBGHQOdEMGjoYi+U5bjy4G5aLjBa+5DdiQk45Chcvq2JD24cdix
	 nLRvOdu+1mHiE78Op0IO20Q6/8/EVtAmIaWq7IRswSNW2qCzFDcRv3epl/kB85i4AXQ2i
	 xoVD0tSx4IuWd5u+2E3PwZj7PNZSX8n72ObZXdMMRcHfuU4dk3+aBazX7voDUzenSCyry
	 Xgj1iDJ8AbZ/SXD1XajoIfjHv3D2fAu9aNWrmifvGssIWHkxjxN3l0t6kZpFeL7JxOQzl
	 m6P7K5kEO3jgI3H5JOpiPsl40qC79r0vsM0Xy7IhVXqAKC426t20bq4kbVF/+I/7XsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0T8VbgXOmlz2mzgUzlyCRb9RWz8ZerF/CGV864KSSqk=;
	b=23JenrKjKMRboLkfyu7wrCzb80S92xbqzW5AJZ41uKay59iVHNIpeaLj3j+RcUiD12T3
	 67O2A5TaTn3r0sxkqONFwd1+w0X7CpALLLZKXN2JLH22J83Frw2iD76prkxIwHV6Sqrdr
	 MxRrV9XrMU9C/VBOwmuI6PAzDLva2DvGxI445kAJL1IaPjBbFhsBfzM82SFzGv7KBhvme
	 mkRKdDDgHHioGxurqsSx7d2UNdepTtr4zyGWwqnZUkUVig/aqDv8PH4VeYC7NaonrDl/n
	 NhVWyghh20Tj6tIvMWvMpSzTtLDsVV68y1mNPUcO/hdQhCJgMcn7nNnerrLF2shdgVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaraWMuz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EA4606A337;
	Thu, 19 Nov 2026 01:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaraWMuz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87C21F000C4;
	Thu, 19 Nov 2026 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053018;
	bh=0T8VbgXOmlz2mzgUzlyCRb9RWz8ZerF/CGV864KSSqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaraWMuz/C4LDP9dgqsQiqff2v8GALYifdKi6MjCjXrr04wI3hnVntNWRTm1n6FNl
	 UPeMrwTShp98b3u+dzy/enonBYlHRSlA/N3tWVYlmCBrJmFr1VadIA3g3yOOK+Be6z
	 2r6AGgX2wYUnrzldPJ4pDjSs4m8e/AieYcAiw4Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0769/2214] ovl: do not copy up a dentry that was removed
Date: Wed, 18 Nov 2026 15:40:45 +0100
Message-ID: <20261118150042.444135222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit f635192ad223d2009ee640b63adf5ce3198aa338 ]

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: replaced LOOKUP_EXCL in start_renaming_dentry() with a d_is_positive() check before ovl_do_rename() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 39cb8d225512c..a95496990b81a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -710,7 +710,10 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
-	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (!d_is_positive(upper))
+		err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
 		goto cleanup;
-- 
2.53.0



