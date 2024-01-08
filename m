Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A005577C;
	Mon,  8 Jan 2024 15:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4LBIV1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57ADC433C9;
	Mon,  8 Jan 2024 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728526;
	bh=7F0qPEk9ooC7I+fhAj1uCOcc52s4IsyRbz9jQ8FSoWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4LBIV1v71hUHnMPW7CBrvNzDEG7u/O0cnf/80Wph8tiRSYH3TWkAWpfMjOGoJ+N4
	 iaIqwYa660ffCHjnVSiiXzfm1UZM7vmHdyV6SV/mR8kKN/j+UJWUi/D8vzplNkwmTV
	 wZutTrCLG8PCZAC3vPpgE89IYkJwVqkUhg6PTHjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/150] smb: client: fix missing mode bits for SMB symlinks
Date: Mon,  8 Jan 2024 16:35:56 +0100
Message-ID: <20240108153516.015479269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ef22bb800d967616c7638d204bc1b425beac7f5f ]

When instantiating inodes for SMB symlinks, add the mode bits from
@cifs_sb->ctx->file_mode as we already do for the other special files.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 7be51f9d2fa18..5343898bac8a6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -264,7 +264,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		fattr->cf_dtype = DT_REG;
 		break;
 	case UNIX_SYMLINK:
-		fattr->cf_mode |= S_IFLNK;
+		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	case UNIX_DIR:
-- 
2.43.0



