Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362785CDF1;
	Fri, 21 Nov 2025 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733007; cv=none; b=nXhL7zzPKzDVWyqswaV45OqL77zL/7AAuxGs8yDw3cWpSZ2ovt3tGsz6zjxXRjr9+VypdwWDg0JpDw2cYkr4iJaaTunC0dcy8GPMQAvyx+f3t+x6iCPY9+GxRAONEPfdz/hm7YXGGznEyBORBjtl/9G6i6lsWWY/riFIWN5prHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733007; c=relaxed/simple;
	bh=tShpCri8rMd+CK0lwWf0ephLyEuHU+OskiJ+BBaGBr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbgyducyzkIpBgBAXOOQ7p1JDwp3t2O7GB3PytMvXSwnhVq+ntCBp+lZVQRAUK3OdX3uMiZqmbBbfqCTtOgtQm7PNqOBQ/U/i2r0YfAZcgZdIluZJtngihXaHKnLvpRuWEjRqgAMO9wHa6XwkfbVBYEXdwJauB6PkHwQk8jykRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8c43AxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8c43AxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC59FC4CEF1;
	Fri, 21 Nov 2025 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733007;
	bh=tShpCri8rMd+CK0lwWf0ephLyEuHU+OskiJ+BBaGBr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8c43AxBWfZyrImincMXX3xEv2uyRJzaghVPN5thBufvuxHSN0uhb/IqhI933AGB6
	 Gw6MS8oufG4CZw5UMDaimAK9W26nuTkK+R8kVjL395zbpucPQX+QYf5zL/C9JncAuA
	 ZTZuTLWik+wSC23QcfbROUvApn1ZjPwXSKxYPjX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/529] scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Fri, 21 Nov 2025 14:09:34 +0100
Message-ID: <20251121130240.816241014@linuxfoundation.org>
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
index 7d6e4fe31ceed..02c970575464c 100644
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



