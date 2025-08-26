Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE87350D4F;
	Tue, 26 Aug 2025 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218023; cv=none; b=Bi5gUFKIQMXgDn7KWTCUVGpzWWmsvMijXdWl68egAuC9q1jEiTnQ2eOS8GuZdMiUdKAEPBx79LXKoljCiqmXn1DYkbo2iKxJ9TZbXESgX+NCF1OkGbdfVnijcSHARYjCKmsyrpOS8K7jZ/OI3B/ofFm6NC4IFwpIAMN66f6yf2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218023; c=relaxed/simple;
	bh=2pBV91OsSskO4r7RMmUwZZcvj4LjC/BEtL7Ek4gmWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIhld97ZIv6Uq94TuDdaIIPrI3oBYDOVfFhfZ0xD7Bxw55Am785J9/v5L+u0usrJt6El/SP4Q+0OLNwTfzWdltqrTXE4XnrMU+9RR0cBXJzZkwT/0LFhEFlIf+RS1ekVIEWEXvKSD3H07UTRbkGVqbUUTm2p2j4tsyPc+Tfh+zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WuDgDDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WuDgDDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05EEC4CEF1;
	Tue, 26 Aug 2025 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218023;
	bh=2pBV91OsSskO4r7RMmUwZZcvj4LjC/BEtL7Ek4gmWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WuDgDDzx4T5xRcOVv7ygg9h74hqd7CaWvwbFQ5EYJEwyWH6VaFTG8j34IMmk4VD1
	 gQeIqFKquGEwrO/fMY7oH8Publx3K+6acATVZbWJlgfYt88r4Ff6OTGpG+Wr+P99fv
	 GBKfP4LeXNKQ88XCFWemXqm/W2CaQMsgzmZ0HuZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/523] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Tue, 26 Aug 2025 13:09:07 +0200
Message-ID: <20250826110932.784774793@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit eea6cafb5890db488fce1c69d05464214616d800 ]

Remove the redundant assignment if kzalloc() succeeds to avoid memory
leak.

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20250801185202.42631-1-jiashengjiangcool@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f91eee01ce95..c3e77db18945 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6104,7 +6104,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



