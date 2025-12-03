Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE727345CDF;
	Wed,  3 Dec 2025 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779359; cv=none; b=bBcTeHFtq3ywXuDN8BNwo6+mEsCy3qSNPFRgCilsfiffG0yvwBpoN9ESHNGV8dB81jg37RWpC5dhyyvaiQQoP4O1+JNtG9RDTJxNUFC4BokIAmPqr/e4LEoW7HbOwHWyEPqP/bfhEBJWnDDg/fN9Pk9lJl+QzRLU6Q+pjSTu3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779359; c=relaxed/simple;
	bh=36L7497Yr4JWjkyOuTv23TowsnivOn0r3OKLo+tP+CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toMIpUff3xLpyCSYxY2k2ZnORz9LVZf+gMP8s0cPS6WgoKj39vDXUOnIBrGBgPAF2EUxt65x+DN5HOFSu1zZkOlu0eTSmzqKoAzDn5lR9mUebztz97u4E2TwjLL1bhy2WZcihOfWuIL7djmNlX2GEtSgj3IvOaIV0S8zF8LPYhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMpYVW1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMpYVW1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F5C4CEF5;
	Wed,  3 Dec 2025 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779359;
	bh=36L7497Yr4JWjkyOuTv23TowsnivOn0r3OKLo+tP+CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMpYVW1V4CjyTb4ozsnQldqs4XZgn++CrZLXsZtVKfnLuQtOhejeTjepu31Li2rJ2
	 cf3xy+e+z/blg/OcW8L01a8Y1TjdWAb+mx6yyZxwpZUXEBFCXKO2YDSVS4+x22Fi2g
	 0Qfb6BkNX/CDorLnv4vHHUZB7K3GiI2/E/R3pmgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/568] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Wed,  3 Dec 2025 16:23:56 +0100
Message-ID: <20251203152449.292492350@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



