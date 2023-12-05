Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224F879F2;
	Tue,  5 Dec 2023 03:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTAmv5H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF0FC433C8;
	Tue,  5 Dec 2023 03:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746448;
	bh=le9XKNg7dXT/kvm3AMM6xABDb7hXRyRZyoRq9YoOyL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTAmv5H+eTb8JMQ08VZINWw9Hta4JyjEgZvQqZYch90JRHonnKFE2IsUlO1a2+4LL
	 OmKcMyJUS3+prbnRYjft78Nr3fYfgEhM9wvZAPrt0ykyNHvoJ5gjpKL/g8ymnFc2TV
	 d9qqijPHAGP4pZqV4u6tM9ND5gV5nObHkAu8umHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 004/134] smb: client: fix missing mode bits for SMB symlinks
Date: Tue,  5 Dec 2023 12:14:36 +0900
Message-ID: <20231205031535.474474291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit ef22bb800d967616c7638d204bc1b425beac7f5f upstream.

When instantiating inodes for SMB symlinks, add the mode bits from
@cifs_sb->ctx->file_mode as we already do for the other special files.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -748,7 +748,7 @@ bool cifs_reparse_point_to_fattr(struct
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
 	case IO_REPARSE_TAG_NFS:
-		fattr->cf_mode = S_IFLNK;
+		fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	default:


