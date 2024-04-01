Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53473F8F4;
	Mon,  1 Apr 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987750; cv=none; b=e2RXlBoVUOT7ho9Oy7KwN6wHlgz1fP+YJzqh6HMvGnLDc0Tz9WnIjladgs2Xr70NzH3mtdW6/CSTHDeT9YIhuJAIAItFgR38HnRid/ntZvY+RlAk7NhNNK3Wz/phi7bUub+Adk9pspQT3/iAzwsDnehgeWSTrkTK45z5h39wtc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987750; c=relaxed/simple;
	bh=H8DT8BAIBXvvzqUB0kqjTsfNWtbeqmfHoDyln7GGz4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5188WVb1FoqT2Ip6vMsGhKD4iJI+338fMrZfiaJR//wP/+3c8zxk0ysIefi9XCndYopIbplkjIPZDBdcGPwF2S5u4/cqjEJCUF+5weCmAChynBOMVSEQ0MKqZmpXIlYHSIzzcqflsCoeKyFRt5vwd+hk8nl7z/1VJRachu+qeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTHgGPa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTHgGPa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D24C433F1;
	Mon,  1 Apr 2024 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987749;
	bh=H8DT8BAIBXvvzqUB0kqjTsfNWtbeqmfHoDyln7GGz4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTHgGPa6OOaX/wvEejRun600jxc4haSsLXQBR3NUnY284txBVeFUBxRsAdoADsvXS
	 WE9P7XZMi1+NVxGE4wJIN+xaIUQNtOXgh7LC9eUDL7Y7Y9Qv4P0Yz3PrPZxc6KlTnO
	 wU2ZF2MEirTHM45Rq6ahFvGmux2wgQFIP886GCd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 380/399] scsi: qla2xxx: Update manufacturer detail
Date: Mon,  1 Apr 2024 17:45:46 +0200
Message-ID: <20240401152600.521077739@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -82,7 +82,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,


