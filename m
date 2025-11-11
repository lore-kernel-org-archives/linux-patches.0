Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C524262FEC;
	Tue, 11 Nov 2025 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824821; cv=none; b=trNQX8GXpTeBv9VnoxJJ9BVT/50MCDk38jn9zyoDZUNHNTxNe2rsJotJDf7XG+rWdwv1QQskIwcfC+BklmVenYo0yglwmromrw5+FkPDg6BW2TWuq4CeeMRtpnJYOlTLsBSMBLiE/XgGC1LYSixNkM+zC/Un/+GaRFGAxIYN1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824821; c=relaxed/simple;
	bh=NtdDS693VfKcxCa797bD9Pfx7TD93GFfO/vDVBCXJ8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUidZLhJ9R32sDfaNUUVf/SnzYDS6FmNACrg1US1wC97p2KJ69dWBjo1YAorzB4acYYcaosT4CTpxlh6YTjDrJhVasfluBHcDfIxmuFff3DobcXzhcWc/p7Mn6f171si6gqnkHiuDfGinkZJJZSRb7DZFuJFb8hdNOfXo/9XhlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJpmKrhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJpmKrhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62E1C4CEFB;
	Tue, 11 Nov 2025 01:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824821;
	bh=NtdDS693VfKcxCa797bD9Pfx7TD93GFfO/vDVBCXJ8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJpmKrheFQJ+cxYr+5zmQyrhxBTxi1dwBKim+VQIUWV7HiQnuDWA+NvgL1dWIUjZx
	 FTX8nA9Xpf8GHJIqdJUdTRqmGidAQv6S0Y1IZlj0R/aDLdI8sny8RiqeS/I3rkNvpz
	 PrqLVKV2ZMrroAfch+xlt1z4K+oQvpk6Ppu3UUrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 576/849] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Tue, 11 Nov 2025 09:42:26 +0900
Message-ID: <20251111004550.345356229@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f319f3af04009..566dd84e0677a 100644
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



