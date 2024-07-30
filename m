Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1B3183CDB;
	Tue, 30 Jul 2024 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358009; cv=none; b=evbjle1Tq+mbXORuP54EQHDwtDwq3I4dbThH/jKWMlhEwwDe/Yn7qEf4YB97fqjbf+/7T1CiYI1cauPFM3lWnvcp51BuEGO+xkcQPkOdrQbdvw47EGp0ZTVm3w78SoMJMuUk/3WQecDZv4iw0tEP7PaCSaRFIdZYySPbsneifXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358009; c=relaxed/simple;
	bh=M7WoOCIovlYrDjnNWYZsR1NRfAdTwxdEBfhYfo8qlUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l639PdymMItD4lb8UA9YzBDfZ6XI/SBK8qL1Znv8gsCNot+Bz854m8ILCOTG1ifndvo4Fjdw3j+9eppLioFlJh+HRR+WjZt11Fs+A8qvesm+UYN2T2Hp3AE+Int2YnOC82AZpEjGNEwcRsTm4fua5Alb8nPl+3oPHocCQPFEL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz3v/CKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz3v/CKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB433C32782;
	Tue, 30 Jul 2024 16:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358009;
	bh=M7WoOCIovlYrDjnNWYZsR1NRfAdTwxdEBfhYfo8qlUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz3v/CKKOvkY5Rrnu562f03ybglIPvosA+On3HptyBGu3XG4g6x3lCH7fK3r1SZeN
	 hk2qzQNqFQyPBcmt3SWnVsIH7pU82rByJENbwNgN/JrA9C/pgQekbg399Hhc6YnnXG
	 I1aNLb0PukOgqpbRuL+bK0wriIPvSWbms0Jv2buw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 348/440] scsi: qla2xxx: Fix for possible memory corruption
Date: Tue, 30 Jul 2024 17:49:41 +0200
Message-ID: <20240730151629.403945575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit c03d740152f78e86945a75b2ad541bf972fab92a upstream.

Init Control Block is dereferenced incorrectly.  Correctly dereference ICB

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4667,7 +4667,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


