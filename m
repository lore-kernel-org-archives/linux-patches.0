Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7731CA7D;
	Mon, 18 Aug 2025 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522719; cv=none; b=XXi5WkhbeGkglON2c8NSYKhMdARPrFmY7oJPD2AhGp5iQ5ZbXjtP3grd+uDmYc+9aNu+MEU9y9QnBV58XRH/t6kVRW5/0oaGhCRrf4Sak1sUTLrApk2jwTXdtt+c37zHlv6wrPM7Fov6dF9p5PSeP0aUWuN1JyeGd9/il/fbcoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522719; c=relaxed/simple;
	bh=kt/269ycwAry4LSHIKNbv1DX9rEB3+jW4alOAn0omSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVgYLt3Yqlm3+hsKqCIcVyem25MHdEBDwnZ74yolWUEm3njxe2gEKf31Ao5VTh091YhqJNS6tvfGP0sLaAGYu30HIgIsPum9C0iuSsu8EGnrbJW6tzOpobywH0tLUTlQvV6n6ztVY+/NvwULh+Gp7/B3mLBe+JAv6vG+sg/XpH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyzHv+GR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyzHv+GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948D1C4CEEB;
	Mon, 18 Aug 2025 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522719;
	bh=kt/269ycwAry4LSHIKNbv1DX9rEB3+jW4alOAn0omSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyzHv+GRxAVPGu71Mn0tnh6g7FCyUn9ZTmRTaSxHYQWEeaba59xS22gp0nR3Mw0Va
	 FIJPGZCEA+Izk3eIYjTTUjeVdGOqW99tcDtAU11MefdFV0GFxA+whlR9nx2DvEOSVN
	 wJN5veQ9b8kuhgScNC7oXYtqWmwgTEs3Vdiyc8gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/444] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Mon, 18 Aug 2025 14:46:34 +0200
Message-ID: <20250818124502.697904211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



