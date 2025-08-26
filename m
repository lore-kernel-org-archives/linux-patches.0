Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791341DB127;
	Tue, 26 Aug 2025 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214706; cv=none; b=taCVwSuy/jAt/IzV3TzyOzIMt3axCIwffss7UQLQ71Ub7gX6vIxHuaM1gUZxmsvp6rXNLeVAS0cR7+lsIfonW/COaeSU30R+rFZ10YALKihOOZ3Tdm3+aEYq/08jnRnTCvHnBOn9kewqWIg24xGIRYE9QaEvz7iiPTWmaB0fUoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214706; c=relaxed/simple;
	bh=8b/d9nWM8i+B1ad1cGAIMbOme6l8B1NiStR47dAQdc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZllL6ioGBEN4JcTjkw6NQvM3ptZJ4TosumSPzrdzAAsR0gJyX6PmZvvuLEJHx2+AWR4mS+rfDiJQaCar8vMEgI9DlZDwx4UV6TYWAThZp04+x7siyZMmfBQ3IobnYhirCCxUj3B+fpcNQ2hJxVjmVW284HxKUVR84OP20EX4Ro0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGAPQmze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGAPQmze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F3FC4CEF1;
	Tue, 26 Aug 2025 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214706;
	bh=8b/d9nWM8i+B1ad1cGAIMbOme6l8B1NiStR47dAQdc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGAPQmzetK7oBjd58ADsNWQ4wtuk0dp0Lcg3sF0YYO/LbV3FihdTGiR1zIObM+X5t
	 hPDpVbMH1h+3uwrJWXNrnCKUxKd4qQUtRZQ5ruXky5mt8jU38no2wBeLr0InGo91K8
	 KoK2ZnekWM9aj9SNid4j1UN/52hbh0ufWKPKQG5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/482] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826110936.652324833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 250d423710ca..f149753e62ec 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6287,7 +6287,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



