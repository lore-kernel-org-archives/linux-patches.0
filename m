Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396797F474;
	Mon,  8 Apr 2024 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585081; cv=none; b=kDL1shy6Jn0L4zWGqYoCdsbUNwwbV6tjTapgFhpCvM2DS6uzwuVAGjKWMJ+Q0t2wty78rW0oUbHhN2zAeh/tPQbxsjlsY1FZ/iRzWZCJqHxYK3M+KJcgZLvjOjzdFweDDjg3WloMz6gqurAL8J3U/k01ENbzQfPHydeGAW9yjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585081; c=relaxed/simple;
	bh=S3uv4tWdnux7Rs7K3YwLK7/2vINMJ58B5jcIpFigX5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhsazp77B9LfK0jpV/vy0vzMkwMYZixNS9wNbqQ/WoIp5iMpCyebiqql4nkHDR4MOL+c0KZKKLUPJR+DNrDNppS3ep420f7KUUiyztMObhC8nQEOyvNOrr9vvaf7u5FBw06nvJvQaCSJykvOlAAeWGHRFOTUylwDSa0WflNhets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYhhy5fN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYhhy5fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2499C43394;
	Mon,  8 Apr 2024 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585081;
	bh=S3uv4tWdnux7Rs7K3YwLK7/2vINMJ58B5jcIpFigX5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYhhy5fNP0XkibPeyeB22zGFRBqg3JKNOKDSVZ9+QdSSk3DcCyjEHMJVGl0Pjeckl
	 hrdUPi5aVoWSKbm15HAo/wXCOQZzAy73QyVqWxoXPUz1rhjuiko+bQgd4yVzyNlTAz
	 Bx9TMmffQXBWJn1zqa17VQj28qifFQZotp/5GBVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 657/690] scsi: qla2xxx: Update manufacturer detail
Date: Mon,  8 Apr 2024 14:58:43 +0200
Message-ID: <20240408125423.462089289@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bab890f1110a1..87ada9b447170 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -78,7 +78,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
-- 
2.43.0



