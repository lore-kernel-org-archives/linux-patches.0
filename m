Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707CE34CFB2;
	Fri, 21 Nov 2025 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732889; cv=none; b=P95kfEpZN0+Q+LEYwMWP7y2+Kc8FWoI+cZ3dtCtLUqYcApKBGYnpoCorsboJDBXGgOIRjbJmwW0YJcfoMofpIIfICK4Q1efr4dq2yN0UeArr1HDbzPpLUavEJbJ1dhAI7z9VkEr0kUVi+KoSV9zkzMwNd1E/a4u+WRUWFPabzzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732889; c=relaxed/simple;
	bh=NP68QcAjcJKKeZlnBWbcBWt2iHatX3BLP8mSSCDeToc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwJncgwtVX2GjtTED0HE3VU6ebyBqvM5tyrS27k0m5q6gHDzESZD01lEWUBY3Lj2Xg9x85YtCNY4wgphp1C/MzK7XebuXCKB0ZPUDjxDz1g7TG9gNwKaWXeprHPtsr5WdVxdE2CfYPpfDQvVimY1nvWT8xFLbAcTLbZG2F1GPx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyK7V1ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyK7V1ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F51C116C6;
	Fri, 21 Nov 2025 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732889;
	bh=NP68QcAjcJKKeZlnBWbcBWt2iHatX3BLP8mSSCDeToc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyK7V1tavDGvq3S6Ipa/sNGK6idy4/w/i+cTLwhojNeT1LiLdXuG1tOJTfn0wRfz/
	 AFBC6bb76fW4dh2sbe37iur0I3fTSSSW+loO9kZ9pp/fesBM5P3RYW7JtULZYRd/1K
	 iP6ksC/FgCcI3/+rZSzKD888MRYJVdmZUkHozs9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/529] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Fri, 21 Nov 2025 14:09:04 +0100
Message-ID: <20251121130239.736649879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



