Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44FB233703;
	Mon, 10 Mar 2025 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626520; cv=none; b=c5Ga/8rOiWUi/plyxslgovJ9Yp+SJ2STwH/8T+7Y8MeeJL9hU8hX6B+GsUnmBg5dPbf2DsoYE1bkS1S9i9n4Hk4H/b3iLbi6Czgs4mTzcVBMANbVGZv/VJEp1KAY6+ZYg8lxpFVkquiTl4ePw6nQ9KFjgG7qo4csx16/0Gd6Ojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626520; c=relaxed/simple;
	bh=/l5F9d47GNBuZ20+mpZ7R1k86vd13J3UQXYjGfIozxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTJx5eA3NMt4ublp599eAND+2e1YRPtYrM3gmYo+2FrZDNzWsBrwFoZUvGkcWXvT/DYEXP1baifUimrlFR1Zb76V+cNQk5j50vhh2L5tL3230s0MZ3ce1Zs5Zqripx3Z6F7QE68c8NBRYzi0wTlXY6vSYFRZW0gKqrMDbImJ+pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4ONvEHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4ONvEHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E6C4CEE5;
	Mon, 10 Mar 2025 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626520;
	bh=/l5F9d47GNBuZ20+mpZ7R1k86vd13J3UQXYjGfIozxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4ONvEHeMJkxf+xFBE5ao4GWN+Uq7HzMFb67Wno3TCcmisuDft4TztrdC8loWMNZk
	 ly/qq+ERnVGgjvLeDjG8SrMi695sdVlHoU5XW0mFq4Pa9JR2efxIl5aLX21LDePLUy
	 UP8pTnpjuxnQWK+4l+EyQ1bJ+dFsLDOhL7NaSl1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 003/207] cifs: Remove symlink member from cifs_open_info_data union
Date: Mon, 10 Mar 2025 18:03:16 +0100
Message-ID: <20250310170447.887763596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 65c49767dd4fc058673f9259fda1772fd398eaa7 ]

Member 'symlink' is part of the union in struct cifs_open_info_data. Its
value is assigned on few places, but is always read through another union
member 'reparse_point'. So to make code more readable, always use only
'reparse_point' member and drop whole union structure. No function change.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 9df23801c83d ("smb311: failure to open files of length 1040 when mounting with SMB3.1.1 POSIX extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 5 +----
 fs/smb/client/inode.c    | 2 +-
 fs/smb/client/smb1ops.c  | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1e6085f2f78ee..3877b861529ea 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -215,10 +215,7 @@ struct cifs_cred {
 
 struct cifs_open_info_data {
 	bool adjust_tz;
-	union {
-		bool reparse_point;
-		bool symlink;
-	};
+	bool reparse_point;
 	struct {
 		/* ioctl response buffer */
 		struct {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0d149b315a832..4d8effe78be57 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -990,7 +990,7 @@ cifs_get_file_info(struct file *filp)
 		/* TODO: add support to query reparse tag */
 		data.adjust_tz = false;
 		if (data.symlink_target) {
-			data.symlink = true;
+			data.reparse_point = true;
 			data.reparse.tag = IO_REPARSE_TAG_SYMLINK;
 		}
 		path = build_path_from_dentry(dentry, page);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index c70f4961c4eb7..bd791aa54681f 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -551,7 +551,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	int rc;
 	FILE_ALL_INFO fi = {};
 
-	data->symlink = false;
+	data->reparse_point = false;
 	data->adjust_tz = false;
 
 	/* could do find first instead but this returns more info */
@@ -592,7 +592,7 @@ static int cifs_query_path_info(const unsigned int xid,
 		/* Need to check if this is a symbolic link or not */
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
 		if (tmprc == -EOPNOTSUPP)
-			data->symlink = true;
+			data->reparse_point = true;
 		else if (tmprc == 0)
 			CIFSSMBClose(xid, tcon, fid.netfid);
 	}
-- 
2.39.5



