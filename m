Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047319;
	b=dLF1Rhj2hV6bPUbKYOAw0lHXGMwA+Uute6FRQv3NEDz0S3q5tR7ShjrmF0ECSWEH2DL7
	 xM6HEwKUaIke1s6Lu9IipkANGJFt5yapkUrKHOi2o+Nn19wHnrn7LupQswhQNR7R3i3bc
	 MRS4Fmuib+qF4TgpTMa2V3s71mIiet0k4dQ5flN7s77HxcFTS/xeI/M2IH/QcCBgwQmsQ
	 wVrJaYLzPItlliMJYaZ6/0M4PJLRjSKO0My67OH0TQY3pdlWuoutk9FAjDv0XH5U07acv
	 nle3A+DRrURpzJcjYpdhWm/ElJOSE7d7uWuL23dgDhB8yj6PpaimXl2zh12OPvr03zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srwYV9EjSFKuYEHf6HcW1/YNrAi5kYx3TFlSjrHmU0E=;
	b=yFsLd6OsTYrG6FceXz0pb0aDhu9I9GkyAzseif4S5Cz+zvPhXCTbMO+UcwED8JcB4Rlw
	 +FEG5H9HoZrWGsfVe1g62K9uPdBYwEyA9LH69XTnOCbE3dTFVFo6P/Pm4gx/rkSdLhcsH
	 x99MAphI7nQJ3XS/n3WKMO8RIueutMx+zNjBjCYUocVyhMZNODMEz19MfYmhNuvrl3frK
	 CZfqf3jt1x4qLJmjRsi8ufaR6g7bOLeDCZxvzfNp2gAh0hQkkBoO0BykKFm0uBXn7e1u8
	 YoSjFeiJ+XQG5UO+ZLROuHxE0ozc6L0maf+1fUrtaYbvPQh1HrDrYg5XbuxpDyH2hGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wr8Rxu9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85867606A32A;
	Thu, 19 Nov 2026 00:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wr8Rxu9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E8E1F000C4;
	Thu, 19 Nov 2026 00:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047319;
	bh=srwYV9EjSFKuYEHf6HcW1/YNrAi5kYx3TFlSjrHmU0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr8Rxu9cvZNjQURsNLUQlYMlr4o5SrtLmmX8QNlqp37w6w8OQk+9STQts6aR7E4r+
	 5G7EZUstmRBQtVOMp51/wwiq7pfmIsGIAzlJDI3gjHyVRg4qYyW6hHzzTeTJtYx6mW
	 ZctiDukCHcfydS+Op0REo8uWgCPrXjozD6Yrv6/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1555/2857] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150257.372866941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 1ae42513205a38b811afedb6797f9f9c4de37b90 ]

ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
including the result byte (bits 7:0) that only the host controller
writes. A non-zero value triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
syzkaller.

Reject UIC commands that have the result byte set with -EINVAL.

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-5-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: adjusted context to retain ufshcd_send_uic_cmd() instead of ufshcd_send_bsg_uic_cmd() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 118172fd66176..89cb6825dd531 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -129,6 +129,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
+		if (uc.argument2 & MASK_UIC_COMMAND_RESULT) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = ufshcd_send_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev,
-- 
2.53.0



