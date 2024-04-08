Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BCF7F495;
	Mon,  8 Apr 2024 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585078; cv=none; b=QMKI8GcQg7tssF5jkKGQxfO+S55VQFB+ptXcvdS1Fdg8AbVC9In+QFw+qtHqamg0UIPAHjrtIOBXwfb4wes+J22PGlzupGZK3qmrGgyOEdrfwON1DFzEIEv2R0S2Tc9yvGj5MZupimgulO48zR4VcXXbrbwuUOHbr+IPBff22m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585078; c=relaxed/simple;
	bh=TwlorOTyyVCUCmXD8634zE6ZUUrx5HKVpulD31f+woc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyZQPIK5g+KKT0VjPJASfCRDcnrge5YlRJ1pkNuKauxLdudw4goNMlzCyw149LO+3Kwu5E6q9ceRWlZqB58g6W+WD8HE1GxWnUGhcF4+pFFaRP12phGpfhtlkQ2l66wZQoWAU2fWcGHe1Aq04UBhz/BLa0mbislRSdf5jz/zRnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWyH/T+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWyH/T+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6EFC433F1;
	Mon,  8 Apr 2024 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585078;
	bh=TwlorOTyyVCUCmXD8634zE6ZUUrx5HKVpulD31f+woc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWyH/T+YKQxfoeUaUEJil9gKWNWmP/M0Y9gaZyY9WBLFwsY/idSkc6/iOWJOb2f/v
	 NdKNuI8s+gyzlnMjp1J8QlIQZfGAh1bOhTkfeNpYRql3USisQLYEf7Oo3cA/BRpwjM
	 Yfm8PSGHJwIeMfzOuOoQT1vkFExWDy4oZ4Wel7xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 656/690] scsi: qla2xxx: Update manufacturer details
Date: Mon,  8 Apr 2024 14:58:42 +0200
Message-ID: <20240408125423.423274391@linuxfoundation.org>
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

[ Upstream commit 1ccad27716ecad1fd58c35e579bedb81fa5e1ad5 ]

Update manufacturer details to indicate Marvell Semiconductors.

Link: https://lore.kernel.org/r/20220713052045.10683-10-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 688fa069fda6 ("scsi: qla2xxx: Update manufacturer detail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 drivers/scsi/qla2xxx/qla_gs.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3c876967e8b16..bab890f1110a1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -78,7 +78,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"QLogic Corporation"
+#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d3742a83d2fd7..b0f3bf42c3405 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1615,7 +1615,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	alen = scnprintf(
 		eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
-		"%s", "QLogic Corporation");
+		"%s", QLA2XXX_MANUFACTURER);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
-- 
2.43.0



