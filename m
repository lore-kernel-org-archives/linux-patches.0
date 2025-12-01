Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBA2260588;
	Mon,  1 Dec 2025 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588648; cv=none; b=kq4blzIpCrebBUHd7Jji0UAaH501N0ct1GcfOb9G7ONss24rj312cSXMUbxPGF1q7E4kjSUWkpBIq7x+/Ig4/6dawOtppegqcKXgLECKeuO/fYRo42VGDuy5L6T3FoXvjFZ2OX1Wojc5ApH5WLbg1JiLfyF5RjFrec8f5HL1mJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588648; c=relaxed/simple;
	bh=Tdp66HRPr35lHWXmCaLkXmKcRxYPuNXzsFmst8hKOew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo/uThabTAApGXoQ0pmDeKiyYSYpBuhjjmHhxwyofNqPV3kVJOT+6k1E+w6L29ZILp+pF/LRperc02+2d9hdtsQsb45tRt7PpVPQj+dr3CIEOQ5utdh1c5fTgbLKsW1Ji33wM2ZbCUImJ0pHDT2QxdJtC41sCy0XGqVMjbJPI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2lwpN8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2lwpN8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47DEC116D0;
	Mon,  1 Dec 2025 11:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588647;
	bh=Tdp66HRPr35lHWXmCaLkXmKcRxYPuNXzsFmst8hKOew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2lwpN8ZjfyArNxht26rozpp3ty1QgVweMoiKDQuZWA2sRLKvIbdho+VnPs0ERjrr
	 OX1T1/bp6rFg8ZVGAzG1jQtHRsB9AT8QlqU3ClxbwYvmudVaXZL+LDi0mZ8CAklfAS
	 t97DQnplXWU754H0+VfCkvWVgt1lvi/0FZv6HeDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/187] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Mon,  1 Dec 2025 12:23:16 +0100
Message-ID: <20251201112244.411667034@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 20f2537af511c..6cd5605ad00ba 100644
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
 #define LPFC_NVMEKTIME_SIZE 8192
-- 
2.51.0



