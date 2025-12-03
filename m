Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4132318131;
	Wed,  3 Dec 2025 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777827; cv=none; b=Wx9K7Zyw43IQ/MRWv1V5Ae4xYsd1/MtFEGqZgMtsR+QHDrn4F8xq/tWZOGSQquk2hZ9mA25EdS/mVAcFn0/icXoFcAy4JYvk51FJLxNectCeq10iRtF9hoCDj1XYeIMpKi34hcoelfriGMQZRvmOR+1UOEB99XXQI/lQJmGpAR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777827; c=relaxed/simple;
	bh=vcCkgX8y/DbNFroXn//FzgjWTVhDScSNaUMXovHkryQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIpRRJ9apsUdPjpOVwss2pWgQvDPUeJDskr0PUc5CUSChyqBwn9oIUfDQA71fxx/of/5tlaaZfwPDuX0zuMtW8rxBAgPquAkFihYGykjmurY/eV9Ss1JkRWwbDxNzg35RRqxBtD/KXPd7349g+Di7L4l1UK5gUGXrKrKr+7OKi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2D5Rqq5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2D5Rqq5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D42C4CEF5;
	Wed,  3 Dec 2025 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777827;
	bh=vcCkgX8y/DbNFroXn//FzgjWTVhDScSNaUMXovHkryQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2D5Rqq5jLx06qiJr0HRaEJmzSotFqFxOeT+YJLLk0pzQA/2hT8uV1FZUxSsNiT2MR
	 JhXoMg3KjOhaKsOR4YgZnCdcPVV585YJ7WcHTot1wQCp5iN2628uIShfFU033kI4rt
	 00JNF1Pb/QWySPHPKCqxwEOJPqf+aw9JIo1lagiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/392] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Wed,  3 Dec 2025 16:25:09 +0100
Message-ID: <20251203152419.931518914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f71e5b6311ac0..89c215bf238ce 100644
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



