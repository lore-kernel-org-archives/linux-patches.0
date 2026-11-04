Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831753;
	b=cWN4NeyhVVE+SmCjPMy2bvB4GAK3BmTrrJR2aTMwO3qPjswTQdUOoUg9wUBSVJj6Ei10
	 b1zsQ3xARkUJLo8Q951fNSYKa5GUdrOVIy4u92MoflGwK8WfdZeVCtWMLOlKOkTrFhmh7
	 CZBpcxdrc/LVtWZrPtFEoGp1lseF+iaPaYYMTVjkHWn9Il4+I3KfNnRA1fqxUB7DkFdjh
	 xXd/NCUK1Dq9KGgs6OSrejyE6HVGqlxjUAPUfL54gdE5ut3FNlMIlJtc74OOFaIOZrnHP
	 FcqV2O5sGVT/mNOUC546LvQogaFZRkKJbYbiL39vHod0y/5raZoaztsEZ1SbyqPGHyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HesraxZZ2nOSfTKka5sE2bqE/NFuJGA5t4Y489oWpnA=;
	b=l/F8W+QUybLhEoEDYBycQwAg1oTBbvNnvEC1LfaMBhtbVraAVFmeDXuasqd9e3RJfzu8
	 eSK2qEXrFResjVNGOJ8x5ng4b4+nQtTCmp3J5nWhn66UplYQDciks7iG5VpPYhw2KddF6
	 YN6yXHSvdM4Yh2QQ1M1kr6PxJKjoUXSYmlKt/grJAPt+fyIanLtKuDbSS3FxLZ2UFCmA9
	 ug0zZ1sLm76REAQH41hxOBBnp3+NKzERdf3I/fvp718Q1NfV7i3FsqI6oC7/jqp20ikC1
	 C4C9jKDQg6ZQrs/MmR4Bmmr5ELbFdzWtDmOsDOY5+9VeLyZIQuM6PPJHnII+VKAxHgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPI7jf+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59520606AB3B;
	Wed,  4 Nov 2026 22:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPI7jf+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4C21F00A02;
	Wed,  4 Nov 2026 22:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831753;
	bh=HesraxZZ2nOSfTKka5sE2bqE/NFuJGA5t4Y489oWpnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPI7jf+Uz3+3OBS3mlVxy4A3OSXg21TWxhHoK7hL1rT+PZHaDvmMB9bcTX1SK1rtq
	 EFfnsikT/2IpVDwDhM0N+tXPCDwS9NeugF+gsTID1eq8pjzUubztLpPIO8Wtsd42mb
	 amWC9BERoNzqC70HVhBDp1LY/QiX75YN76PzV2e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0847/1005] xfs: dont clear COWEXTSIZE on directories on reflink filesystems
Date: Wed,  4 Nov 2026 16:09:40 -0500
Message-ID: <20261104211107.036890684@linuxfoundation.org>
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

commit 3978b1f3109dfd5c648442bb040f9abd58608226 upstream.

LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
unnecessarily on directories on reflink filesystems.  Directories just
pass the hint along to new children, so it's valid to leave the flag
set.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -563,6 +563,8 @@ xrep_dinode_flags(
 	 */
 	if (xfs_has_reflink(mp) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
+	else if (xfs_has_reflink(mp) && S_ISDIR(mode))
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
 	if (!xfs_has_bigtime(mp))


