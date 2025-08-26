Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE21DE4CD;
	Tue, 26 Aug 2025 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213394; cv=none; b=KiStXLWvkSl3gfSX4ZNXvKmeKvqlGRyCBUOBnHxTqnZ8xtpn1Kg9+BzeWPasWvBb4l+j6gl5WhUK3byo4KzyVHs+WDGw2i3nlxYosVuESp2fPTBzyBL3S9zWmvyBRrCGP0CWQE6SHnHO6VmhaEhTTNDNHBhO0uDRSpYYgHuX/SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213394; c=relaxed/simple;
	bh=z/YNKg0wW7/io4yeZhN/AwcrJywrOj2H5xEhxfYKYho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc4Z14WmiKpIO2zatozQMV1JrKejHy8cO/JWfPdR2GCxusCRGum5BpmxksQDPMLfMmV5sHjKUk+MxgyFIb9DlJLo6I8C1mrNRq0TbsDkF3EEXOyAjCnhYd7y77g68IB0YxEa9teFoYuFcjpzxUrBlY1CGYecplbYS/5XepBSheo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEQhupIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEQhupIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E84DC4CEF4;
	Tue, 26 Aug 2025 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213393;
	bh=z/YNKg0wW7/io4yeZhN/AwcrJywrOj2H5xEhxfYKYho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEQhupIXvpkhWyq9XTSXDA00T3wKXYkTpYlI1RnXX05MqMJpOtviUurvq+gANWVYg
	 A8Pjl4Usx3fhYs7TzGzwv2z6agKqb17Op9Wsx/7dCrQydspraliVYQZhEfcjuz/Gq/
	 yFbO6RKQV09NUANyURRS43SOOUQDuYE/B/OAFuFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/587] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826111000.405857805@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20662b4f339e..6b6c964e8076 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6291,7 +6291,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



