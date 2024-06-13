Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE2C384;
	Thu, 13 Jun 2024 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281927; cv=none; b=MeAqVoeXWSCCBLLXkyKCqU0I+J5dDF7mbLo+Nfrx446NPDE76QlsFj28ohcQ6uDDSeLmvEAWmSZVMrl89cHLRm0S1rjfckcaFUkVy7Sf1wAyjG4eepYsJ9H7iUhbTrposEjpCZPEdZFuYzNDeVSRKChvOy/iI9ae6AMclk3IlNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281927; c=relaxed/simple;
	bh=oetRoir7vROli0krerKOTWglKPsWWVNU+vkvlAVWZyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9mKp1ly2vfumZJL2xKBP+EkvSNUkAOMuPCLWKH/xxbMVSFAuv7JzKoZTkzK+/FS7teI8N2H5pd/d35rCgsC2k+JNdwCxEpMctaeRsiGjZCAiFqLVE5GGHixqP6n2Eu06pAUP0Q6zfpg3idaKxV97uGuXcHlkcFnYwYea+zbV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy/HTUO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy/HTUO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E009FC2BBFC;
	Thu, 13 Jun 2024 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281927;
	bh=oetRoir7vROli0krerKOTWglKPsWWVNU+vkvlAVWZyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy/HTUO67mauMhnHRaTX3ov+TurlZSYZz/Zh7y2sFpUh5ElQlQhE/3cIRY/v8UEVS
	 OvtK05XbfyxuJYNZmyXLQm7bCT+WJ+kZS9jIsntPXybBD51VM0u7Didzt+zwAGj9Em
	 1e7/Nwo1lC+DQ+k4UUKzI93KqHZfzF8GOiqJfz+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/402] scsi: qla2xxx: Fix debugfs output for fw_resource_count
Date: Thu, 13 Jun 2024 13:31:00 +0200
Message-ID: <20240613113306.151080081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himanshu Madhani <himanshu.madhani@oracle.com>

[ Upstream commit 998d09c5ef6183bd8137d1a892ba255b15978bb4 ]

DebugFS output for fw_resource_count shows:

estimate exchange used[0] high water limit [1945] n        estimate iocb2 used [0] high water limit [5141]
        estimate exchange2 used[0] high water limit [1945]

Which shows incorrect display due to missing newline in seq_print().

[mkp: fix checkpatch warning about space before newline]

Fixes: 5f63a163ed2f ("scsi: qla2xxx: Fix exchange oversubscription for management commands")
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Link: https://lore.kernel.org/r/20240426020056.3639406-1-himanshu.madhani@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index af921fd150d1e..73695c6815fac 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -274,7 +274,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		seq_printf(s, "Driver: estimate iocb used [%d] high water limit [%d]\n",
 			   iocbs_used, ha->base_qpair->fwres.iocbs_limit);
 
-		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
+		seq_printf(s, "estimate exchange used[%d] high water limit [%d]\n",
 			   exch_used, ha->base_qpair->fwres.exch_limit);
 
 		if (ql2xenforce_iocb_limit == 2) {
-- 
2.43.0



