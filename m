Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DF0258A;
	Tue, 26 Aug 2025 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216575; cv=none; b=a7zQgj3adYSJwS/tuiIhAdkLWvm8IJqAbc7bexyOt0JwmKW3tofpkqIw/4jgHkccCChQLt1jHdqfGa7ldtQoL+HaQ4vDAXn5vv0T5mpirsVMCiyPDHrnP401qjuQ03bl54nATF7N+3N7u1lhnoH0V4ecAXCWpZMesYF5Rf05egk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216575; c=relaxed/simple;
	bh=Sh6XFfxUWk6ukS3MMbDBSANAyrCEOKP4VtWjWlvkc6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPGvzBbYwGBoki4HR5uswl9k65wIvIDXSh4HJyrRTBf9xMAARhsfu+76f21SB4Dh8S5UEFa6hCr6JZfo0pv80Iqhey1W0/HflPeEErONQECS2eIxDrWeM1DtAeThfSU6UvTYYwSyoRHwsPnfApgdEWphor4EQiCzU6zM9jK4Jp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K68hyj+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K68hyj+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB15C16AAE;
	Tue, 26 Aug 2025 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216575;
	bh=Sh6XFfxUWk6ukS3MMbDBSANAyrCEOKP4VtWjWlvkc6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K68hyj+SwlBSJMswLYlI4/pTd64szOaoeKUmHox6diphKj/oKsv2/iahmK81nlEWq
	 /kOQ1cnGNdxkZERpwLI5/ItxJ47KU8TvDZ+NywEw+bo038nEvHQ+dA+XaNE/MWI9C1
	 TB7S6Bs4Q7sAEdFX3/q/xQYDi5oDGmWGL7N9DJY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/644] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Tue, 26 Aug 2025 13:08:46 +0200
Message-ID: <20250826110957.244806722@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a15ad76aee21..b2578186df63 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6279,7 +6279,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



