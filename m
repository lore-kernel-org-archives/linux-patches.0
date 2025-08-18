Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D86230D0D;
	Mon, 18 Aug 2025 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524400; cv=none; b=jX86ffSF5b6EEGtmt3DYhHeB1F0PDlgmjBugTg+zj2CQJqipI96Ozli1+O18ebHCqdIjrymeiVRqd+Qag8o8EyJsZHvWSesellagZurprU4ZUbMDH9JDdUz9w7lZTOMlo8S4Cz+saqFacAaLXAWh3iPqBCzdrSA+ctTuaDUKfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524400; c=relaxed/simple;
	bh=5VOOnwxZNM5Q+xyVmdGkAdD3f1GggCrmrg0216BhQQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdVedPx7OjZNK7rOrA3pl44MDIntd+LWYdSwQ0u23YVxQ4pQuG1C/3vtm8HXnSb3lVWKnaJwIF5L9qZLrYSbVjuDsCAejb4RROd3g3irPLDg53VlzoE+OgqWA9MoIAOP7iM22Pd7F+Qsj03uJoPp7KSMoIiASc7lMKVe3oyptpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvkIWp9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvkIWp9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3470C113D0;
	Mon, 18 Aug 2025 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524400;
	bh=5VOOnwxZNM5Q+xyVmdGkAdD3f1GggCrmrg0216BhQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvkIWp9tvz4IUmylHuNpzZxH4NBM4K46DYVEOxBfAjSXCP3n7Wm+83AgC75e82qTc
	 u+aJYgbs5iWzxkhBQRfAAKDs0synCv5JZaA+oyD7LprhWMRuH0Q2v/gOqRZGw0EI4R
	 /k5VwetoXXFYGzEMACIYn2C8mzxJKwGSom+D7lQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 433/515] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Mon, 18 Aug 2025 14:46:59 +0200
Message-ID: <20250818124515.095596880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fd1aa5cc78c..1b601e45bc45 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6289,7 +6289,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



