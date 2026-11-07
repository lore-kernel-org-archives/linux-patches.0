Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061391;
	b=jhAzCOa31Kxaob1gG+SdMJXlyuNtBtnle9gVX3MZ8mgbzDyudS02UJthgrBivWzGAB9/
	 6HQHUg00g0Emq2GkrsjCDo6P7xUg7Q6dhB7BUdUx+LiVGMH/SKGOiXXC3FXDqKg1HI+rx
	 WDZ5goUEdE3uNS2shoDvdxk0xUubE9xrM8zLNgPmLoofgjbrvQ6wQ7o/2czWLcO32w0wU
	 GzA0ta/Vll2cf5KpD0V2k8+e2tzkf0dHa/Rb4oSVJVApC7luq76RptFYUerwm8lBAIkIa
	 2dzHkasZA0wiwphahkhPf6X+azGmkxB4qyfM0Fbtu5i/vYkxPMFxrpqFsWVZGPPd1+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5JK7/JlR6X8rlBtZk5CmEtKF2Byf5JwgRKACSKN9KM8=;
	b=ebnHG/fUQnGyV67VKklvBuAUSGkRYqAkAT6Xgbbc6d3+rq7EtY/WKNhYZh6dztmGXnFB
	 qtEJv/skGfcnGMk34Hvi4e9UgoWh3N3eT+wBa+SA6m6LxGOwlOhIs3Z7KyjCnPJyKI8hK
	 91sJ5eyg7PzNIJF37Fdb1CAjR2R+ZMlLl9xCfeF+qacbDEo6NcyudLg5Uj7XeqbL2fsgD
	 QpIWjW225zDnCfrwLn3LRK5O3uils4kXhcGBzmI2SHJS0BH9HYbTVFZr6UnYGJwnh9oA4
	 a5AIFkabmuuRFX6mpv4QZUJcvYjt0lxm7ZEY5n0GK/Yxw/QTLKWo+jUtvqEp3PjbsTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUt6OkIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59235606A333;
	Sat,  7 Nov 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUt6OkIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5921F0089F;
	Sat,  7 Nov 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061391;
	bh=5JK7/JlR6X8rlBtZk5CmEtKF2Byf5JwgRKACSKN9KM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUt6OkIbtMRro17EXCKGGQNRNdfbMEjcdWU9XOjwh1TtpHaLUaHzD49YsBucrPD9P
	 NsLfzdiPj3Bzewiktr7MO/YpHESpH8mYPcWz0Z2ZDiVbFwotCB1NjTGdi9YBQpX0yk
	 Ak1dnfjJCHrPPAleo3oustmCKsrfZZEn+AX1KJw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0512/1536] smb: client: fix file type corruption in posix_reparse_to_fattr()
Date: Sat,  7 Nov 2026 08:42:08 -0500
Message-ID: <20261107135011.817124043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 65d5dbdc089be42fc48a6f77bc6b648307f34b17 ]

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Use a local ftype variable to collect the new file type and apply it
after validation succeeds, clearing S_IFMT and setting the new type in
a single assignment.  This avoids stripping cf_mode on malformed
reparse points where the function returns false early.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 53ed9bae23a86..ceddb4ec10ba1 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -754,6 +754,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_open_info_data *data)
 {
 	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
+	umode_t ftype;
 
 	if (buf == NULL)
 		return true;
@@ -769,7 +770,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFCHR;
+		ftype = S_IFCHR;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
@@ -777,22 +778,23 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFBLK;
+		ftype = S_IFBLK;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		ftype = S_IFIFO;
 		break;
 	case NFS_SPECFILE_SOCK:
-		fattr->cf_mode |= S_IFSOCK;
+		ftype = S_IFSOCK;
 		break;
 	case NFS_SPECFILE_LNK:
-		fattr->cf_mode |= S_IFLNK;
+		ftype = S_IFLNK;
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
 	}
+	fattr->cf_mode = (fattr->cf_mode & ~S_IFMT) | ftype;
 	return true;
 }
 
-- 
2.53.0



