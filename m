Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A929101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23767C433C8;
	Mon,  3 Jul 2023 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410544;
	bh=Ajc+moLDKNdf2kzloY0yzxsLANfco5LPlLxMDEW56BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7D/wMjKpYWQrRg+s/rfaMvwcLn/sawyK/4nUvSslSL4cQzy0NRBWbvNZWxGba+6o
	 1F1twjXwv6iNGDwjn0xfk51nE8MZA9su2LqMcNDT+iRZxRML+ENy+MEjRmUMwAJ6KT
	 FW8g2qgqJADF49BkIzWdHWiwvOPnv//ZYKHOTsQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Boyang Xue <bxue@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.4 06/13] nfs: dont report STATX_BTIME in ->getattr
Date: Mon,  3 Jul 2023 20:54:07 +0200
Message-ID: <20230703184519.456211223@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.261119397@linuxfoundation.org>
References: <20230703184519.261119397@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

commit cded49ba366220ae7009d71c5804baa01acfb860 upstream.

NFS doesn't properly support reporting the btime in getattr (yet), but
61a968b4f05e mistakenly added it to the request_mask. This causes statx
for STATX_BTIME to report a zeroed out btime instead of properly
clearing the flag.

Cc: stable@vger.kernel.org # v6.3+
Fixes: 61a968b4f05e ("nfs: report the inode version in getattr if requested")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2214134
Reported-by: Boyang Xue <bxue@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -845,7 +845,7 @@ int nfs_getattr(struct mnt_idmap *idmap,
 
 	request_mask &= STATX_TYPE | STATX_MODE | STATX_NLINK | STATX_UID |
 			STATX_GID | STATX_ATIME | STATX_MTIME | STATX_CTIME |
-			STATX_INO | STATX_SIZE | STATX_BLOCKS | STATX_BTIME |
+			STATX_INO | STATX_SIZE | STATX_BLOCKS |
 			STATX_CHANGE_COOKIE;
 
 	if ((query_flags & AT_STATX_DONT_SYNC) && !force_sync) {


