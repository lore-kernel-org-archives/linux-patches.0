Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733543F0BB
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784903923; cv=none; b=dvLKA47pYiKMwtOPeTJmzS2BezFot62sG8idcuwcqIBv37By1SxJDtZlQCgZLE4sYYpW+xkTeheXPp5CiLayer9rsav4S9WKkL1dfEWrqtsG7NnZPUetTuLEMWfeNLntEo7PGU8hZ74L5ZQAtR78fAFdC84zf/CvBVVq2irLWKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784903923; c=relaxed/simple;
	bh=lm/3m0E+OR99XdNQuNBm4hQ6PIK+sOHQwDCjieaOlU0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nbq/jUKw8LG5Hjaicf0MPF2XSwXay3jbd+BAW4HjCO2AEqOrPAYo2efdMtvNQiTfOs66m/4SoFs7lSnzEyAsmukusW05HzKk3pvweN4fFDJexFFpzr+b4dg5Z2oPC1gFE5kxiBB7olRDusY4cbV2ExmacL+JA0cE8oMioLRktwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=nTb5XZi4; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="nTb5XZi4"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODchks1881496;
	Fri, 24 Jul 2026 07:38:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=sDmEokgDd
	jmyDfRpWHJETOGYoVzHVfTmv9wN91e9cR8=; b=nTb5XZi4q6BPunUE6wkV6hbBQ
	/lz1WQm+/SZARHooAsmMvuy64VQppVYkbCEbyhgGIee+HxHUPb61t+h7asDO04tw
	oNCSW5ZX0SGsGqmyJTfs6CmXPusv1++QPh8ThUw2I2z6JbK9WTpa9DrgZWecEUbj
	nIZ8I+vNVBcttbM/py+CdX18wMP68qj/FexjS2ZCDQC7NY7k6on3kBNOjs4iCrLF
	DEJl4PJ/iSw7ipX0RxRmemJKzGrJfBtRVay3voqKz+uzPlxOZo3CDM9ZgzTnX4mf
	oZbq2KVrT6poJBKmB/YER4Yj1BwYlv8XLE5pPtDKYR0SWjsEFzx1wLqLnhd6g==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fm8ay06g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Jul 2026 07:38:31 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 24 Jul 2026 07:38:30 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 24 Jul 2026 07:38:29 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <gregkh@linuxfoundation.org>
CC: <harshit.m.mogalapalli@oracle.com>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>
Subject: [PATCH 6.12.y] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Fri, 24 Jul 2026 22:38:28 +0800
Message-ID: <20260724143828.1668805-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: e0-tUkH4gBO1u0rnWU0ZEHdiGzKiCzX9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzMiBTYWx0ZWRfX/zv5Pa+hb1E0
 TOiYPdzz0Cum1SEl0vpuhw+OQlFKV0zrICyXjcLxG56IWqeP5HMkCWI04E4QSY++M+YHShK5umM
 d0nQKQmdZNbL5JVQGx4+T4Z3oO0mtRa/iQsGRZMx68Xdb6BW63vkQzlBhyUx/PTq8TEtz5P8Gxo
 dIM5gmQd6NRJPBSwE03bf8YBJoa3prUYQqAMehWgQrKRdx5ZJLq96xM2jTRQ80HFNFnAjffOZFX
 NMySbalI61ZXWBySLqqMxl0EL/JWCnI4igTJu/Jf+LEeP4a+wvnh88ke0QOlqTwTb3zsRR5FfOE
 D8eecp66bgkZrmOvCXNK0C/8Zj+lDop7j91X5SOj0kFDzAw9aE+lZgTlF1LSm1jTrFOR2FaV2pf
 wiEEkLTfeQrSQG97/BXe7j8Tgh0LGApRvnEnK+vKvGnw4XdoiFq3x0DsLazyKpkykfR/XDx3uo/
 OSEfzLZZCpNkInvOR5Q==
X-Authority-Analysis: v=2.4 cv=LOFWhpW9 c=1 sm=1 tr=0 ts=6a6378e7 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=bC-a23v3AAAA:8 a=t7CeM3EgAAAA:8
 a=hSkVLCK3AAAA:8 a=RPJ6JBhKAAAA:8 a=sbZrjurcE57j4PJPAZIA:9
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FO4_E8m0qiDe52t0p3_H:22 a=FdTzh2GWekK77mhwV6Dw:22
 a=cQPPKAXgyycSBL8etih5:22 a=fa_un-3J20JGBB2Tu-mn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzMiBTYWx0ZWRfXxKfjRoFQw7p9
 LKQJvm3jSU4iT2qjsbcuTj1EJV886Sf/Ol1bdu13RhBrx0hnrTQTEPG0MlyIjzA/TYH3etpt9qM
 AvkUwYTi1QkJROFBgCwjkySvgIUkNBc7+K6U9fkIInMEf2aYI6gC
X-Proofpoint-GUID: e0-tUkH4gBO1u0rnWU0ZEHdiGzKiCzX9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240132

commit c143957520c6c9b5cd72e0de8b52b814f0c576fe upstream.

Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
belong to the same superblock as the original file.  Currently, this
validation is performed inside ext4_move_extents() by
mext_check_validity(), but only after lock_two_nondirectories() has
already acquired the inode locks.  When the donor fd refers to a file
on a different filesystem (e.g., overlayfs), this late validation
creates a circular lock dependency:

  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
  ----                              ----
  inode_lock(ovl_inode)
                                    mnt_want_write_file(filp)
                                      sb_start_write(ext4_sb)   [sb_writers]
    backing_file_write_iter()
      vfs_iter_write(real_file)
        file_start_write(real_file)
          sb_start_write(ext4_sb)   [blocked by freeze]
                                    lock_two_nondirectories()
                                      inode_lock(ovl_inode)     [blocked]

With a concurrent freeze operation holding sb_writers write side, this
forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.

Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
it fundamentally requires both files to reside on the same ext4
filesystem.  Moving the superblock check before any lock acquisition
is both semantically correct and eliminates the circular dependency
by ensuring that cross-filesystem donor fds are rejected before
sb_writers or inode locks are taken.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 99d185d00f37..e437cf1a84e5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1366,6 +1366,11 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto mext_out;
 		}
 
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
+			err = -EXDEV;
+			goto mext_out;
+		}
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			goto mext_out;
-- 
2.43.0

