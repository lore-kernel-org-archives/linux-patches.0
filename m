Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9D22147E3
	for <patches@lists.linux.dev>; Fri, 16 May 2025 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747357583; cv=none; b=Qqcpq6obwzwf3xuGkIMhLHyU4BCP8mcEsxe3LAdjbCA6dnGmeXX2tLxYSnLN0Hu7tmcKH/nmbqNkZAHllTMZ5+FwEyzrRO3GICxtbya7PYNA77JIG5Cz7P+24SXKPM8N+W4CiarbG32nAOtC0VbbgxB8s7HHVZXrT7iWCcurIoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747357583; c=relaxed/simple;
	bh=iWe+pDg3nhAToeNEy23pymMfv/bCCn4vhsW6Rod9HCw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=izEtCzMakxNJAh80Fkpususn6wv+Cx88xrDcD/1U8ehWj6kmaWwsaMv8oGQ9B3HRD640gdDb41zEZRujubORX24GQ2xFJysM+AD/IOCxbRSUtosGZWiJNeO9xEp5N8CcAx+Tu+p+mF/ksl8hJMBleSoZoz5lgNu64Xv9z6kmXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G10BuJ025562;
	Fri, 16 May 2025 01:06:17 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46mbc8ujjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 16 May 2025 01:06:17 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 15 May 2025 18:06:12 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 15 May 2025 18:06:03 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jack@suse.cz>, <amir73il@gmail.com>,
        <miklos@szeredi.hu>, <linux-fsdevel@vger.kernel.org>,
        <dima@arista.com>, <brauner@kernel.org>
Subject: [PATCH 5.10.y] fs: relax assertions on failure to encode file handles
Date: Fri, 16 May 2025 09:06:04 +0800
Message-ID: <20250516010604.1344396-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: LE476H6c5nWOaIkZ1Q6JjIi6CpxNNOey
X-Proofpoint-ORIG-GUID: LE476H6c5nWOaIkZ1Q6JjIi6CpxNNOey
X-Authority-Analysis: v=2.4 cv=IIACChvG c=1 sm=1 tr=0 ts=68268f89 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=n2GhSfulAAAA:8 a=t7CeM3EgAAAA:8
 a=Bk0MVvKMp5wsRsodY8IA:9 a=cQPPKAXgyycSBL8etih5:22 a=9NqWk_7B-uqI6kdQTXIl:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDAwOCBTYWx0ZWRfXyfu3Sb7jXs23 9aQdVILgNf138BEGvtFUQkG9ujo42QWDkBRMRqBXDJyF9K9KsKL0fpx/KOsVPEiEWnAmZkS61jj FEQzfipl3rcfWosOOzRt4toWHCNDbaXMVWACLBNdii/fQPz3Kf4Nz0JeEGnt7AJmtpGng+v6uyG
 VhFadNLMrInkZg61uUfrt8BC4DuElnghjVKpwomyhFW6opRzeGadHNUsqQ1CmhqVOXUKTnt96Sk SlxdHm5yx63rmII1pufFF4FhuTk0GKnZw69C88f6yq8k6pBx9ZoH2Dpw7KzTDINgeWa5gGTMolB bTyuVgH/cAjM42mlXcxw5YBLMwT/+v1iZIoo7wCuWeArZIICrqa5f0lwmPcPFC7hmZbHkcMeqVg
 obwGksaXZ/fMeQporw9LALo1ThZTuNPAoPk5OE21Eim6aMsiIOPyfv7l/87HwgPzfjY82oBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_11,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2505070000
 definitions=main-2505160008

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
index 65ac504595ba..8557180bd7e1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -302,9 +302,8 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
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

