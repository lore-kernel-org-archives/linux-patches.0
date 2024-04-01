Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFAA433DA;
	Mon,  1 Apr 2024 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990523; cv=none; b=IXO8EDPcRkBJbXBOearLUK9yjHemQXpooRbhHjZg7bVl2xwE/FoP1kxTH7ZLNWjwjKWhLUOjhWr4b0G0SdQWJXEd++q6n1HOAai0KLVfd4zZhAK9rRFPKqPvvUZ02Gej9uBJr7TUZrFAPh1ABv2u3T97iuCfXutCswWQfyE7YW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990523; c=relaxed/simple;
	bh=70eQIHSWtVlagrysCnD32K8tzR2QLQENWTAulpxrhDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNHYy+qzI1LnL28dXVGeNdxPdqUfmeOJNq6B3zvkLhAhfQh41I1ddLsLzHYtgd4W2zrn+6Kr1FY+cK1eui63FBY2E7ei2xj99uQPYZsPpsT2A4ST2bifRvjmfXtAngNDdxvitN3LBk1PjSgus1fcpKdFOBmDCs/+ONZDqaNzwKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZLG1H7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZLG1H7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A432C433C7;
	Mon,  1 Apr 2024 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990523;
	bh=70eQIHSWtVlagrysCnD32K8tzR2QLQENWTAulpxrhDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZLG1H7oJG1BfrTNHWR4c1I4LVBk7/TNQzRWCnp7o7OGcI/InpcbWZgAKe0LDMVZe
	 BDUpELku/cPS2ilLFiynuprplpgrOw+GIA2obxvt1mDFvfo0z0ddfPs6kBSAp1Fx7N
	 S9z7ynuAj+NxfcotipqxEG7pj5O5GvsodVdWSRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 381/396] scsi: qla2xxx: Update manufacturer detail
Date: Mon,  1 Apr 2024 17:47:10 +0200
Message-ID: <20240401152559.272500808@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


