Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305C30BBAE;
	Mon, 13 Oct 2025 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369606; cv=none; b=d970MZEs5WVfz6cALNEjRluYlPtT+kWb8/VmYgIOwrE9bkPyTUvODlkF45SQoqhfDKiFDBjEiQaH0wg8wzhBRCzP82LTInoo0imX+QJVXOVf2vds+xulVJwjk6rbrPX6FRt/xG+dzpToq1Ts1Gc8arH9cLa3Jkac+YtFA+LQSBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369606; c=relaxed/simple;
	bh=AvdWLoYiwwDW8A3HHAGQ6AtA2KrfmJW4uL8TdRTkUxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj6l2iespKOtt9pKlrn/Jx25DI+y8gl1tQmYEQ7YrACyKgkS0AgHdyF3K/rbCbsrTcxLDmIApKTRYa8cEMEoHTyBpqKVOlLAhSiVNhcaH6HHNd5tmMNWqU+YmSNdI96c6ZmXfaxQqxYSbhBne7jDd2TM98HPSwgBOd2rcYFJ98w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+xQnaHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+xQnaHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C824C4CEE7;
	Mon, 13 Oct 2025 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369605;
	bh=AvdWLoYiwwDW8A3HHAGQ6AtA2KrfmJW4uL8TdRTkUxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+xQnaHG7q1fzMmE5xs38Pc3boVPpjMfxcsvpLNStsKBqAcD7AVLBmPxx32lNTtxM
	 uJmz+hKX+9kYXvvMWSMFYuvTUF/RY6/YGL2awIBhQoz/p3fDKDkgTDmw1i5znWA4eP
	 OIJagHZf8bsaEr8N8Cyoe+xAPhsk8z4Hsn6SOfdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 272/563] fuse: remove unneeded offset assignment when filling write pages
Date: Mon, 13 Oct 2025 16:42:13 +0200
Message-ID: <20251013144421.127849651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 6fd26f50857698c6f07a9e6b149247925fadb8fd ]

With the change in aee03ea7ff98 ("fuse: support large folios for
writethrough writes"), this old line for setting ap->descs[0].offset is
now obsolete and unneeded. This should have been removed as part of
aee03ea7ff98.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Fixes: aee03ea7ff98 ("fuse: support large folios for writethrough writes")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4adcf09d4b01a..c7351ca070652 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1175,7 +1175,6 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 	num = min(iov_iter_count(ii), fc->max_write);
 
 	ap->args.in_pages = true;
-	ap->descs[0].offset = offset;
 
 	while (num && ap->num_folios < max_folios) {
 		size_t tmp;
-- 
2.51.0



