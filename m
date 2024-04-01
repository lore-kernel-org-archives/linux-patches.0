Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9404487BC;
	Mon,  1 Apr 2024 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989278; cv=none; b=MFu50ItirsNwtorgjNM01zFTchZI0i4+vV2yWauX/r6TGtd/vMl2REl2+ymQFUMGoGK/bosZVg2oI78oaVyOVoLNnL7DY52VdmO6DvQISBc5nQBzbYKZ7CL6Xz4dO9gQdDMIqQG94Y9UCf4X1+oHoNp8w7AfNwR/hHwgZdq6pEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989278; c=relaxed/simple;
	bh=KyPwdPKevL8RLruA3SLmtkxyv2T66BahGyeGsY5rTVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqoJ5gJeB8ISYFkBdg5ftAFPkay6ouCWu4NStB4ADAkO0r/1/r7whxUVEoLCylncU1VM7jKCOY75+bueARwwnnwA6vPOuZMLPx4JKk6oGEsbIZmgIjjZKXHuj97AV2MATrASeGvhMqVDUuKpaer3Ip/Bvq+zoJzYH7qRhdDMP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnB/4VeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnB/4VeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F05C43390;
	Mon,  1 Apr 2024 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989278;
	bh=KyPwdPKevL8RLruA3SLmtkxyv2T66BahGyeGsY5rTVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnB/4VeC4SsMpjBvztSqnvspnhidPh5MHd2NGENxCJegg2k4qldrt3EggqCl7E66p
	 mR2j8i6p/Tnl0l3LdMQALqyw8+HeRw2E8zuaCOdT3ttRBmjudw2xroojc0OHf2LGeW
	 KDEVlkqplxCP/Zv0seuoZZtA2YG+kkJuPrl0sVD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 415/432] scsi: qla2xxx: Update manufacturer detail
Date: Mon,  1 Apr 2024 17:46:42 +0200
Message-ID: <20240401152605.778228241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


