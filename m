Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AE1309EFF;
	Wed,  3 Dec 2025 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776235; cv=none; b=UamvVZDbh0C6QG0YQgUU/4R5cTPgJt1cVcXDdVHhY2gUqtVLkD2K5jtECaafms7ApGsdX8syrz8XIOyWrkF9VW178vau0d9tgc9wSp7qTTkvFtFesNIpWaRV0POnw2bWlZxtep4VFXAJdFCsjHugMm5RY8RPig85QNza+hQOHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776235; c=relaxed/simple;
	bh=K1GnGJvPDMeh6wpJUrkwaXFPlJwMYTznr7NaND67InU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppOn7dv/63x19h/51mm1RzBAyP2tOhXb9iovvmgZWQf8nL7XFqyOebuMPQtNmD1Ck1wGxVe4sO/CcCEVHT1iLbwMvElNzqqauJk7x5ir2Z6CMa/agDB0rwRepSgWjp/cRQCmmwe/IAKZU4pTPh2kDbtxz7oXLB1wIW3ambfuQ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrFvniCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrFvniCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFBC4CEF5;
	Wed,  3 Dec 2025 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776235;
	bh=K1GnGJvPDMeh6wpJUrkwaXFPlJwMYTznr7NaND67InU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrFvniCAfpCq5DcXrptGlBZmvGMMGWMkDFGgcCFGw4mdpJXh3hHe/2Gy6rOgiEAP4
	 jT83B9VVI0IrZgt+09GB+6RLt3WtJdMXfMtaHQpqAHhKiDi+ZuVJO/69RUmglOBl0a
	 IaBEWOvOtx5VHdYMbSik13Wdgg0+hzoL4UmWv920=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/300] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Wed,  3 Dec 2025 16:25:25 +0100
Message-ID: <20251203152405.100618831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 5de09770b1c0e229d2cec93e7f634fcdc87c9bc8 ]

To assist in debugging lpfc_xri_rebalancing driver parameter, a debugfs
entry is used.  The debugfs file operations for xri rebalancing have
been previously implemented, but lack definition for its information
buffer size.  Similar to other pre-existing debugfs entry buffers,
define LPFC_HDWQINFO_SIZE as 8192 bytes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-9-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7ab6d3b086982..cb14a62bffb28 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,6 +44,9 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+/* hdwqinfo output buffer size */
+#define LPFC_HDWQINFO_SIZE 8192
+
 /* nvmestat output buffer size */
 #define LPFC_NVMESTAT_SIZE 8192
 #define LPFC_IOKTIME_SIZE 8192
-- 
2.51.0



