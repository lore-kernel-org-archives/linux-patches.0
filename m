Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5BA8836
	for <patches@lists.linux.dev>; Fri, 16 May 2025 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747356830; cv=none; b=LTcUFSlGCFsOEnAe52O22YN+Cz7uE9V04khUBRhDQfgd5POmjCnz1ktekGwCzRJCq8sW4fUNa6zMH74DrhqY077aPJatt6CNoq1HhM5BLtCMmRJXGvv8Ou/rQ+rxRc/DQmYjoJKI/O0V9+RGmBNpbdzTTCFT4RaROegfdOyPINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747356830; c=relaxed/simple;
	bh=glceSOZsJIqab/0oYXW48BuOtduXrdklLX2aagYci14=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H1/ZnifMZ1qOal7r/Uw6VgJG1jpWYml9Bp3r+yU69AGCBtv+AIJsCrgJVHK95qOU8LfBbOdLRVDVIbPSAu+m6hdgjEsRLq/cvLt38MoUpKeYu2YOz61vpieuyZ5I9K4n2qT3kMXfoaz79FrdM4wEk0n5ljqCttmjgj7ZUrAquxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G0k4oK005745;
	Fri, 16 May 2025 00:53:35 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46mbc8uj81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 16 May 2025 00:53:34 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 15 May 2025 17:53:29 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 15 May 2025 17:53:26 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jack@suse.cz>, <amir73il@gmail.com>,
        <miklos@szeredi.hu>, <linux-fsdevel@vger.kernel.org>,
        <dima@arista.com>, <brauner@kernel.org>
Subject: [PATCH 6.1.y] fs: relax assertions on failure to encode file handles
Date: Fri, 16 May 2025 08:53:29 +0800
Message-ID: <20250516005329.1343966-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: MA6frYc_lTnw5q8KSBGFoUATrA26wPcR
X-Proofpoint-ORIG-GUID: MA6frYc_lTnw5q8KSBGFoUATrA26wPcR
X-Authority-Analysis: v=2.4 cv=IIACChvG c=1 sm=1 tr=0 ts=68268c8f cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=n2GhSfulAAAA:8 a=t7CeM3EgAAAA:8
 a=sJRnz7nxl20XL7pFBdQA:9 a=cQPPKAXgyycSBL8etih5:22 a=9NqWk_7B-uqI6kdQTXIl:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDAwNSBTYWx0ZWRfX5Va+IPzQxmgD A8EcJdiIZGPjRWAojAaMfDZKqiye7hQR8rU9/bK5Ope58klMq2JxVHf7iiBCiigw5YSgIsRSXHV 6VO+H9YlSbIF7QPmbe6fY7+ncYBQHOG1bQ9AOxTMOisq7dHx8WC/hr0U6UFnf4AYqkrdosHKikb
 k+xOQ9ERR+YWQ8c4ZcLGkbMxxUrGgVBFVHApD5PupkHg4FWkXOdW+EHYnnXyX39OfxxfF6Ptrnf UaO9vduOlrstAEZozcyLy5UermqMXlqoWNTD4nbVnpikPjRvD29NT68Cy01rhbtY6a9aJu1QnDN nt+tQCKTyqBOI4XIbdM00vIYwlMg1O9/2a8hQBOJlxOOZ4YKFv8RUCRJyNsPgN992qvC6bEXlFL
 4id+lF049/sv5sZ++UtaM48Nk6pdJpQSnLgFWMbV2nxQoGJrHJtTR36YNSHPcBhLNPeJ/KNv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_11,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2505070000
 definitions=main-2505160005

From: Amir Goldstein <amir73il@gmail.com>

commit 974e3fe0ac61de85015bbe5a4990cf4127b304b2 upstream.

Encoding file handles is usually performed by a filesystem >encode_fh()
method that may fail for various reasons.

The legacy users of exportfs_encode_fh(), namely, nfsd and
name_to_handle_at(2) syscall are ready to cope with the possibility
of failure to encode a file handle.

There are a few other users of exportfs_encode_{fh,fid}() that
currently have a WARN_ON() assertion when ->encode_fh() fails.
Relax those assertions because they are wrong.

The second linked bug report states commit 16aac5ad1fa9 ("ovl: support
encoding non-decodable file handles") in v6.6 as the regressing commit,
but this is not accurate.

The aforementioned commit only increases the chances of the assertion
and allows triggering the assertion with the reproducer using overlayfs,
inotify and drop_caches.

Triggering this assertion was always possible with other filesystems and
other reasons of ->encode_fh() failures and more particularly, it was
also possible with the exact same reproducer using overlayfs that is
mounted with options index=on,nfs_export=on also on kernels < v6.6.
Therefore, I am not listing the aforementioned commit as a Fixes commit.

Backport hint: this patch will have a trivial conflict applying to
v6.6.y, and other trivial conflicts applying to stable kernels < v6.6.

Reported-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Tested-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-unionfs/671fd40c.050a0220.4735a.024f.GAE@google.com/
Reported-by: Dmitry Safonov <dima@arista.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAGrbwDTLt6drB9eaUagnQVgdPBmhLfqqxAf3F+Juqy_o6oP8uw@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20241219115301.465396-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/notify/fdinfo.c     | 4 +---
 fs/overlayfs/copy_up.c | 5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 55081ae3a6ec..dd5bc6ffae85 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -51,10 +51,8 @@ static void show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, NULL);
-	if ((ret == FILEID_INVALID) || (ret < 0)) {
-		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+	if ((ret == FILEID_INVALID) || (ret < 0))
 		return;
-	}
 
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 203b88293f6b..ced56696beeb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -361,9 +361,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	buflen = (dwords << 2);
 
 	err = -EIO;
-	if (WARN_ON(fh_type < 0) ||
-	    WARN_ON(buflen > MAX_HANDLE_SZ) ||
-	    WARN_ON(fh_type == FILEID_INVALID))
+	if (fh_type < 0 || fh_type == FILEID_INVALID ||
+	    WARN_ON(buflen > MAX_HANDLE_SZ))
 		goto out_err;
 
 	fh->fb.version = OVL_FH_VERSION;
-- 
2.34.1

