Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36714CDE0;
	Mon,  1 Apr 2024 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991415; cv=none; b=VqVL2W8f+zDTNVf6WNMCpKptmjVs7/NrnNW/mXHKRILZwR19fW2AosuFrYOKuR9TcqxAO+NRD/hSClylDv+WqdMM6RjxZqkgR5mdoM1ZcOXABjFijCtg8l/M0ha1ZlOExrGlbl6KuSVBxSEEJ9wgLiFIBKC/24Jc8BqHqAWfPr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991415; c=relaxed/simple;
	bh=8T9GAY8doVbGW05X2oQViEkZrAYa10mGlWiGSn/9s8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtGFcjpYfr0Y3njZkwqqI+VRIxa4LyKv7ErATPT7bgf0tIOrW+rH2GGD0RbsSz5Q0MxVQiNUWCjYx1TyraTSPG/0uKfVk4EwQn+wmzQENOHxLmnFsgfsbUTLI+nOSvZHZICN6nyNm649FETD5HvbIwGazmlvENJsDwh6cpA1bNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfTkNKD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfTkNKD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8B4C433C7;
	Mon,  1 Apr 2024 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991415;
	bh=8T9GAY8doVbGW05X2oQViEkZrAYa10mGlWiGSn/9s8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfTkNKD7hCNI2Y8hW0QyEVmwoXypyfsTGirhOPWQqfY7uu0flNV1SDob1w4WyUnH0
	 EJn+t6T/OFzhQMDMLOfuuRIG4hccl7t41I7befjudP7nXDcsTvAqG3p2WdU2+U5PJQ
	 w8tKrbYB2uQ1tZ/gr/Kpj7WrAB3PaGn0JLf06iq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 258/272] scsi: qla2xxx: Update manufacturer detail
Date: Mon,  1 Apr 2024 17:47:28 +0200
Message-ID: <20240401152539.109359247@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Bikash Hazarika <bhazarika@marvell.com>

commit 688fa069fda6fce24d243cddfe0c7024428acb74 upstream.

Update manufacturer detail from "Marvell Semiconductor, Inc." to
"Marvell".

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -83,7 +83,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,


