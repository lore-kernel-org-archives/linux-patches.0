Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E78454BFB;
	Thu, 30 Nov 2023 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDVpQ7/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDAFC433C8;
	Thu, 30 Nov 2023 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361749;
	bh=v3+ryIPVD/LD0+PpTbZgpl5e3ECFRvcHLTNEHD7re38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDVpQ7/5Bdf1zHDfQFw37iP2FvxE/1G0MjOKqXH8qug7IN+5lBD73MGBB2N4mtkND
	 yhjSg7pas1YqyYW28YLtsUmFN7u2+cwW6TgGaURltZfZzqpreQ1xV44Sq+KR2lO5tb
	 KhNUls56zgZqSwy3HjyuLr5i++Op2pRS+/2i5+Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Germano Percossi <germano.percossi@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/82] cifs: minor cleanup of some headers
Date: Thu, 30 Nov 2023 16:22:03 +0000
Message-ID: <20231130162136.976462300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit c19204cbd65c12fdcd34fb8f5d645007238ed5cd ]

checkpatch showed formatting problems with extra spaces,
and extra semicolon and some missing blank lines in some
cifs headers.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Germano Percossi <germano.percossi@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: de4eceab578e ("smb3: allow dumping session and tcon id to improve stats analysis and debugging")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_ioctl.h | 2 +-
 fs/smb/client/cifsfs.h     | 4 ++--
 fs/smb/client/cifsglob.h   | 7 +++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index d86d78d5bfdc1..332588e77c311 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -108,7 +108,7 @@ struct smb3_notify_info {
 #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
 #define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct smb3_full_key_debug_info)
 #define CIFS_IOC_NOTIFY_INFO _IOWR(CIFS_IOCTL_MAGIC, 11, struct smb3_notify_info)
-#define CIFS_IOC_SHUTDOWN _IOR ('X', 125, __u32)
+#define CIFS_IOC_SHUTDOWN _IOR('X', 125, __u32)
 
 /*
  * Flags for going down operation
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index b6c38896fb2db..a1d8791c4fcd2 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -105,8 +105,8 @@ extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_flush(struct file *, fl_owner_t id);
-extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
-extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
+extern int cifs_file_mmap(struct file *file, struct vm_area_struct *vma);
+extern int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma);
 extern const struct file_operations cifs_dir_ops;
 extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, struct dir_context *ctx);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 39602f39aea8f..6c8a55608c9bd 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -788,6 +788,7 @@ static inline unsigned int
 in_flight(struct TCP_Server_Info *server)
 {
 	unsigned int num;
+
 	spin_lock(&server->req_lock);
 	num = server->in_flight;
 	spin_unlock(&server->req_lock);
@@ -798,6 +799,7 @@ static inline bool
 has_credits(struct TCP_Server_Info *server, int *credits, int num_credits)
 {
 	int num;
+
 	spin_lock(&server->req_lock);
 	num = *credits;
 	spin_unlock(&server->req_lock);
@@ -991,7 +993,7 @@ struct cifs_ses {
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
 	enum ses_status_enum ses_status;  /* updates protected by cifs_tcp_ses_lock */
-	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
+	unsigned int overrideSecFlg; /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
@@ -1347,7 +1349,7 @@ struct cifsFileInfo {
 	__u32 pid;		/* process id who opened file */
 	struct cifs_fid fid;	/* file id from remote */
 	struct list_head rlist; /* reconnect list */
-	/* BB add lock scope info here if needed */ ;
+	/* BB add lock scope info here if needed */
 	/* lock scope id (0 if none) */
 	struct dentry *dentry;
 	struct tcon_link *tlink;
@@ -1735,6 +1737,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 				       int number_of_items)
 {
 	int i;
+
 	if ((number_of_items == 0) || (param == NULL))
 		return;
 	for (i = 0; i < number_of_items; i++) {
-- 
2.42.0



