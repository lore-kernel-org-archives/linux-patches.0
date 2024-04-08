Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CAF768F0;
	Mon,  8 Apr 2024 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583119; cv=none; b=VK8jkhxE5vWcBLsNJPFJD3TbsU1Rm6hB+okTNtGKvkaZPmmR2NP7HCcqDOfUotihrBN55VJNtYSTEyBZrwA/pliVzJLiXRB202bHXSy49iAD8CAb6bm0nU+0IU7rTu1yCaz0Rk5SCpysH8q+GJbeg2RkTMTphRG5Dpy5ywMF0zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583119; c=relaxed/simple;
	bh=3EpC5rm18XBpMuo48yMCmHL0vdDm8jqrOgCByY1VKlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4ZwbAeCLtpyK6ebSb0FG+oaLsjlH1C7FJoEjcFqR0TODuG3BtIRldUzZAJkWPqTRdS6QtwaJ9+k2+wTGnUEddRh6fCbe6j6HIbtTx6TfoZQbE1kSjZ5E8QpZbmAA8F9z4yv61x6XVgeuF8feMSC5nkALjfSBFmr6svm5OD4k14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqHCRSer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqHCRSer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F6EC43394;
	Mon,  8 Apr 2024 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583118;
	bh=3EpC5rm18XBpMuo48yMCmHL0vdDm8jqrOgCByY1VKlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqHCRSerGHuIQvsWKw+88zCcHqGwOU1LcO+XVvj/hv+hgD74NKsqGWFBPEQhs4qSG
	 oRzmnLR5BZmgT3rzJR00jlnqNsrZqK5pF4i8iGm6Hat6ozM2wsui6xNjeGc358KkSC
	 VvscWIPKr/ol2+Tm3jJE8AgjNFSiU3OdomnxQfOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Frank S. Filz" <ffilzlnx@mindspring.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 209/690] nfsd: update create verifier comment
Date: Mon,  8 Apr 2024 14:51:15 +0200
Message-ID: <20240408125407.103470021@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 2336d696862186fd4a6ddd1ea0cb243b3e32847c ]

I don't know if that Solaris behavior matters any more or if it's still
possible to look up that bug ID any more.  The XFS behavior's definitely
still relevant, though; any but the most recent XFS filesystems will
lose the top bits.

Reported-by: Frank S. Filz <ffilzlnx@mindspring.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 24a5b5cfcfb03..59e30cff920ca 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1436,7 +1436,8 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nfsd_create_is_exclusive(createmode)) {
 		/* solaris7 gets confused (bugid 4218508) if these have
-		 * the high bit set, so just clear the high bits. If this is
+		 * the high bit set, as do xfs filesystems without the
+		 * "bigtime" feature.  So just clear the high bits. If this is
 		 * ever changed to use different attrs for storing the
 		 * verifier, then do_open_lookup() will also need to be fixed
 		 * accordingly.
-- 
2.43.0



