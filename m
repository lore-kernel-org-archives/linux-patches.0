Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8A2DE70D;
	Tue, 11 Nov 2025 01:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824330; cv=none; b=YeFpPxMNPlcx/hrhjJcpdNcWxmDnn65Hc+PDE0b5UsKm7KmoYiZZ/khe9uMnPyr3FaMeuCqniyrLMOI1aCU3uUplbL0PGpXu0S5Zr/Jw/uIm0Wk80YvcVSdQFh0FN2aF7zzj5xozdylpfW6n75GmAe9Xbbsh2ZUUbLzlLcPoqsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824330; c=relaxed/simple;
	bh=QZvtXF9LaihNS/Ryga+pBhxzjr1RENPlr0x8trroDDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuZ5gDNEzMF9Ar73IW5WZUrX/msQseg/9o4EmKTz4KCFenBPJ1VRIA1OW6DZ4hpWsyS+WJGSMvw18aexMpXoDPmsvj18pkh2JcDrv/7yw75Dxa1wSVMsoJenwJxQ8Ag6e10NkQcCf12aTvvOYKkdIFrJe+H+1vibHCb4OUo3Qk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyWdRIzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyWdRIzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ED5C116B1;
	Tue, 11 Nov 2025 01:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824330;
	bh=QZvtXF9LaihNS/Ryga+pBhxzjr1RENPlr0x8trroDDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyWdRIzV9b5mXo8nTsvFfbuunRgK69e7zP2SVjiASiXFCJ812+Z0f7Juv2jQM5zYe
	 nCCr8HeECxhRwHWA0ycKs3UfrRUplgWRKdeV3lcZGynjvVTwL4hhhFpweCHGzzus5w
	 /UC66+hXus9vPCaUR8hsYta5UirgeEuE0f3nK9kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 423/565] scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Tue, 11 Nov 2025 09:44:39 +0900
Message-ID: <20251111004536.378950401@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 4be7599d6b27bade41bfccca42901b917c01c30c ]

Add handling for MPI26_SAS_NEG_LINK_RATE_22_5 in
_transport_convert_phy_link_rate(). This maps the new 22.5 Gbps
negotiated rate to SAS_LINK_RATE_22_5_GBPS, to get correct PHY link
speeds.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Message-Id: <20250922095113.281484-4-ranjan.kumar@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 421db8996927b..7faa971856fbc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -166,6 +166,9 @@ _transport_convert_phy_link_rate(u8 link_rate)
 	case MPI25_SAS_NEG_LINK_RATE_12_0:
 		rc = SAS_LINK_RATE_12_0_GBPS;
 		break;
+	case MPI26_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_22_5_GBPS;
+		break;
 	case MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED:
 		rc = SAS_PHY_DISABLED;
 		break;
-- 
2.51.0



