Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C518787A;
	Sat, 17 Oct 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252669; cv=none; b=fV5pgTlua6oDrL5XgdTzPC3D6Mey0Ri4XbVN/GIBoy4ru4W0U98Ml1Y8iyu2qUmLD9N/PYPgrJgTREVzazWOxD2OpoxGBUA/TQEdPB2DsC03u/U2LKBzOHSqYOliPf8ThsJu5aIH3V5ICrASGVcRIXk1xtM/S/tFNVHroOl4tU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252669; c=relaxed/simple;
	bh=IHTryepLK5nOJdWfvU0JvJ/6cZfyrkCNCxOeyFi+ciw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBr2FkIqS0WrdW+vVIQ7lcRn/Vcznc37tpFhiBFjkNh1RxhQtcWJLSpI3V5gROjH16Ip/59V3XidLTt0r+3PKiXBTgIkpIbfH2QoCH1FDxASXDvKeUocK7QFWUMX9zzZOY8rS5e6Co3EBX+uoArGn9+SIYX8Xki6MRSbCH3BXjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4AHQBp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4AHQBp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0111F000C4;
	Sat, 17 Oct 2026 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252668;
	bh=icSmCrau58n2hCrorwLgYKtniNqdE/jcoPnfogBjwp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4AHQBp830YPSBAVPCZVKPYziYed0uugalz74LQe3hZhE1e398mFDgLr9aIjW3DEB
	 iPXBNpBI3H9kIY+m32wRnpb4k0R293/vbbwFAzlNe5aG9xViy2+y4AYvrAsPYXgKR0
	 D998sf+/DxW5v9UflupPKFV7t/SxrOBTW4IDlB84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 24/52] scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Sat, 17 Oct 2026 17:54:25 +0200
Message-ID: <20261017155105.637734216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit dd4299af9b049c0dcb28699327ebc1386aab4b2a ]

Since 'tag' is only used inside the if-statement, move the 'tag'
assignment into the if-statement. This patch prepares for introducing a
WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if the tag lookup fails.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-9-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c9bdd4140fd04..8780be79a0f84 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -307,9 +307,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
-	int tag = ufshcd_mcq_get_tag(hba, cqe);
 
 	if (cqe->command_desc_base_addr) {
+		int tag = ufshcd_mcq_get_tag(hba, cqe);
+
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr = 0;
-- 
2.53.0



