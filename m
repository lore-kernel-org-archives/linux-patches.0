Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214326;
	b=EY3MIscRMua16vHW2QChZkKP8N2pjLgg6XpRXTkp4YYONyBczOxxzC+J1XGFnhgVmnr0
	 iRKxo9QtRv72Q4OcqeE7rFPO55XGuKYfo8tl3Vt2MW08J56bqe5I/XO9uW3PO9u53XPY4
	 hy4rAT3AKbDh7nni7KJXjCQg6pTMn/qP2/3v4jKqTbCdjQuArlZkGDxy43O3QtyZDXJ8U
	 2iDYEOgs4mGvisI+kk1e2IJNRXXRDg5wqihkckRDXTmH9ifpPVC6ipBkWR0wEUGZwh+0D
	 XJXJTmsrNpcjIAx+HMlcQk7TrsFCKyUhfFIVSmrdtBXY2Lsj2oUT9mZBioFeN32otBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLLChNpNSlHGT++IvjCv6y515ZGHqKCTDGuySMASndw=;
	b=2ntTGPjuWnvylG4YhvqbTCG8InV6SpCKCZSodV6HQkY1eaYg2usnoPn0Sdg1mZnScfFn
	 Lin4DD1x/SUe4FA6EKIjGYws80GmlUM2V//Q6WuCpZrZp6WT64EiKM25FWyRi/ZtBLS9G
	 6kBVnSFaDopWlxIzYOwZ9VSC/oJZi3dljqpIcUgKOq2z1aIWJbtt4D8Pr6pU9rXAFa3qO
	 1zDfzN4kuJ7//Qq2nKPVfWIVKEXjGZqsknjR2gK97ZfZf9Z/retpR65nKZaaqwUun0vnd
	 42zii1Wi3AnfTiJuEqxK5F6HL0mwE+u7VV5A4yBB8cUtbWzXrK/FoyCB7xqGd0x+hmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7uLbl4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC9F606BF8C;
	Wed, 28 Oct 2026 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7uLbl4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0421F01825;
	Wed, 28 Oct 2026 19:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214326;
	bh=kLLChNpNSlHGT++IvjCv6y515ZGHqKCTDGuySMASndw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7uLbl4ucu9dsQlxblWXfoi7xdOGUqliBnnblPN6nG1T+5YGsCyMvLNpWGyxR9/mB
	 cDbwxFUIOylvE8sj8P10vh1R+zaovKjX84WX4wZSxq1FmmwKpaRpcG8UO4Nmtc5IVO
	 f44mvTJQMwIQX8bpksYvKzbrLcXd43l6oURc4xrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0820/1887] exfat: remove unnecessary arguments from exfat_find_dir_entry()
Date: Wed, 28 Oct 2026 17:48:36 +0100
Message-ID: <20261028170518.085562397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 72880cb5f157514d797d5f6ab3184bbde671a18a ]

This commit removes argument 'num_entries' and 'type' from
exfat_find_dir_entry().

Code refinement, no functional changes.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 99f9a97dce39 ("exfat: add cluster chain loop check for dir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c      | 12 +++++++-----
 fs/exfat/exfat_fs.h |  3 +--
 fs/exfat/namei.c    | 10 ++--------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index dc12e463be1a0..dda10bca9ac98 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -931,7 +931,7 @@ enum {
  */
 int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 		struct exfat_chain *p_dir, struct exfat_uni_name *p_uniname,
-		int num_entries, unsigned int type, struct exfat_hint *hint_opt)
+		struct exfat_hint *hint_opt)
 {
 	int i, rewind = 0, dentry = 0, end_eidx = 0, num_ext = 0, len;
 	int order, step, name_len = 0;
@@ -942,6 +942,10 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 	struct exfat_hint *hint_stat = &ei->hint_stat;
 	struct exfat_hint_femp candi_empty;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	int num_entries = exfat_calc_num_entries(p_uniname);
+
+	if (num_entries < 0)
+		return num_entries;
 
 	dentries_per_clu = sbi->dentries_per_clu;
 
@@ -1010,10 +1014,8 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 				step = DIRENT_STEP_FILE;
 				hint_opt->clu = clu.dir;
 				hint_opt->eidx = i;
-				if (type == TYPE_ALL || type == entry_type) {
-					num_ext = ep->dentry.file.num_ext;
-					step = DIRENT_STEP_STRM;
-				}
+				num_ext = ep->dentry.file.num_ext;
+				step = DIRENT_STEP_STRM;
 				brelse(bh);
 				continue;
 			}
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 5a1251207ab22..eae52c5b20b2b 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -62,7 +62,6 @@ enum {
 #define TYPE_PADDING		0x0402
 #define TYPE_ACLTAB		0x0403
 #define TYPE_BENIGN_SEC		0x0800
-#define TYPE_ALL		0x0FFF
 
 #define MAX_CHARSET_SIZE	6 /* max size of multi-byte character */
 #define MAX_NAME_LENGTH		255 /* max len of file name excluding NULL */
@@ -467,7 +466,7 @@ void exfat_update_dir_chksum_with_entry_set(struct exfat_entry_set_cache *es);
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname);
 int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 		struct exfat_chain *p_dir, struct exfat_uni_name *p_uniname,
-		int num_entries, unsigned int type, struct exfat_hint *hint_opt);
+		struct exfat_hint *hint_opt);
 int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu);
 struct exfat_dentry *exfat_get_dentry(struct super_block *sb,
 		struct exfat_chain *p_dir, int entry, struct buffer_head **bh);
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index ae36930408e6b..7f84ea80c8a6c 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -600,7 +600,7 @@ static int exfat_create(struct user_namespace *mnt_userns, struct inode *dir,
 static int exfat_find(struct inode *dir, struct qstr *qname,
 		struct exfat_dir_entry *info)
 {
-	int ret, dentry, num_entries, count;
+	int ret, dentry, count;
 	struct exfat_chain cdir;
 	struct exfat_uni_name uni_name;
 	struct super_block *sb = dir->i_sb;
@@ -619,10 +619,6 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	if (ret)
 		return ret;
 
-	num_entries = exfat_calc_num_entries(&uni_name);
-	if (num_entries < 0)
-		return num_entries;
-
 	/* check the validation of hint_stat and initialize it if required */
 	if (ei->version != (inode_peek_iversion_raw(dir) & 0xffffffff)) {
 		ei->hint_stat.clu = cdir.dir;
@@ -632,9 +628,7 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	}
 
 	/* search the file name for directories */
-	dentry = exfat_find_dir_entry(sb, ei, &cdir, &uni_name,
-			num_entries, TYPE_ALL, &hint_opt);
-
+	dentry = exfat_find_dir_entry(sb, ei, &cdir, &uni_name, &hint_opt);
 	if (dentry < 0)
 		return dentry; /* -error value */
 
-- 
2.53.0



