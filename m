Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D653A197A8F;
	Thu,  6 Jun 2024 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683281; cv=none; b=MfGghKNhcOHayvLj9tTsuHSlhTZrdtm6KbxEC+GlCtzV3D7QdvbJAWpkVTl2fWvajR0Etp64hN3ACfNzIq6VKlsvQkP6GhzfyDTteqa36YioO6ggjRZx+OYS+J4TuwARZL/SIodbe5aMn+M8vaRa54fcwPnYFvuk4EaNmctgU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683281; c=relaxed/simple;
	bh=sSGJel3ei16Cs9R3lQKxlq/Cfyp70ymE7Vh2sF08+i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSBmzDZPeJOcEbBpKP/uD5geK78IWwCu1rWJPxp0dpYaj1ptbE07eNdy9i/6zsTbsatVj1cxmW5p1xQ+qYCMACjqtwjk1dSnQaDAk3S6KnscPLYcVjwsljI99HenLXsAHI8dOyNBilsJgFAx7Vwz0B7I+pfTD3KU3z9dpO4c1lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTjXKH1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTjXKH1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4653C2BD10;
	Thu,  6 Jun 2024 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683281;
	bh=sSGJel3ei16Cs9R3lQKxlq/Cfyp70ymE7Vh2sF08+i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTjXKH1UGQO95hpMhl8FXRm10xtO2i7qWB26fXUBcVkYNtd92Q7Jp8fs+o7lxJb6a
	 hikfrHuRiZ/13/8QGl/6Zs1jtCNt/xVMljzlYv+irW7BrsIt9sIvvAlXgD5W1zngS3
	 FHsiU4IiQN/J9t1iptS+//TuI8w814cp0Le53RmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/473] scsi: qla2xxx: Fix debugfs output for fw_resource_count
Date: Thu,  6 Jun 2024 16:01:28 +0200
Message-ID: <20240606131705.217363939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index a7a364760b800..081af4d420a05 100644
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



