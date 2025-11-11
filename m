Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F482D29D6;
	Tue, 11 Nov 2025 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824053; cv=none; b=nx2uy3aIk872KnuusNO4bX1cKmOuwenDyB8TvQ44Zc/SfVMULAVD4rGI3IsF3RI/P2ksloX4slfDY+dkTnGiTkxJgtx534Voi2Rlrfnl2ny22ngXr41MfzeQ4vQs8x/6u2IMZb/Awc3GRFUu7+tCrjSSX6u8IKStRqFJulFeoKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824053; c=relaxed/simple;
	bh=34BG4s0AiR6jnRHWywbUOeYOD6voloaWB1PXbClJddM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QckTAq78a5dvGEuQ76bvvWAvfRpx/6f/eMzUlAkeiAJ4h3oaG2jrDTjFgiyRYQXJRG7NRDvZdeLTCmyoSFVGuIblO44bjO7lh07jNNot0T85QykUXMIZawKLWf+2RNRfrqvht+dxqN1dn9tzphky9LeWfONox1Xpxeb2mfd3AtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+jpKxo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+jpKxo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FD0C16AAE;
	Tue, 11 Nov 2025 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824052;
	bh=34BG4s0AiR6jnRHWywbUOeYOD6voloaWB1PXbClJddM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+jpKxo8Q+ejHotEjYFaAqetcrBcI1zc2DsD1Y8NYOAHDMln5aEKzucaTRu5sD+nN
	 cs4iHc9uoj1T4VjBhDKQgl1xTL7O8HNXcl5F9BMDTHMd4KZY5ZsV5KE9VkbTFmfiH4
	 DtUkF8eTH981v9BRJZIzf6w1d1AvA7ng3g1DtCI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 378/565] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Tue, 11 Nov 2025 09:43:54 +0900
Message-ID: <20251111004535.374049971@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d2e8d05bbc05..52b14671eaa94 100644
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



