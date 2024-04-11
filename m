Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5FD145B13;
	Thu, 11 Apr 2024 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832082; cv=none; b=VJ2bB9xmgAI1YYHk/dLZsMdj0V2SvfF6zwFIwm4bolFVM4QSRed0C0ydsPYAX+3PqXuBj9Uz0FnYdI9dyLA3Dkve6SjA2fLHfbPdPbKHwKH/KvFhRYMvCyJwAbPxM9okVL/ymcSdIKvicFwtfiK5FNrviOFrPNMaNx08xnUlras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832082; c=relaxed/simple;
	bh=sX5TBBI74zNGIZq3nkmJsPb2VdZu/8z99BnDx3PG25A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lusgzzb3zfuRqv6uwfqiogAOK+IFhW9P4vdMALxynIg8lUqI0No648TrkE2eKkt/jAOaED9dGm3nIb9oA98dj1/EGSeqcAvi2ryn03v/o0RVfkwYOEa3I4ApqSdsvad+hwRMjf7H77ni/zKfXc3qzpdz1H0vGMqepLVvfVGNUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/+ycNst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/+ycNst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E92C433C7;
	Thu, 11 Apr 2024 10:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832082;
	bh=sX5TBBI74zNGIZq3nkmJsPb2VdZu/8z99BnDx3PG25A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/+ycNstQL/n3khct+1HeNme4iyuxKbg0/4hOQFpngmDHenHnirtd3pijXRkVnVeS
	 V5fPMmRJkn57Nwu7F1W63+VUcmonp11OedTIBQWJpblRv87GkK1GK3mc4i9Km2wSjl
	 Y6KxgylIfH+AENgO9Df7FMWtHajb+QB1kPznUAUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/294] scsi: qla2xxx: Update manufacturer detail
Date: Thu, 11 Apr 2024 11:56:25 +0200
Message-ID: <20240411095442.276344075@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bikash Hazarika <bhazarika@marvell.com>

[ Upstream commit 688fa069fda6fce24d243cddfe0c7024428acb74 ]

Update manufacturer detail from "Marvell Semiconductor, Inc." to
"Marvell".

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7dfd93cb4674d..b8628bceb3aeb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -56,7 +56,7 @@ typedef struct {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
-- 
2.43.0



